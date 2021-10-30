import 'package:http/http.dart' as http;

class TransactionSMS {

  static final String baseURL = 'http://login.blesssms.com/api/mt/SendSMS?APIKey=&senderid=&channel=&DCS=0&flashsms=0';

  static final String message = 'well';
  static final String apiKey = 'jPT9C6DKXUmc8jDkBAq06w';


  static void send(String phoneNumber) async {
    final Map<String, String> headers = {
      'APIKey' : apiKey,
      /*'senderid' : 'CHCABS',
      'channel' : 'Trans',
      'DCS' : '0',
      'flashsms' : '0',
      'number' : '91$phoneNumber',
      'text' : message,
      'route' : '10'*/
    };
   final http.Response request =  await http.post(
      Uri.parse(
          baseURL),
   headers: headers);
    print(request.body);
  }
}
