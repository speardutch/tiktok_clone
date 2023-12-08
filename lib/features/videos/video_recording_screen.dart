import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _isSelfieMode = true;
  late FlashMode _flashMode;
  late final CameraController _cameraController;
  late final CameraController _cameraControllerSelfie;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }

    _cameraController =
        CameraController(cameras[0], ResolutionPreset.ultraHigh);
    _cameraControllerSelfie =
        CameraController(cameras[1], ResolutionPreset.ultraHigh);

    await _cameraController.initialize();
    await _cameraControllerSelfie.initialize();

    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    //await initCamera();
    setState(() {});
  }

  void _startRecording(TapDownDetails _) {
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _stopRecording() {
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPermissions();

    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Initializing...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  _isSelfieMode
                      ? CameraPreview(_cameraControllerSelfie)
                      : CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size20,
                    right: Sizes.size20,
                    child: Column(
                      children: [
                        IconButton(
                          color: Colors.white,
                          onPressed: _toggleSelfieMode,
                          icon: const Icon(
                            Icons.cameraswitch,
                          ),
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => _setFlashMode(FlashMode.off),
                          color: _flashMode == FlashMode.off
                              ? Colors.amber.shade200
                              : Colors.white,
                          icon: const Icon(
                            Icons.flash_off_rounded,
                          ),
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => _setFlashMode(FlashMode.always),
                          color: _flashMode == FlashMode.always
                              ? Colors.amber.shade200
                              : Colors.white,
                          icon: const Icon(
                            Icons.flash_on_rounded,
                          ),
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => _setFlashMode(FlashMode.auto),
                          color: _flashMode == FlashMode.auto
                              ? Colors.amber.shade200
                              : Colors.white,
                          icon: const Icon(
                            Icons.flash_auto_rounded,
                          ),
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => _setFlashMode(FlashMode.torch),
                          color: _flashMode == FlashMode.torch
                              ? Colors.amber.shade200
                              : Colors.white,
                          icon: const Icon(
                            Icons.flashlight_on_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Sizes.size40,
                    child: GestureDetector(
                      onTapDown: _startRecording,
                      onTapUp: (details) => _stopRecording(),
                      child: ScaleTransition(
                        scale: _buttonAnimation,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: Sizes.size80 + Sizes.size20,
                              height: Sizes.size80 + Sizes.size20,
                              child: CircularProgressIndicator(
                                color: Colors.red.shade400,
                                strokeWidth: Sizes.size6,
                                value: _progressAnimationController.value,
                              ),
                            ),
                            Container(
                              width: Sizes.size80,
                              height: Sizes.size80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
