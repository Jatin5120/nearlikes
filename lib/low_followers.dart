import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearlikes/Services/services.dart';
import 'package:nearlikes/page_guide.dart';
import 'constants/constants.dart';

class LowFollowers extends StatefulWidget {
  const LowFollowers({Key key}) : super(key: key);

  @override
  _LowFollowersState createState() => _LowFollowersState();
}

class _LowFollowersState extends State<LowFollowers> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PageGuide()),
            ModalRoute.withName("/Home"));
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: GestureDetector(
                //       onTap: (){
                //         Navigator.pop(context);
                //       },
                //       child: Icon(Icons.arrow_back,color: kPrimaryOrange,size: 30,)),
                // ),

                const SizedBox(
                  height: 92,
                ),
                Image.asset('assets/logo.png', width: 65.54, height: 83),
                const SizedBox(
                  height: 35,
                ),
                Center(
                  child: Text(
                    "Better luck next time",
                    style: GoogleFonts.montserrat(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: kFontColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "You need a minimum of 1000 followers to continue.",
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: kDarkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 280,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => PageGuide()),
                          ModalRoute.withName("/Home"));
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
                                kSecondaryColor,
                                kPrimaryColor,
                              ],
                            )),
                        child: Center(
                          child: Text('Back to Homepage',
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
                        onTap: () => UrlLauncher.openLink(url: kPrivacy),
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
                        onTap: () => UrlLauncher.openLink(url: kTerms),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
