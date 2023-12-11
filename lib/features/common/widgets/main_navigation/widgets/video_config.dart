import 'package:flutter/cupertino.dart';

class VideoConfig extends InheritedWidget {
  final bool autoMute = false;

  const VideoConfig({super.key, required super.child});

  static VideoConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
