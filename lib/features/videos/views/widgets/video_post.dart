import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_models.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final int index;
  final VideoModel videoData;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
    required this.videoData,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPaused = false;

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
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    }
    if (info.visibleFraction == 0 && _videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
  }

  void _onPlaybackConfigChanged() {
    if (!mounted) return;

    final muted = ref.read(playbackConfigProvider).muted;
    ref.read(playbackConfigProvider.notifier).setMuted(!muted);
    if (muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
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
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
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

  void _onLikeTap() {
    ref.read(videoPostProvider(widget.videoData.id).notifier).likeVideo();
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
                  child: _videoPlayerController.value.isInitialized
                      ? VideoPlayer(_videoPlayerController)
                      : Image.network(
                          widget.videoData.thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
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
                    onPressed: _onPlaybackConfigChanged,
                    icon: FaIcon(ref.watch(playbackConfigProvider).muted
                        ? FontAwesomeIcons.volumeOff
                        : FontAwesomeIcons.volumeHigh),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "@${widget.videoData.creator}",
                        style: const TextStyle(
                          fontSize: Sizes.size20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v10,
                      Text(
                        widget.videoData.description,
                        style: const TextStyle(
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
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        foregroundImage: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/speardutch-titok-clone.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media&token=0f722a80-a659-4ad0-86c7-c2e192e07fff"),
                        child: Text(widget.videoData.creator),
                      ),
                      Gaps.v24,
                      GestureDetector(
                        onTap: _onLikeTap,
                        child: VideoButton(
                          icon: FontAwesomeIcons.solidHeart,
                          text: S.of(context).likeCount(widget.videoData.likes),
                        ),
                      ),
                      Gaps.v24,
                      GestureDetector(
                        onTap: () => _onCommentsTap(context),
                        child: VideoButton(
                          icon: FontAwesomeIcons.solidComment,
                          text: S.of(context).commentCount(
                                widget.videoData.comments,
                              ),
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
