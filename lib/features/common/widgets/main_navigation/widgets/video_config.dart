import 'package:flutter/widgets.dart';

class VideoConfig extends ChangeNotifier {
  bool autoMute = false;

  void toggleAutomute() {
    autoMute = !autoMute;
    notifyListeners();
  }
}

final videoConfig = VideoConfig();
