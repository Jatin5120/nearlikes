import 'package:flutter/material.dart';
import 'package:nearlikes/home_page.dart';
import 'package:nearlikes/profile_page.dart';
import 'package:nearlikes/select_brand.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearlikes/wallet.dart';

import 'constants/constants.dart';

int number;

class PageGuide extends StatefulWidget {
  final phoneNumber;
  PageGuide({this.phoneNumber});
  @override
  _PageGuideState createState() => _PageGuideState();
}

class _PageGuideState extends State<PageGuide> {
  // var number;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomePage(),
      //SelectBrand(),
      Wallet(),
      ProfilePage(phoneNumber: widget.phoneNumber),
    ];
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _currentIndex = 0;
        });
        return false;
      },
      child: Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 20,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          selectedItemColor: kPrimaryColor,
          selectedIconTheme: IconThemeData(size: 22),
          selectedFontSize: 14,
          unselectedFontSize: 13,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Home',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              // icon: Icon(Icons.account_balance_wallet_outlined,color: Colors.orange,size: 25,),
              icon: Icon(
                Icons.account_balance_wallet_outlined,
              ),
              title: Text(
                'Post a Story',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              backgroundColor: kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(
                'Profile',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              backgroundColor: kPrimaryColor,
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
