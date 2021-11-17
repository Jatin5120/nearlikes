import 'package:flutter/material.dart';
import 'package:nearlikes/constants/constants.dart';
import 'package:nearlikes/page_guide.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:nearlikes/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_version/new_version.dart';

class SplashScreen extends StatefulWidget {
  final String playerId;

  const SplashScreen({Key key, this.playerId}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String phonenumber;
  bool checkuser = false;

  @override
  void initState() {
    super.initState();
    //getPlayerId();
    _mockCheckForSession().then((status) {
      _checkVersion();
    });
  }

  // @override
  // void dispose() {
  //   _navigateToLogin();
  //   super.dispose();
  // }
  // getPlayerId()async {
  //   print('inside the getPlayerId');
  //   final status = await OneSignal.shared.getDeviceState();
  //   final String osUserID = status.userId;
  //   print('the player id is $osUserID');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('playerId',osUserID).then((value) => print('job done $value'));
  // }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(const Duration(milliseconds: 6000), () {});

    return true;
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      //androidId: "com.snapchat.android",
      androidId: "com.evolveinno.nearlikes",
    );
    //newVersion.showAlertIfNecessary(context: context);
    final status = await newVersion.getVersionStatus();
    print("Device : " + status.localVersion);
    print("Store : " + status.storeVersion);
    if (status.localVersion == status.storeVersion) {
      print("Your app is already up to date");
    } else {
      print("Update your app");
    }
    if (status != null && status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: "Update Available!",
        allowDismissal: false,
        updateButtonText: "Update App",
        dialogText: "Please update the app from version : " +
            status.localVersion +
            " to version : " +
            status.storeVersion +
            " if you want to keep using the app",
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            PageGuide(phoneNumber: phonenumber)));
  }

  void _navigateToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkuser = prefs.getBool('checkuser');
    phonenumber = prefs.getString('phonenumber');
    if (checkuser == true) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => PageGuide(
                phoneNumber: phonenumber,
              )));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => OnBoarding()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          Image.asset('assets/logo.png', width: 366.65, height: 366.65),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Shimmer.fromColors(
                period: const Duration(milliseconds: 2000),
                baseColor: kBlackColor,
                highlightColor: Colors.white.withOpacity(0.8),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "NEARLIKES",
                    style: GoogleFonts.montserrat(
                        letterSpacing: 10,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
//                Text(
//                  "LINK",
//                  style: TextStyle(
//                      letterSpacing: 3,
//                      fontSize: 50.0,
//                      fontWeight: FontWeight.bold,
//                  ),
//                ),
            ],
          ),
        ],
      ),
    );
  }
}
