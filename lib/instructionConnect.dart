import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class InstructionCheck extends StatefulWidget {
  @override
  _InstructionCheckState createState() => _InstructionCheckState();
}

class _InstructionCheckState extends State<InstructionCheck> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,

            centerTitle: false,
            title: Text('Help', style: GoogleFonts.roboto()),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Texts(
                    txt1: 'Step 1',
                    txt2: 'Go into your settings.',
                  ),
                  Imagess(
                    images: 'assets/p1.png',
                  ),
                  Texts(
                    txt1: 'Step 2',
                    txt2:
                    'Then click on the Settings button at the bottom of the menu.',
                  ),
                  Imagess(
                    images: 'assets/p2.png',
                  ),
                  Texts(
                    txt1: 'Step 3',
                    txt2: 'From your settings menu, select Account.',
                  ),
                  Imagess(
                    images: 'assets/p3.png',
                  ),
                  Texts(
                      txt1: 'Step 4',
                      txt2: "Select Switch to Professional Account at the bottom."),
                  Imagess(images: 'assets/p4.png'),
                  Texts(txt1: 'Step 5', txt2: "Now click on Done Button."),
                  Imagess(images: 'assets/p5.png'),
                  Texts(txt1: 'Step 6', txt2: "Select Creator Account."),
                  Imagess(images: 'assets/p6.png'),
                  Texts(
                      txt1: 'Step 7',
                      txt2: "Now click on the Edit Profile Selection."),
                  Imagess(images: 'assets/p7.png'),
                  Texts(
                      txt1: 'Step 8',
                      txt2: "Now select the Page under the Profile information."),
                  Imagess(images: 'assets/p8.png'),
                  Texts(
                      txt1: 'Step 9',
                      txt2:
                      "Now click on create Facebook page & save the changes."),
                  Imagess(images: 'assets/p9.png'),
                  Texts(txt1: 'Step 10', txt2: "Click on Back Button."),
                  Imagess(images: 'assets/p10.png'),
                  Texts(txt1: 'Step 11', txt2: "Click on Right Mark."),
                  Imagess(images: 'assets/p11.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Voila, it's done!",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                    thickness: 3,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'How to register in Nearlikes App ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Texts(
                    txt1: 'Step 1',
                    txt2: 'Click on get started ',
                  ),
                  Imagess(
                    images: 'assets/p12.png',
                  ),
                  Texts(
                    txt1: 'Step 2',
                    txt2: 'Enter your phone number',
                  ),
                  Imagess(
                    images: 'assets/p13.png',
                  ),
                  Texts(
                    txt1: 'Step 3',
                    txt2: 'Submit your OTP received in your phone ',
                  ),
                  Imagess(
                    images: 'assets/p14.png',
                  ),
                  Texts(
                    txt1: 'Step 4',
                    txt2: 'Enter your Name and date of birth. ',
                  ),
                  Imagess(
                    images: 'assets/p15.png',
                  ),
                  Texts(
                    txt1: 'Step 5',
                    txt2: 'Click on next button  ',
                  ),
                  Imagess(
                    images: 'assets/p16.png',
                  ),
                  Texts(
                    txt1: 'Step 6',
                    txt2: 'Click on Login with Facebook ',
                  ),
                  Imagess(
                    images: 'assets/p17.png',
                  ),
                  Texts(
                    txt1: 'Step 7',
                    txt2: 'Click on Continue  ',
                  ),
                  Imagess(
                    images: 'assets/p18.png',
                  ),
                  Texts(
                    txt1: 'Step 8',
                    txt2: 'Choose your account and click on confirm ',
                  ),
                  Imagess(
                    images: 'assets/p19.png',
                  ),
                  Texts(
                    txt1: 'Step 9',
                    txt2: 'Select one from each category  ',
                  ),
                  Imagess(
                    images: 'assets/p20.png',
                  ),
                  Texts(
                    txt1: 'Step 10',
                    txt2: 'Click on continue to dashboard  ',
                  ),
                  Imagess(
                    images: 'assets/p21.png',
                  ),
                ],
              ),
            ),
          ),
        ));;
  }
}


class Imagess extends StatelessWidget {
  final String images;
  Imagess({@required this.images});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Material(
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          height: 400,
          width: 280,
          child: Image(
            image: AssetImage(images),
            fit: BoxFit.contain,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}

class Texts extends StatelessWidget {
  final String txt1;
  final String txt2;
  Texts({@required this.txt1, @required this.txt2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$txt1: ',
              style: GoogleFonts.poppins(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
            Text(
              txt2,
              maxLines: 3,
              softWrap: true,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.red.shade500,
                  fontWeight: FontWeight.w500),
              //  style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
