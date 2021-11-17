import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:nearlikes/home_page.dart';
import 'package:nearlikes/instructionPost.dart';
import 'package:nearlikes/link_upi.dart';
import 'package:nearlikes/models/get_customer.dart';
import 'package:nearlikes/page_guide.dart';
import 'package:nearlikes/register.dart';
import 'package:nearlikes/widgets/loading_dialog.dart';
import 'package:scratcher/widgets.dart';
import 'package:nearlikes/models/checkaddedstry.dart';
import 'package:nearlikes/scratch_cards.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter/material.dart';
import 'package:nearlikes/models/get_media.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_share/instagram_share.dart';

import 'constants/constants.dart';
import 'controllers/controllers.dart';
import 'package:rate_my_app/rate_my_app.dart';

GetMedia _getMedia;
GetStry _getStory;
String customerId;
String phonenumber;
String instaPgId;
String cid;
//bool loading1 = false;
bool videoinit = false;
String cashbackvalue;
Customer _getCustomer;
StreamController _campaignController;
bool upi = false;
String cashbackId;

VideoPlayerController _controller;
Future<void> _initializeVideoPlayerFuture;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

String mediaType;

class BrandStories extends StatefulWidget {
  final String id; //owner id
  final String brand;
  final String campaignId;
  final String brandMoto;
  final String brandTag;

  const BrandStories({
    Key key,
    @required this.id,
    @required this.brand,
    @required this.campaignId,
    @required this.brandMoto,
    @required this.brandTag,
  }) : super(key: key);
  @override
  _BrandStoriesState createState() => _BrandStoriesState();
}
//temp long user access token //in future generate from database
//String accesstoken='EAAG9VBauCocBALeqX0Owqm8ZCibZAb2UKe0vTL0VjRvCt7aNbLgab6kGh6AtLinwiWnz33d2A14CUX8ZB2G2BoGLMjQsr3hShBSN0FZBG6H1sQZCPumi2ZBR5R9hX6jVX2ZAl5mraAeZBCTy9a89nEyP9yUpkS4hALD5oYQakkugDTxZBobgH858ZC';

var cashback;
StreamController _postsController;

Future<GetMedia> getAvailableMedia({@required String id}) async {
  print('inside get media');
  var body = {
    "id": id,
  };
  final response = await http.post(
    Uri.parse(kGetMedia),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  final String responseString = response.body;
  _getMedia = getMediaFromJson(responseString);
  print('getAvailableMedia --> $responseString');

  return _getMedia;
}

loadPosts(var id) async {
  getAvailableMedia(id: id).then((res) async {
    _postsController.add(res);
    return res;
  });
}

// checkstry(String instapgid) async {
//   print('inside checkstry the id is $instapgid');
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String accesstoken = prefs.getString('token');
//   print('the access toke is $accesstoken');
//   final String api =
//       "https://graph.facebook.com/v11.0/$instapgid/stories?fields=media_url,timestamp,caption&access_token=$accesstoken";
//
//   var response = await http.get(Uri.parse(api));
//   //print(response.body);
//   final String responseString = response.body;
//   print('the body of fb story response is ${response.body}');
//
//   try {
//     _getStory = getStryFromJson(responseString);
//     print('this is checkstry func');
//     print('[][][][]');
//     print(_getStory.data[0].id);
//     print(_getStory.toString());
//     return _getStory;
//   } catch (e) {
//     print(e.toString());
//     return 'error';
//   }
// }

Future<dynamic> checkstry(String instapgid) async {
  print('inside checkstry the id is $instapgid');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accesstoken = prefs.getString('token');

  final String api =
      "https://graph.facebook.com/v11.0/$instapgid/stories?fields=media_url,timestamp,caption,thumbnail_url,permalink&access_token=$accesstoken";

  http.Response response = await http.get(Uri.parse(api));

  final String responseString = response.body;
  print('the response of fb body is : ${response.body}');
  try {
    _getStory = getStryFromJson(responseString);
    return _getStory;
  } on SocketException {
    print("No Internet Connection");
  } catch (e) {
    print(e.toString());
    return 'error';
  }
}

bool isValidStoryTime(Datum data) {
  final StoryController storyController = Get.find();
  storyController.endTime = DateTime.now();
  DateTime postTime = DateTime.parse(data.timestamp).toLocal();
  print(storyController.startTime);
  print(postTime);
  print(storyController.endTime);
  if (storyController.startTime.compareTo(postTime) <= 0 &&
      storyController.endTime.compareTo(postTime) >= 0) {
    return true;
  } else {
    return false;
  }
}

checkstryId(List stryids, id, campaignId, customerId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userAccId = prefs.getString('user_acc_id');
  // String customerId = prefs.getString('customer_id');
  cid = customerId;

  String accesstoken = prefs.getString('token');

  print('the access toke is $accesstoken');

  print('customer id is === $customerId');
  print('cameign id $campaignId');
  print('the user_acc_id ${userAccId.toString()}');
  print('the id is $id');
  print('the stryId $stryids');
//owner id should exist & campaign_id should exist
  var body = {
    "id": "$campaignId", //campegien id
    "user": accesstoken,
    "story": stryids,
    // "ownerId": "$customerId"//customer id
    "ownerId": "$customerId"
  };
  //  var body=   {
  //   "id": "60fc5e01856fd5b96000aa6f",
  // "story": ["17999262505344919"],
  // "user": "EAAG9VBauCocBALeqX0Owqm8ZCibZAb2UKe0vTL0VjRvCt7aNbLgab6kGh6AtLinwiWnz33d2A14CUX8ZB2G2BoGLMjQsr3hShBSN0FZBG6H1sQZCPumi2ZBR5R9hX6jVX2ZAl5mraAeZBCTy9a89nEyP9yUpkS4hALD5oYQakkugDTxZBobgH858ZC",
  // "ownerId": "610d685f705f995ffd38e109"
  // };
  var response = await http.post(
    Uri.parse(kAddStory),
    body: json.encode(body),
    headers: {"Content-Type": "application/json"},
  );
  print(response.statusCode);
  print('======');
  print(response.body);

  if (response.statusCode == 200) //update business owners about the stry
  {
    var decoded = json.decode(response.body);

    cashback = decoded['cashback'];
    cashbackId = decoded['id'];
    print('the cashback is $cashback');
    print("..in..business $id");
    print('the cashbackId is $cashbackId');
    //coustmer id should exist
    var body = {
      "id": "$customerId", // id of user while signing in
      "data": "$id" //  owner id from campeign list  whose story is shared
    };
    var response2 = await http.post(
      Uri.parse(kAddAssociation),
      body: json.encode(body),
      headers: {"Content-Type": "application/json"},
    );
    print(response2.body);

    return 200;
  } else {
    return response.statusCode;
  }
}

Future<String> addStory(String url) async {
  String result = '';
  print('addStory');
  if (mediaType == 'image') {
    var response = await http.get(Uri.parse(url));
    var documentDirectory = await getApplicationDocumentsDirectory();
    File file = File(join(documentDirectory.path, 'nearlikes.mp4'));
    file.writeAsBytesSync(response.bodyBytes);
    return await SocialShare.shareInstagramStory(file.path,
        backgroundBottomColor: "#D6F9F9", backgroundTopColor: "#D6F9F9");
  } else {
    var response = await http.get(Uri.parse(url));
    var documentDirectory = await getApplicationDocumentsDirectory();
    File file = File(join(documentDirectory.path, 'nearlikes.mp4'));
    file.writeAsBytesSync(response.bodyBytes);
    await InstagramShare.share(file.path, "video").whenComplete(() {
      result = 'success';
    });
    return result;
  }
}

class _BrandStoriesState extends State<BrandStories>
    with WidgetsBindingObserver {
  final StoryController storyController = Get.find();

  int count = 0;
  var response;
  final String hashTag = '#nearlikes';
  final String caption = "Win upto 50% off Coupon, follow & click link in bio ";

  int choice = -1;
  List<String> storyId = [];

  ConfettiController _controllerTopCenter;
  List mySelTeams;
  String animationName = "celebrationstart";

  void _playAnimation() {
    setState(() {
      if (animationName == "celebrationstart") {
        animationName = "celebrationstop";
      } else {
        animationName = "celebrationstart";
      }
    });
  }

  getCustomerId(String phonenumber) async {
    var body = {"phone": "+91$phonenumber"};

    final response = await http.post(
      Uri.parse(kGetId),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    setState(() {
      customerId = jsonDecode(response.body);
    });
    print('the response is $customerId');
    getCustomerupiID(customerid: customerId);
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getString('customer_id');
    phonenumber = prefs.getString('phonenumber');
    setState(() {
      customerId = prefs.getString('customer_id');
      phonenumber = prefs.getString('phonenumber');
    });
    print('the phone number is $phonenumber');
    print('user acc id is $customerId');
    if (customerId == null) {
      print('test');
      getCustomerId(phonenumber);
    } else {
      getCustomerupiID(customerid: customerId);
    }
    //else getCustomer(customerId);
  }

  getInstaId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phonenumber1 = prefs.getString('phonenumber');
    print('the phonenumber for instaId is $phonenumber1');
    var body = {"phone": "+91$phonenumber1"};
    var response = await http.post(
      Uri.parse(kPid),
      body: json.encode(body),
      headers: {"Content-Type": "application/json"},
    );
    print('the instapgid is ${response.body}');
    print(response.statusCode);
    setState(() {
      instaPgId = response.body;
    });
    print("the iddddd is __${instaPgId}__");
  }

  Future<bool> _mockCheckForSession(mediaType) async {
    if (mediaType == 'image') {
      await Future.delayed(const Duration(milliseconds: 8000), () {
        // setState(() {
        //   loading1 = false;
        // });
      });
    } else {
      await Future.delayed(const Duration(milliseconds: 15000), () {
        // setState(() {
        //   loading1 = false;
        // });
      });
    }
    return true;
  }

  checkMaxStry() async {
    print('inside max check stry');
    print(customerId);
    var body = {"id": customerId};
    var response = await http.post(Uri.parse(kCheckStory),
        body: json.encode(body), headers: {"Content-Type": "application/json"});
    print('jesus');
    print(response.body);
    print(response.statusCode);
    return response.statusCode;
  }

  // loadStory() async {
  //
  //   checkstry(instaPgId).then((res) async {
  //     _campaignController.add(res);
  //     return res;
  //   });
  // }

  @override
  void initState() {
    // _campaignController = new StreamController();
    //loadStory();
    // checkstry("17841447410700405");
    print('asasasas');
    print(widget.brand);
    print(widget.id);
    print(widget.campaignId);
    print('................${widget.id}');
    WidgetsBinding.instance.addObserver(this);
    _postsController = StreamController();
    loadPosts(widget.id);
    getUserData();
    getInstaId();

    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter.play();
    getAvailableMedia(id: widget.id);

    _playAnimation();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print("\nResumed\n");
        storyController.isAppOpen = true;
        break;
      case AppLifecycleState.inactive:
        print("\nInactive\n");
        storyController.isAppOpen = false;
        break;
      case AppLifecycleState.detached:
        storyController.isAppOpen = false;
        print("\nDetached\n");
        break;
      case AppLifecycleState.paused:
        storyController.isAppOpen = false;
        print("\nPaused\n");
        break;
    }
  }

  Future<Customer> getCustomerupiID({customerid}) async {
    print(".....");
    print('inside the getcustomerId upi $customerid');
    var body = {"id": "$customerid"};
    final response = await http.post(
      Uri.parse(kGetCustomer),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    print("..... !@#");
    print(response.statusCode);
    final String responseString = response.body.toString();

    print(responseString);
    _getCustomer = customerFromJson(responseString);
    if (_getCustomer.customer.upi != null) {
      print('upi is true');
      setState(() {
        upi = true;
      });
    }
    return _getCustomer;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void showAlertdialog({String title, String content}) {
    Get.dialog(AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          child: const Text('Ok'),
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(primary: kSecondaryColor),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      // ---------------------- Post Story Button ---------------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        decoration: const BoxDecoration(
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
              color: kShadowColor,
              offset: Offset(8, 4),
              blurRadius: 20.0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Obx(
          () => Container(
            height: 40,
            width: 185,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: storyController.isStorySelected ? null : Colors.grey,
              gradient: storyController.isStorySelected
                  ? const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [kSecondaryColor, kPrimaryColor],
                    )
                  : null,
              // color: selected == "" ? Colors.grey : null,
              // gradient: selected != ""
              //     ? const LinearGradient(
              //         begin: Alignment.topRight,
              //         end: Alignment.bottomLeft,
              //         colors: [kSecondaryColor, kPrimaryColor],
              //       )
              //     : null,
            ),
            child: InkWell(
              onTap: () async {
                if (mediaType != 'image') {
                  await _controller.pause();
                  print('video function');
                }
                if (storyController.isStorySelected) {
                  int statusCode = await checkMaxStry();

                  print('the maxstry is $statusCode');

                  if (statusCode == 200) {
                    return showDialog(
                      context: _scaffoldKey.currentContext,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(widget.brand),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.brandMoto,
                              ),
                              SizedBox(height: size.height.twoPercent),
                              Text(
                                'Note: The statement will be copied to your clipboard. Be sure to paste the statement.',
                                style: Get.textTheme.subtitle2,
                              )
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: const Text('Ok'),
                              onPressed: () async {
                                final String statement =
                                    caption + widget.brandTag;

                                await SocialShare.copyToClipboard(statement);

                                storyController.startTime = DateTime.now();
                                storyController.isAppOpen = false;

                                String response =
                                    await addStory(storyController.storyUrl);

                                print('the response is $response');

                                Navigator.pop(context);

                                Get.dialog(
                                  const LoadingDialog.withText(
                                    'Waiting for you to come back',
                                  ),
                                  barrierDismissible: false,
                                );

                                while (!storyController.isAppOpen) {
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                    () async {},
                                  );
                                  print("Not in App");
                                }

                                Get.back();

                                print("Here");

                                Get.dialog(
                                  const LoadingDialog.withText(
                                    'Please wait while we are validating',
                                  ),
                                  barrierDismissible: false,
                                );

                                if (response == 'success') {
                                  _mockCheckForSession(mediaType).then(
                                    (value) async {
                                      var response = await checkstry(instaPgId);
                                      if (response == 'error') {
                                        showAlertdialog(
                                          title: 'Error Occured',
                                          content: 'Post story and try again',
                                        );

                                        if (Get.isDialogOpen) {
                                          Get.back();
                                        }
                                        Navigator.pop(context);
                                      } else {
                                        RegExp exp = RegExp(
                                          statement,
                                          caseSensitive: false,
                                        );
                                        for (Datum data in _getStory.data) {
                                          try {
                                            if (isValidStoryTime(data)) {
                                              print("Time matched");
                                              bool match =
                                                  exp.hasMatch(data.caption);
                                              print('in...');
                                              if (match == true) {
                                                storyId.add(data.id);
                                              } else {
                                                //Navigator.pop(context);
                                              }
                                            } else {
                                              print("Time not matched");
                                            }
                                          } catch (e) {
                                            // setState((){error='';});

                                            //Navigator.pop(context);
                                          }
                                        }
                                        Get.back();
                                      }

                                      if (storyId.isEmpty) {
                                        showAlertdialog(
                                          title: 'No Story detected',
                                          content:
                                              'No story has been posted by you with ${widget.brandTag} or the story might have not been uploaded yet. Delete the story and try again.',
                                        );
                                      } else {
                                        var value = await checkstryId(
                                            storyId
                                                .toSet()
                                                .toList(growable: true),
                                            widget.id,
                                            widget.campaignId,
                                            customerId);
                                        if (value == 200) {
                                          print('in dialog');

                                          //setState(() {loading1 = false;});

                                          await goToDialog("Rs. " "$cashback");
                                        } else {
                                          showAlertdialog(
                                            title: 'Improper story',
                                            content: "Please Add Proper Story",
                                          );
                                          // Navigator.pop(context);
                                        }
                                      }
                                    },
                                  );
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showAlertdialog(
                      title: 'Story limit',
                      content:
                          "Max Story limit per day is 1 and it looks like you've posted the story for the day. Please try next day",
                    );
                  }
                }
              },
              child: Center(
                child: Text(
                  'Post a story',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // ---------------------- Post Story Button END ---------------------------
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 40, right: 40, top: 0),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 40, right: 40, top: 0),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InstructionPost(),
                                ),
                              );
                            },
                            child: Text(
                              "Help",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                //fontWeight: FontWeight.w800,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset('assets/logo.png', width: 46.31, height: 60),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "${widget.brand} BRAND".toUpperCase(),
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kTextColor[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(bottom: 100),
                    height: 700,
                    child: DefaultTabController(
                      initialIndex: 0,
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            unselectedLabelColor: Colors.grey,
                            labelColor: kPrimaryColor,
                            tabs: const [
                              Tab(text: 'Medias'),
                              Tab(text: 'Videos'),
                            ],
                            labelStyle: GoogleFonts.poppins(
                                fontSize: 13, fontWeight: FontWeight.w500),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: kSecondaryColor,
                            isScrollable: false,
                            onTap: (index) {
                              storyController.isStorySelected = false;
                            },
                          ),
                          Expanded(
                            //height: 600,

                            // -------------------------- Photos List -------------------------
                            child: TabBarView(
                              children: [
                                FutureBuilder(
                                  future: getAvailableMedia(id: widget.id),
                                  // stream: _postsController.stream,
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                              color: kPrimaryColor));
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemCount: _getMedia.media.length,
                                      itemBuilder: (_, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              storyController.storyUrl =
                                                  _getMedia.media[index].src;
                                              storyController.isStorySelected =
                                                  true;
                                              storyController.selectedIndex =
                                                  index;

                                              setState(() {
                                                print(
                                                    "Image OnTap --> ${_getMedia.media[index].src}");

                                                mediaType =
                                                    _getMedia.media[index].type;
                                                choice = index;
                                              });
                                            },
                                            child: _getMedia
                                                        .media[index].type ==
                                                    'image'
                                                ? Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(35, 0, 35, 0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    alignment: Alignment.center,
                                                    child: Obx(
                                                      () => Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color: storyController
                                                                        .isStorySelected &&
                                                                    storyController
                                                                            .selectedIndex ==
                                                                        index
                                                                ? kBlackColor
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: _getMedia
                                                              .media[index].src,
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink());
                                      },
                                      padding: EdgeInsets.only(bottom: 140),
                                    );
                                  },
                                ),

                                // -------------------------- Videos List -------------------------

                                FutureBuilder(
                                  future: getAvailableMedia(id: widget.id),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemCount: _getMedia.media.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            storyController.storyUrl =
                                                _getMedia.media[index].src;
                                            // storyController.error = '';
                                            setState(() {
                                              print(
                                                  "Video onTap --> ${_getMedia.media[index].src}");

                                              mediaType =
                                                  _getMedia.media[index].type;
                                              choice = index;
                                            });
                                          },
                                          child: _getMedia.media[index].type ==
                                                  'video'
                                              ? Obx(
                                                  () => Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 35),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                      border: Border.all(
                                                        color: storyController
                                                                    .isStorySelected &&
                                                                storyController
                                                                        .selectedIndex ==
                                                                    index
                                                            ? kBlackColor
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: VideoWidget(
                                                      index: index,
                                                      play: true,
                                                      url: _getMedia
                                                          .media[index].src,
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
          ),

          // Center(
          //   child: Container(
          //     // height: MediaQuery.of(context).size.height,
          //     margin: EdgeInsets.only(
          //         top: MediaQuery.of(context).size.height - 100),
          //     child: Obx(
          //       () => Text(
          //         storyController.error,
          //         style: const TextStyle(
          //             fontSize: 17,
          //             color: Colors.red,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          // ),
          // loading==true?FutureBuilder(
          //      future: checkstry(),
          //      builder: (context, AsyncSnapshot snapshot){
          //        if(!snapshot.hasData){
          //          return Padding(
          //            padding: const EdgeInsets.only(top: 300),
          //            child:  Center(child: Text('post story')),
          //          );
          //        }
          //       else
          //        for(var i=0;i<_getStry.data.length;i++){
          //          print(_getStry.data.length.toString());
          //
          //          if(_getStry.data[i].caption=='#nearlikes'){
          //            String id=_getStry.data[i].id;
          //            //count=count+1;
          //            print(id);
          //            return Padding(
          //              padding: const EdgeInsets.only(top: 300),
          //              child: Center(child: Text('story posted successfully')),
          //            );
          //          }
          //        }
          //        setState(() {
          //          loading==false;
          //        });
          //        return Text('Error');
          //
          //      }):Container(height: 0,)

          //loading1 == true
          //     ? Container(
          //         alignment: Alignment.bottomCenter,
          //         child: const CircularProgressIndicator(
          //           color: Colors.red,
          //         ),
          //         padding: const EdgeInsets.only(bottom: 30),
          //       )
          //     : Container(height: 0)
        ],
      ),
    );
  }

  goToDialog(amount) {
    showDialog(
        //barrierColor: Colors.black.withOpacity(0.2),
        context: this.context,
        //barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successTicket(amount, ""),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  successTicket(amount, brand) => Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Material(
              clipBehavior: Clip.antiAlias,
              elevation: 2.0,
              borderRadius: BorderRadius.circular(4.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _controllerTopCenter.play();
                          },
                          child: Text(
                            "Congratulations!",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "You have won a scratch card.",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: ConfettiWidget(
                                confettiController: _controllerTopCenter,
                                blastDirection: 0,
                                emissionFrequency: 0.1,
                                numberOfParticles: 90,
                                maxBlastForce: 15,
                                minBlastForce: 9,
                                //  maxBlastForce: 10,
                                //shouldLoop: true,
                                minimumSize: const Size(2,
                                    5), // set the minimum potential size for the confetti (width, height)
                                maximumSize: const Size(10, 10),
                                //colors: [kPrimaryOrange,kPrimaryPink,kLightGrey]
                              ),
                            ),
                            Card(
                              elevation: 6.0,
                              //margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: new ScratchCardW(
                                    brand: brand,
                                    value: amount,
                                    docId: "ddd",
                                    uId: "dddd"),
                              ),
                            ),
                          ],
                        ),
                        // ScratchCardView(
                        //                                           value: paidAmount.round(), docId: docId, uId: userId
                        //                                             ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class ScratchCardW extends StatefulWidget {
  final String brand;
  final String value;
  final String docId, uId;
  ScratchCardW({this.value, this.docId, this.uId, this.brand});

  @override
  _ScratchCardWState createState() => _ScratchCardWState();
}

class _ScratchCardWState extends State<ScratchCardW> {
  double _opacity = 0.0;
  double brush = 50;
  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    return true;
  }

  // ScratchCardValue(couponId)async{
  //   print('the cashback id is @$couponId');
  //   print('brandstories couponid $cashbackId');
  //   var body = {
  //     "id": "$couponId",
  //
  //   };
  //   final response = await http.post(
  //     Uri.parse("https://nearlikes.com/v1/api/client/card/scratch"),
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode(body),
  //   );
  //   print('value value ${response.body}');
  // }

  ScratchCardValue(couponId) async {
    print('the cashback id is @$couponId');
    print('phone number is 2 $phonenumber');
    // var body = {
    //   "id": "$couponId",
    // };

    var body = {"id": "$couponId", "phone": "+91$phonenumber"};

    final response = await http.post(
      Uri.parse(kCashbackScratched),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    print('value value ${response.body}');
    print("the status code ${response.statusCode}");
  }

  // Future<String> cashbackScratched(String couponId) async {
  //   if(couponId!=null){
  //     print('the customer id is $customerId');
  //     print("..8989..");
  //     print('the coupon id is $couponId');
  //     final String apiUrl = "https://nearlikes.com/v1/api/client/cashback/scratch";
  //     var body = {
  //       "id": "$couponId",
  //       "ownerId": "$customerId"
  //     };
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(body),
  //     );
  //
  //     print(".....");
  //     print(response.statusCode);
  //     print('----');
  //     final String responseString = response.body.toString();
  //     print(']||/*/');
  //     print(responseString);
  //     print('232323');
  //     return responseString;
  //     // _getCustomer = customerFromJson(responseString);
  //     // print(";;;");
  //     // print(_getCustomer.customer.name);
  //     // return _getCustomer;
  //   }
  // }

  RateMyApp rateMyApp = RateMyApp(
    googlePlayIdentifier: 'com.evolveinno.nearlikes',
    minDays: 0,
    minLaunches: 0,
    remindLaunches: 0,
    remindDays: 0,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => reset());
  }

  List<DebuggableCondition> conditions = [];
  bool shouldOpenDialog;
  T getCondition<T>() => rateMyApp.conditions.whereType<T>().toList().first;
  @override
  Widget build(BuildContext context) {
    final minimumDays = getCondition<MinimumDaysCondition>();
    final minimumLaunches = getCondition<MinimumAppLaunchesCondition>();
    final doNotOpenAgain = getCondition<DoNotOpenAgainCondition>();
    minimumDays.minimumDate = DateTime.now();
    return RateMyAppBuilder(
      builder: (context) => Scratcher(
        accuracy: ScratchAccuracy.low,
        threshold: 5,
        brushSize: brush,
        onChange: (value) {
          print('sadasd$value');
        },
        onThreshold: () {
          print("Threshold reached, you won!");
          setState(() {
            _opacity = 1;
            brush = 500;
          });

          _mockCheckForSession().then((value) async {
            if (upi == false) {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add UPI'),
                      content: Text(
                          'Please add your upi for getting the cash reward '),
                      actions: [
                        FlatButton(
                            onPressed: () async {
                              // await ScratchCardValue(cashbackId);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LinkUPI(
                                            cashbackId: cashbackId,
                                          )));
                            },
                            child: Text('OK'))
                      ],
                    );
                  });
            } else if (upi == true) {
              await ScratchCardValue(cashbackId);
              // await ScratchCardValue(cashbackId);
              // await cashbackScratched(cashbackId);

              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Bravo!',
                        style: TextStyle(color: Colors.red),
                      ),
                      content: Text(
                          'Your cashback will be credited after 24 hours! '),
                      actions: [
                        FlatButton(
                            onPressed: () async {
                              // await ScratchCardValue(cashbackId);
                              // Navigator.pop(context);
                              // Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PageGuide();
                              }));
                            },
                            child: Text('OK'))
                      ],
                    );
                  });
              // Navigator.push(context, MaterialPageRoute(builder: (context) { return PageGuide();}));

            }
          });
        },
        color: Colors.greenAccent.shade700,
        image: Image.asset("assets/scratchcard.png"),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 250),
          opacity: _opacity,
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/trophy.png",
                    width: 100,
                    height: 95,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You've won",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.value.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  // Text(
                  //   "${widget.brand}"==""?"":widget.brand,
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 22,
                  //       color:kDarkGrey),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
      rateMyApp: rateMyApp,
      onInitialized: (context, rateMyApp) {
        setState(() {
          this.rateMyApp = rateMyApp;
          shouldOpenDialog = rateMyApp.shouldOpenDialog;
          doNotOpenAgain.doNotOpenAgain = false;
        });

        // print("Conditions 1 ----------------------------------------------------------------");
        // print('Minimum Days: ${minimumDays.minDays}');
        // print('Remind After Days: ${minimumDays.remindDays}');
        // print('Current Launches: ${minimumLaunches.launches}');
        // print('Minimum Launches: ${minimumLaunches.minLaunches}');
        // print('Remind After Launches: ${minimumLaunches.remindLaunches}');
        // //print('Open Rating Again? $openRatingAgain');
        // print('Are Conditions Met? $hasMetConditions');

        print(
            "Conditions  ----------------------------------------------------------------");

        rateMyApp.conditions.forEach((condition) {
          if (condition is DebuggableCondition) {
            print(condition.valuesAsString);
          }
        });

        print('Are all conditions met ? ' +
            (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));

        if (shouldOpenDialog && doNotOpenAgain.doNotOpenAgain == false) {
          print("Show Star Rate Dialog");
          rateMyApp.showStarRateDialog(
            context,
            title: 'Rate this app',
            message:
                'You like this app ? Then take a little bit of your time to leave a rating :',
            actionsBuilder: (context, stars) {
              // Triggered when the user updates the star rating.
              return [
                TextButton(
                  child: Text('RATE US'),
                  onPressed: () async {
                    print('Thanks for the ' +
                        (stars == null ? '0' : stars.round().toString()) +
                        ' star(s) !');
                    await rateMyApp
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    await rateMyApp.launchStore();
                    rateMyApp.save().then((v) => setState(() {
                          doNotOpenAgain.doNotOpenAgain = true;
                          shouldOpenDialog = false;
                        }));
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  },
                ),
                TextButton(
                  child: Text('MAYBE LATER'),
                  onPressed: () async {
                    await rateMyApp
                        .callEvent(RateMyAppEventType.laterButtonPressed);
                    rateMyApp.save().then((v) => setState(() {
                          doNotOpenAgain.doNotOpenAgain = false;
                          shouldOpenDialog = true;
                        }));
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.later);
                  },
                ),
                TextButton(
                  child: Text('NO, THANKS!'),
                  onPressed: () async {
                    await rateMyApp
                        .callEvent(RateMyAppEventType.noButtonPressed);
                    rateMyApp.save().then((v) => setState(() {
                          doNotOpenAgain.doNotOpenAgain = true;
                          shouldOpenDialog = false;
                        }));
                    print("doNotOpenAgain - " +
                        doNotOpenAgain.doNotOpenAgain.toString());
                    print("shouldOpenDialog - " + shouldOpenDialog.toString());
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.no);
                  },
                ),
              ];
            },
            dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: StarRatingOptions(
              initialRating: 4.0,
            ),
          );
        }
      },
    );
  }

  Future reset() async {
    print("Reset Dialog Called");
    await rateMyApp.reset();
    setState(() {
      conditions =
          rateMyApp.conditions.whereType<DebuggableCondition>().toList();
      shouldOpenDialog = rateMyApp.shouldOpenDialog;
    });
  }
}

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
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  } // This closing tag was missing

  @override
  void dispose() {
    _controller.dispose();
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
              _controller.play();
              print(_controller.value.isPlaying);
              print('end of test');
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                // videoinit==false? Image.network("${_getMedia.media[index].pre}",fit: BoxFit.fitWidth): AspectRatio(
                //   aspectRatio: _controller.value.aspectRatio,
                //   child: VideoPlayer(_controller),
                // ),
                ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
