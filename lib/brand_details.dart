import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearlikes/media_file.dart';
import 'package:nearlikes/constants/colors.dart';
import 'package:nearlikes/controllers/controllers.dart';
import 'package:nearlikes/models/get_campaigns.dart';
import 'package:nearlikes/validation.dart';
import 'package:social_share/social_share.dart';

class BrandDetails extends StatelessWidget {
  const BrandDetails({Key key, @required this.campaign}) : super(key: key);

  final Campaign campaign;

  static StoryController storyController = Get.find();
  static DownloadController downloadController = Get.find();

  static const String instruction = '''
  \n1. Copy link from the copy button below.
  \n2. Go to the Download Media page by clicking the 'Share Media' button at the bottom.
  \n3. Select the media you wanna download and click on the download button, you will be navigated to browser.
  \n4. Download the media from the browser.
  \n5. Upload a Story or a Post with the downloaded media.
  \n6. Paste the link provided below in the story/ first comment of the post.
  \n7. Mention the brand's Instagram page in the story/ post (Copy it from above).
  \nNote: Both story and post should not be deleted wihtin 24hours for proper validation. 
''';

  static const String requirements = '''
  \n• Gender - Any\n• Age group 18-40\n• Followers range- From 2k to 100k followers\n• Category - Food\n• Location- Hyderabad.
''';

  void copyText(String text) async {
    await SocialShare.copyToClipboard(text);
    Get.snackbar(
      'Copied',
      '$text is copied to your Clipboard',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: kPrimaryColor),
      actions: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
          ),
          onPressed: () {
            Get.to(() => Valid(
                  campaign: campaign,
                ));
          },
          icon: const Icon(
            Icons.check_rounded,
            color: Colors.green,
          ),
          label: Text(
            'Validate Link',
            style: Get.textTheme.subtitle1.copyWith(color: kBlackColor),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Get.to(() => MediaFIle(campaign: campaign));
        },
        child: Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05)
              .copyWith(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                kPrimaryColor,
                kSecondaryColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            'Share Media',
            style: Get.textTheme.headline6.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                campaign.brand,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.maxFinite,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondaryBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: CircleAvatar(
                      child: Image.network(campaign.logo),
                      radius: size.width * 0.9 * 9 / (16 * 2),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(
                  campaign.location ?? 'Location Unavailable',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notes_rounded),
                title: Text(
                  campaign.text ?? 'No Description',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.instagram),
                title: Text(
                  campaign.username ?? 'Not available',
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: IconButton(
                  onPressed: () => copyText(campaign.username),
                  icon: const Icon(Icons.copy_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Instructions',
                style: Get.textTheme.headline6.copyWith(
                  color: kSecondaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: kSecondaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: const Text(instruction),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: kSecondaryBackgroundColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                //TODO: paste the url
                onPressed: () => copyText('<put_url_here>'),
                icon: const Icon(Icons.copy_rounded, color: kSecondaryColor),
                label: Text(
                  'Copy Link',
                  style: Get.textTheme.button.copyWith(color: kSecondaryColor),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Creator Requirements',
                style: Get.textTheme.subtitle1.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    requirements,
                    style: Get.textTheme.subtitle2
                        .copyWith(color: kTextColor.shade300),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
