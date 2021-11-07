import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  final _formkey = GlobalKey<FormState>();

  int amount = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Container(
                  height: size.height * 0.26,
                  width: double.infinity,
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'Wallet',
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Rs. $amount',
                                style: GoogleFonts.montserrat(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text('Available Balance',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 30, left: 30),
                              child: TextFormField(
                                //key: _formkey,
                                validator: (amt) {
                                  if(amount==0){
                                    return 'Not enough balance';
                                  }
                                  else if (amt == null || amt.isEmpty) {
                                    return 'Please enter amount';
                                  } else if (int.parse(amt) > amount) {
                                    return 'Available balance is $amount';
                                  } else if (int.parse(amt) < 100)
                                    return 'Minimum withdrawal amount is 100';
                                  else {
                                    return '';
                                  }
                                },

                                // maxLines: 1,

                                keyboardType: TextInputType.number,
                                style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),

                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  prefixStyle: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700),
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 20.0, 5.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                  labelText: "Amount",
                                  labelStyle: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: InkWell(
                                onTap: () {
                                  if (_formkey.currentState.validate())
                                    _formkey.currentState.save();
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSetup()));
                                },
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Colors.pinkAccent,
                                            Colors.orangeAccent,
                                          ],
                                        )),
                                    child: Center(
                                      child: Text('Withdraw',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.white,
                                            //letterSpacing: 1
                                          )),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Note: \nMinimum withdawal amount is 100.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  }

