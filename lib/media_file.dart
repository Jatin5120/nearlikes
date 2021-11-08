import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:nearlikes/Services/get_available_media.dart';
// import 'package:nearlikes/brand_stories.dart';
import 'package:nearlikes/constants/colors.dart';
import 'package:nearlikes/models/get_campaigns.dart';
import 'package:nearlikes/controllers/controllers.dart';
import 'package:nearlikes/models/get_media.dart';

import 'package:flutter/widgets.dart';
import 'package:nearlikes/theme.dart';
import 'package:nearlikes/widgets/video_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaFIle extends StatefulWidget {
  const MediaFIle({Key key, @required this.campaign}) : super(key: key);

  final Campaign campaign;

  @override
  State<MediaFIle> createState() => _MediaFIleState();
}

class _MediaFIleState extends State<MediaFIle> {
  static StoryController storyController = Get.find();
  static DownloadController downloadController = Get.find();

  @override
  void initState() {
    super.initState();
    // FlutterDownloader.initialize(debug: true);
  }

  String url;
  @override
  void dispose() {
    storyController.selectedIndex = -1;
    storyController.storyUrl = '';
    storyController.mediaType = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: kPrimaryColor),
    );
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: Obx(
        () => GestureDetector(
          onTap: storyController.isStorySelected
              ? () async {
                  String format =
                      storyController.mediaType == 'image' ? '.jpg' : '.mp4';
                  String timeStamp = DateTime.now()
                      .toString()
                      .split(".")
                      .first
                      .split(' ')
                      .join('_')
                      .split(':')
                      .join('-');
                  String fileName =
                      '${widget.campaign.brand}_$timeStamp$format';
                  downloadController.downloadMedia(
                      storyController.storyUrl, fileName);
                  // await launch(storyController.storyUrl);
                }
              : null,
          child: Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.05)
                .copyWith(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: storyController.isStorySelected
                  ? const LinearGradient(
                      colors: [
                        kPrimaryColor,
                        kSecondaryColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: storyController.isStorySelected ? null : kOverlayColor,
            ),
            alignment: Alignment.center,
            child: Text(
              'Download',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.campaign.brand,
              style: Get.textTheme.headline5.copyWith(color: kPrimaryColor),
            ),
            const SizedBox(height: 16),
            DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      tabs: const [
                        Tab(text: 'Images'),
                        Tab(text: 'Videos'),
                      ],
                      indicator: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelStyle: Get.textTheme.subtitle1,
                      unselectedLabelColor: Colors.grey,
                      labelColor: kWhiteColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: kSecondaryColor,
                      onTap: (index) {
                        storyController.isStorySelected = false;
                        print(
                            "----------------------- Listener -----------------------");
                      },
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      // -------------------------- Images List -------------------------
                      child: TabBarView(
                        children: [
                          FutureBuilder(
                            future:
                                getAvailableMedia(id: widget.campaign.ownerId),
                            // stream: _postsController.stream,
                            builder:
                                (context, AsyncSnapshot<GetMedia> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                );
                              }

                              final GetMedia getMedia = snapshot.data;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: getMedia.media.length + 1,
                                itemBuilder: (_, index) {
                                  if (index == getMedia.media.length) {
                                    return const SizedBox(height: 48);
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      storyController.storyUrl =
                                          getMedia.media[index].src;
                                      storyController.isStorySelected = true;
                                      storyController.selectedIndex = index;

                                      print(
                                          "Image OnTap --> ${getMedia.media[index].src}");

                                      url = getMedia.media[index].src;

                                      storyController.mediaType =
                                          getMedia.media[index].type;

                                      // choice = index;
                                    },
                                    child: getMedia.media[index].type == 'image'
                                        ? Container(
                                            margin: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Obx(
                                              () => Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: storyController
                                                                .isStorySelected &&
                                                            storyController
                                                                    .selectedIndex ==
                                                                index
                                                        ? kBlackColor
                                                        : Colors.transparent,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      getMedia.media[index].src,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                    color: kPrimaryColor,
                                                    value: downloadProgress
                                                        .progress,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  );
                                },
                              );
                            },
                          ),

                          // -------------------------- Videos List -------------------------

                          FutureBuilder(
                            future:
                                getAvailableMedia(id: widget.campaign.ownerId),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                );
                              }

                              GetMedia getMedia = snapshot.data;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: getMedia.media.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      storyController.storyUrl =
                                          getMedia.media[index].src;
                                      // storyController.error = '';

                                      print(
                                          "Video onTap --> ${getMedia.media[index].src}");

                                      storyController.mediaType =
                                          getMedia.media[index].type;
                                      // choice = index;
                                    },
                                    child: getMedia.media[index].type == 'video'
                                        ? Obx(
                                            () => Container(
                                              margin: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                                border: Border.all(
                                                  color: storyController
                                                              .isStorySelected &&
                                                          storyController
                                                                  .selectedIndex ==
                                                              index
                                                      ? kBlackColor
                                                      : Colors.transparent,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: VideoWidget(
                                                index: index,
                                                play: true,
                                                url: getMedia.media[index].src,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
