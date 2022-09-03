import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chennai_cabs_dev/network/location.dart';
import 'package:chennai_cabs_dev/operations/operations.dart';

class LocationSearchScreen extends StatefulWidget {
  static final String locationSearchScreen = 'LocationSearchScreen';

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  String sessionToken = '';
  List<Widget> searchResult = [];
  bool loading = false;

  @override
  void initState() {
    sessionToken = Operations.getSessionToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 125,
                        color: Colors.green,
                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Search' /*.toUpperCase()*/,
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, right: 15, top: 50),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(15),
                      child: TextField(
                        onChanged: (input) async {
                          // can set a threshold value like 3
                          if (sessionToken.isNotEmpty && input.length > 1) {
                            setState(() => loading = true);
                            final List<Widget> result =
                                await Location.searchPlaces(
                              sessionToken,
                              input,
                              context,
                              () => setState(() => loading = true),
                            );
                            loading = false;
                            setState(() => searchResult = result);
                          }
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search location',
                          hintStyle: GoogleFonts.ptSans(),
                          prefixIcon: Icon(Icons.search_sharp),
                          suffixIcon: loading
                              ? SizedBox(
                                  height: 5,
                                  width: 5,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.green),
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: List.from(searchResult)
                    ..addAll([
                      ListTile(
                        onTap: () async {
                          setState(() => loading = true);
                          final Map locationDetails =
                              await Location.myLocation(true);
                          Navigator.pop(context, locationDetails);
                        },
                        title: Text(
                          'Your location',
                          style:
                              GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.location_searching),
                      ),
                      ListTile(
                        onTap: () => Navigator.pop(context, {}),
                        title: Text(
                          'Select location on map',
                          style:
                              GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.map_outlined),
                      ),
                    ]),
                ).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
