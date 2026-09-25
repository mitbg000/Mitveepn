import org.jetbrains.kotlin.ir.backend.js.transformers.irToJs.argumentsWithVarargAsSingleArray

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.mitveepn.app.core"
    compileSdk = 36
    ndkVersion = "28.0.13004108"

    defaultConfig {
        minSdk = 21
    }

    buildTypes {
        release {
            isJniDebuggable = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    sourceSets {
        getByName("main") {
            jniLibs.srcDirs("src/main/jniLibs")
        }
    }

    externalNativeBuild {
        cmake {
            path("src/main/cpp/CMakeLists.txt")
            version = "3.22.1"
        }
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
dependencies {
    implementation("androidx.annotation:annotation-jvm:1.9.1")
}

// Chỉ copy đè khi có nguồn native lib mới build (../../libclash/android).
// Nếu không tồn tại, giữ nguyên libclash.so đã có sẵn trong src/main/jniLibs
// (tránh xoá mất core thật rồi build ra app không có VPN core, gây crash khi Connect).
val nativeLibsSourceDir = file("../../libclash/android")
val copyNativeLibs by tasks.register<Copy>("copyNativeLibs") {
    onlyIf { nativeLibsSourceDir.exists() && nativeLibsSourceDir.listFiles()?.isNotEmpty() == true }
    doFirst {
        delete("src/main/jniLibs")
    }
    from(nativeLibsSourceDir)
    into("src/main/jniLibs")
}

afterEvaluate {
    tasks.named("preBuild") {
        dependsOn(copyNativeLibs)
    }
}