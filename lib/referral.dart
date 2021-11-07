import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:nearlikes/theme.dart';

class Referral extends StatefulWidget {
  final String ref1;
  Referral({@required this.ref1});

  @override
  _ReferralState createState() => _ReferralState();
}

class _ReferralState extends State<Referral> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xfffE5E5E5),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal:40,vertical: 70),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back,color: kPrimaryOrange,size: 30,)),
              ),
              // SizedBox(
              //   height: size.height * 0.10,
              // ),
              Spacer(),
              // Text(
              //   'Refer your friends',
              //   style: TextStyle(fontSize: 30),
              // ),
              Text('Refer your friends',
                  style: GoogleFonts.montserrat(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: kFontColor,
                  )),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: size.height * 0.4,
                  child: Image.asset('assets/pic2.jpeg')),
              Spacer(
                flex: 1,
              ),
              Text(
                'Get 10% cashback',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kFontColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Refer your friends a get a chance to \nearn maximum cashback!',
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: kFontColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onLongPress: () {
                  Clipboard.setData(new ClipboardData(text: widget.ref1));
                  // key.currentState.showSnackBar(new SnackBar(
                  //   content: new Text("Copied to Clipboard"),
                  // ));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied to clipboard')));
                },
                child: DottedBorder(
                  color: Colors.red,
                  strokeWidth: 2,
                  child: Container(
                    width: size.width * 0.65,
                    height: 30,
                    // decoration:
                    //     BoxDecoration(border: Border.all(style: BorderStyle.solid)),
                    child: Text('${widget.ref1}',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kFontColor,
                        )),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryOrange,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    onshare(context);
                  },
                  icon: Icon(Icons.share),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  onshare(BuildContext context) async {
    await Share.share(
        'Hey! getting into this awesome app has never been easy, sign up now using my referral code ${widget.ref1}, and win Cash backs and Coupons using Nearlikes . Hurry up now! \n https://play.google.com/store/apps/details?id=com.evolveinno.nearlikes');
  }
}
