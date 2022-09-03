import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    required this.locationAddress,
    required this.onTap,
    required this.locationName,
});

  final String locationName;
  final String locationAddress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title: Text(
        locationName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        locationAddress,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
      ),
      leading: Icon(Icons.location_on),
      onTap: onTap,
    );
  }
}
