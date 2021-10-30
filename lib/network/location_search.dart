import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationSearch {
  final String apiKey = 'AIzaSyC3DcU8dCnT5SxZIv1JHHJlG1GP4pG15Vg';
  final String baseURL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
      'components=country:in';

  void getResult(String sessionToken, String input) async {
    final http.Response requestResult = await http.get(
      Uri.parse(
          baseURL + 'input=$input&key=$apiKey&sessiontoken=$sessionToken'),
    );
    final Map data = JsonCodec().decode(requestResult.body);
    print(data);
  }
}
