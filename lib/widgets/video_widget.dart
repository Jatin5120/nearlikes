import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearlikes/constants/colors.dart';
import 'package:nearlikes/controllers/controllers.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;
  final int index;

  const VideoWidget({
    this.url,
    this.play,
    this.index,
  });

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  static StoryController storyController = Get.find();
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();

    storyController.videoPlayerController =
        VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture =
        storyController.videoPlayerController.initialize().then((_) {
          //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
  } // This closing tag was missing

  @override
  void dispose() {
    storyController.videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          return GestureDetector(
            onTap: () {
              print('testing ');
              print(widget.url);
              storyController.storyUrl = widget.url;
              storyController.isStorySelected = true;
              storyController.selectedIndex = widget.index;
              if (storyController.videoPlayerController.value.isPlaying) {
                storyController.videoPlayerController.pause();
                print('pause');
              } else {
                print('play');
                storyController.videoPlayerController.play();
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: AspectRatio(
                  aspectRatio:
                  storyController.videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(storyController.videoPlayerController),
                )
              // videoinit==false? Image.network("${_getMedia.media[index].pre}",fit: BoxFit.fitWidth): AspectRatio(
              //   aspectRatio: storyController.videoPlayerController.value.aspectRatio,
              //   child: VideoPlayer(storyController.videoPlayerController),
              // ),
            ),
          );
        } else {

          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        }
      },
    );
  }
}
