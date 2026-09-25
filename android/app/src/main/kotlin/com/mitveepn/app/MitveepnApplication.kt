package com.mitveepn.app;

import android.app.Application
import android.content.Context

class MitveepnApplication : Application() {
    companion object {
        private lateinit var instance: MitveepnApplication
        fun getAppContext(): Context {
            return instance.applicationContext
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
    }
}
