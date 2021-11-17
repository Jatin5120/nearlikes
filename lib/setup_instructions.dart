// ignore: implementation_imports

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:nearlikes/instructionConnect.dart';
import 'package:nearlikes/link_account.dart';
import 'Services/services.dart';
import 'constants/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SetupInstructions extends StatefulWidget {
  const SetupInstructions({Key key}) : super(key: key);

  // final phnum,name,age,location;
  //SetupInstructions({this.phnum,this.name,this.age,this.location});

  @override
  _SetupInstructionsState createState() => _SetupInstructionsState();
}

class _SetupInstructionsState extends State<SetupInstructions> {
  var videoId = YoutubePlayer.convertUrlToId(
      "https://www.youtube.com/watch?v=9rdnmbAp9k4");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: kPrimaryColor,
                    size: 30,
                  )),
            ),
            const SizedBox(
              height: 70,
            ),
            Image.asset('assets/logo.png', width: 65.54, height: 83),
            const SizedBox(
              height: 35,
            ),
            Center(
              child: Text(
                "How to setup your instagram",
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: kFontColor,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Follow the steps below to setup your instagram account.",
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: kDarkGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId, //Add videoID.
                flags: const YoutubePlayerFlags(
                  hideControls: false,
                  controlsVisibleAtStart: true,
                  autoPlay: false,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Step wise guide -> ",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kDarkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstructionCheck()));
                    },
                    child: Text(
                      "HELP",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: InkWell(
                onTap: () async {
                  print('080808');
                  //print(widget.location);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LinkAccount()));
                },
                child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xffC13584),
                            kSecondaryColor,
                            kPrimaryColor,
                          ],
                        )),
                    child: Center(
                      child: Text('Next',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.white,
                            //letterSpacing: 1
                          )),
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NearLikes’s  ",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kDarkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => UrlLauncher.openLink(url: kPrivacy2),
                    child: Text(
                      "Privacy",
                      style: GoogleFonts.montserrat(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: kBlueColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "and  ",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kDarkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => UrlLauncher.openLink(url: kTerms2),
                    child: Text(
                      "Terms",
                      style: GoogleFonts.montserrat(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: kBlueColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    ));
  }
}
