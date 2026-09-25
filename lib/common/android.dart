import 'dart:io';

import 'package:mitveepn/plugins/app.dart';
import 'package:mitveepn/state.dart';

class Android {
  init() async {
    app?.onExit = () async {
      await globalState.appController.savePreferences();
    };
  }
}

final android = Platform.isAndroid ? Android() : null;
