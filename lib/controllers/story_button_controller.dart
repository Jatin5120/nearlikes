import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class StoryController extends GetxController {
  final RxBool _isStorySelected = false.obs;
  final RxInt _selectedIndex = 0.obs;
  final RxString _storyUrl = ''.obs;
  final RxString _mediaType = ''.obs;
  final RxBool _isAppOpen = true.obs;

  Rx<VideoPlayerController> _videoPlayerController =
  Rx<VideoPlayerController>(VideoPlayerController.network(''));

  DateTime startTime;
  DateTime endTime;

  VideoPlayerController get videoPlayerController =>
      _videoPlayerController.value;

  set videoPlayerController(VideoPlayerController videoPlayerController) =>
      _videoPlayerController.value = videoPlayerController;

  bool get isAppOpen => _isAppOpen.value;

  set isAppOpen(bool value) => _isAppOpen.value = value;

  int get selectedIndex => _selectedIndex.value;

  set selectedIndex(int selectedIndex) => _selectedIndex.value = selectedIndex;

  String get mediaType => _mediaType.value;

  set mediaType(String mediaType) => _mediaType.value = mediaType;

  String get storyUrl => _storyUrl.value;

  set storyUrl(String storyUrl) => _storyUrl.value = storyUrl;

  bool get isStorySelected => _isStorySelected.value;

  set isStorySelected(bool isEnabled) => _isStorySelected.value = isEnabled;
}
