import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing_referral/elements/button.dart';

class MapScreen extends StatefulWidget {
  static final String mapScreen = 'MapScreen';
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(13.0680327, 80.1991988),
      zoom: 19.151926040649414);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController controller = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();

  var lat;
  var long;

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  void getPermission() async {
    await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Select pickup location',
          ),
          titleTextStyle:
              GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                compassEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: MapScreen._kLake,
                padding: EdgeInsets.only(top: 300),
                onTap: (position) {
                  print(position.latitude + position.longitude);
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    controller: controller,
                    cursorColor: Colors.black38,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search location',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.green,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Button(
                  buttonText: 'CONFIRM LOCATION',
                  onPress: () {
                    Navigator.pop(context, controller.text);
                    _goToTheLake();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(Icons.pin_drop_outlined, color: Colors.green,size: 30,),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(MapScreen._kGooglePlex));
  }
}
