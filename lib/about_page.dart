import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/constants.dart';

class About extends StatefulWidget {
  const About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                height: 25,
              ),
              Image.asset('assets/logo.png', width: 46.31, height: 60.28),
              const SizedBox(
                height: 35,
              ),
              Center(
                child: Text(
                  "ABOUT US",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  '''Nearlikes aspires to be the one-stop destination for all micro influencers who love to collaborate with their favourite brands. Being the first of its kind, Nearlikes app creates a fun, user-friendly and trust-worthy ecosystem where Instagram influencers share brand stories and receive massive deals and offers. ''',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: kFontColor,
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
