import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RideHistoryCard extends StatelessWidget {
  final TextStyle kDefault = GoogleFonts.sourceSansPro(color: Colors.black);
  final TextStyle kDefault1 = GoogleFonts.ptSans(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16);

  List<Widget> generate(double length) {
    return List.generate(
      (length / 5).floor(),
          (index) => SizedBox(
        height: 5,
        width: 5,
        child: Divider(
          color: index % 2 == 0 ? Colors.black : Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: (){},
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Chennai, Tamilnadu',
                      style: kDefault1,
                    ),
                    Icon(
                      Icons.arrow_right_alt_outlined,
                      color: Colors.black,
                    ),
                    Text(
                      'Trichy, Tamilnadu',
                      style: kDefault1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: generate(MediaQuery.of(context).size.width - 80),
                ),
              ),
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'CC00089132',
                      style: kDefault,
                    ),
                    Text(
                      '·',
                      style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '02 Oct \'21',
                      style: kDefault,
                    ),
                    Text(
                      '·',
                      style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rs. 1800',
                      style: kDefault,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
