import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationEntry extends StatelessWidget {
  final String entryLabel;
  final String entry;
  final VoidCallback onTap;
  final Color color;
  final bool loadingIndicator;

  const LocationEntry({
    required this.entryLabel,
    required this.onTap,
    required this.entry,
    this.color = Colors.white,
    this.loadingIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entryLabel,
                    style: GoogleFonts.ptSans(fontSize: 16, color: color),
                  ),
                  loadingIndicator
                      ? entry == 'Choose location'
                          ? SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : SizedBox()
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                entry,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ptSans(
                    fontSize: 16, color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
