import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreenTemplate extends StatelessWidget {
  const AuthScreenTemplate({
    required this.screenTitle,
    this.header1 = '',
    this.header2 = '',
    required this.gifURL,
    required this.elements,
  });

  final String screenTitle;
  final String header1;
  final String header2;
  final String gifURL;
  final List<Widget> elements;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          centerTitle: true,
          title: Text(
            screenTitle,
            style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height) /
                      2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        gifURL,
                        height: header1.isEmpty? 250: 150,
                        width: header1.isEmpty? 250: 150,
                      ),
                      if (header1.isNotEmpty) Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Text(
                              header1,
                              style: GoogleFonts.ptSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21),
                            ),
                            if (header1.isNotEmpty) SizedBox(
                              height: 5,
                            ),
                            if (header2.isNotEmpty) Text(
                              header2,
                              style: GoogleFonts.ptSans(
                                  fontSize: 13, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: elements,
                    ),
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
