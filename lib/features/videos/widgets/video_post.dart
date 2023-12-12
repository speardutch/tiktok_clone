import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/common/widgets/main_navigation/widgets/video_config.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost(
      {super.key, required this.onVideoFinished, required this.index});

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPaused = false;
  bool _autoMute = videoConfig.autoMute;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  Future<bool> _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/video.mp4");
    await _videoPlayerController.initialize();
    if (kIsWeb == true) {
      await _videoPlayerController.setVolume(0);
    }
    await _videoPlayerController.setLooping(true);
    _videoPlayerController.addListener(_onVideoChange);
    //setState(() {});
    return true;
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
      _isPaused = true;
    } else {
      _videoPlayerController.play();
      _animationController.forward();
      _isPaused = false;
    }
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (info.visibleFraction == 0 && _videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    videoConfig.addListener(() {
      setState(() {
        _autoMute = videoConfig.autoMute;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return VisibilityDetector(
            key: Key("${widget.index}"),
            onVisibilityChanged: _onVisibilityChanged,
            child: Stack(
              children: [
                Positioned.fill(
                  child: VideoPlayer(_videoPlayerController),
                ),
                Positioned.fill(
                  child: GestureDetector(onTap: _onTogglePause),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animationController.value,
                            child: child,
                          );
                        },
                        child: AnimatedOpacity(
                          opacity: _isPaused ? 1 : 0,
                          duration: _animationDuration,
                          child: const FaIcon(
                            FontAwesomeIcons.play,
                            color: Colors.white,
                            size: Sizes.size52,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 40,
                  child: IconButton(
                    onPressed: videoConfig.toggleAutomute,
                    icon: FaIcon(_autoMute
                        ? FontAwesomeIcons.volumeOff
                        : FontAwesomeIcons.volumeHigh),
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "JS",
                        style: TextStyle(
                          fontSize: Sizes.size20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v10,
                      Text(
                        "This is my room in Bellevue!!!",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        foregroundImage: NetworkImage(
                            "https://avatars.githubusercontent.com/u/3612017"),
                        child: Text("JS"),
                      ),
                      Gaps.v24,
                      VideoButton(
                        icon: FontAwesomeIcons.solidHeart,
                        text: S.of(context).likeCount(12126312123123),
                      ),
                      Gaps.v24,
                      GestureDetector(
                        onTap: () => _onCommentsTap(context),
                        child: VideoButton(
                          icon: FontAwesomeIcons.solidComment,
                          text: S.of(context).commentCount(999999),
                        ),
                      ),
                      Gaps.v24,
                      const VideoButton(
                        icon: FontAwesomeIcons.share,
                        text: "Share",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            color: Colors.black,
          );
        }
      },
    );
  }
}
