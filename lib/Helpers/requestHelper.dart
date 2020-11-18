import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    http.Response res = await http.get(url);
    try {
      if (res.statusCode == 200) {
        String jsonData = res.body;
        var decodedData = jsonDecode(jsonData);
        return decodedData;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }
}
