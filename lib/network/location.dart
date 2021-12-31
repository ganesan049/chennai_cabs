import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:testing_referral/elements/search_result_card.dart';

class Location {
  static final String location = 'location';
  static final String locationID = 'location_id';
  static final String lat = 'lat';
  static final String lng = 'lng';
  static final String apiKey = 'AIzaSyBi8FShdFjs9SWEHlhXFa0_4CSiQenH57I';
  static final String locationSearchBaseURL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?';
  static final String geocodeBaseURL =
      'https://maps.googleapis.com/maps/api/geocode/json?';
  static final String distanceBaseURL =
      'https://maps.googleapis.com/maps/api/directions/json?';

  static Future<Map<String, dynamic>> myLocation(bool needLatLng) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (needLatLng) {
      return {
        lat: position.latitude,
        lng: position.longitude,
      };
    } else {
      final Map<String, String> locationDetails =
          await byLatLng(position.latitude, position.longitude);
      return locationDetails;
    }
  }

  static Future<List<Widget>> searchPlaces(
      String sessionToken, String input, BuildContext context, VoidCallback onLoading) async {
    final http.Response requestResult = await http.get(
      Uri.parse(locationSearchBaseURL +
          'input=$input&key=$apiKey&sessiontoken=$sessionToken' +
          '&components=country:in'),
    );
    final Map data = jsonDecode(requestResult.body);
    final List locations = data['predictions'];
    List<Widget> locationTile = [];
    locations.forEach(
      (location) {
        locationTile.add(
          SearchResultCard(
            locationAddress: location['structured_formatting']
                ['secondary_text'],
            locationName: location['structured_formatting']['main_text'],
            onTap: () async {
              onLoading();
              final Map<String, dynamic> details =
                  await byPlaceID(location['place_id']);
              Navigator.pop(context, details);
            },
          ),
        );
      },
    );
    return locationTile;
  }

  static Future<Map<String, dynamic>> byPlaceID(String placeID) async {
    final http.Response resultRequest = await http.get(
      Uri.parse(geocodeBaseURL + 'place_id=$placeID&key=$apiKey'),
    );
    final Map data = json.decode(resultRequest.body);
    final List locationDetails = data['results'];
    return {
      location: locationDetails[0]['formatted_address'],
      lat: locationDetails[0]['geometry']['location']['lat'],
      lng: locationDetails[0]['geometry']['location']['lng'],
    };
  }

  static Future<Map<String, String>> byLatLng(double lat, double lng) async {
    final http.Response resultRequest = await http.get(
      Uri.parse(geocodeBaseURL + 'latlng=$lat,$lng&key=$apiKey'),
    );
    final Map data = json.decode(resultRequest.body);
    final List details = data['results'];
    return {
      location: details[0]['formatted_address'],
      locationID: details[0]['place_id'],
    };
  }

  static Future<String> getDistance(
      String fromPlaceId, String toPlaceId) async {
    final http.Response resultRequest = await http.get(
      Uri.parse(distanceBaseURL +
          'origin=place_id:$fromPlaceId&destination=place_id:$toPlaceId&key=$apiKey'),
    );
    final Map data = json.decode(resultRequest.body);
    final String distance = data['routes'][0]['legs'][0]['distance']['text'];
    return distance;
  }
}
