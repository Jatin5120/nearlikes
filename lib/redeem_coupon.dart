import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scratcher/widgets.dart';
import 'package:nearlikes/models/get_customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:nearlikes/models/get_customer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class RedeemCoupon extends StatefulWidget {

  final discount,link,brand,code,expiry;
  RedeemCoupon({@required this.discount,@required this.brand,@required this.code,@required this.link,@required this.expiry});
  @override
  _RedeemCouponState createState() => _RedeemCouponState();
}

class _RedeemCouponState extends State<RedeemCoupon> {

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(8, 4,),
                blurRadius: 20.0,
                spreadRadius: 0,
              ), //BoxShadow//BoxShadow
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10,right: 50,left: 50),
            child: Container(
              height: 40,
              width: 185,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                     kPrimaryPink, kPrimaryOrange,
                    ],
                  )

              ),
              child: InkWell(
                onTap: (){
                  _launchURL(widget.link);
                },
                child: Center(
                  child: Text('Redeem',style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
          ),

        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:40,vertical: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back,color: kPrimaryOrange,size: 30,)),
                ),
                SizedBox(height: 0,),
                Image.asset('assets/logo.png',width:46.31,height:60),
                SizedBox(height: 35,),
                Center(
                  child: Text("Congratulations",style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: kFontColor,
                  ),),
                ),
                SizedBox(height: 8,),
                Center(
                  child: Text("You have won",style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kFontColor,
                  ),),
                ),
                SizedBox(height: 35,),
                Center(
                  child: Text("${widget.discount} off",style: GoogleFonts.montserrat(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: kFontColor,
                  ),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text("on ${widget.brand}",style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: kFontColor,
                  ),),
                ),
                SizedBox(height: 40,),
                Padding(padding: EdgeInsets.all(8),
                child: Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        //SizedBox(height: 45,),
                        Text('COUPON CODE',style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: Color(0xffB9B9B9),
                        )),
                        SizedBox(height: 8,),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(new ClipboardData(text: "${widget.code}")).then((_){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Copied to your clipboard !')));
                            });
                            //Clipboard.setData(ClipboardData(text: "${widget.code}"));
                          },
                          child: Text("${widget.code}",
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600,
                                color: kBlack,
                              )),
                        ),


                      ],
                    ),
                  ),
                ),
                ),

                SizedBox(height: 28,),
                Text("Valid till ${readTimestamp(widget.expiry)}".toUpperCase(),
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: kFontColor,
                    )),

              ],
            ),
          ),
        ),
      );
  }
  _launchURL(url) async {
   // const url ="https://www.nearlikes.com/terms";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('d MMM h:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = format.format(date);
    return diff;
  }
}

