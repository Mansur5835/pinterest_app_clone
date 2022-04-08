import 'dart:convert';

import 'package:http/http.dart' as http;

class PhotoApi {
  static Future<String?> MULTIPART(String api, String filePath) async {
    var uri = Uri.parse("https://api.unsplash,com");
    var request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      "Authorization": 'Client-ID RXFnVFDtZ63maGJGpm-0wmAGRhg-xFUEv58LRaFT9fc',
      "Accept-Version": "v1"
    });

    request.files.add(await http.MultipartFile.fromPath("sdf", filePath));
    var res = await request.send();

    return res.reasonPhrase;
  }

  static Future<List<dynamic>?> GET(String api) async {
    final response =
        await http.get(Uri.parse("https://api.unsplash.com$api"), headers: {
      "Authorization": 'Client-ID RXFnVFDtZ63maGJGpm-0wmAGRhg-xFUEv58LRaFT9fc',
      "Accept-Version": "v1"
    });

    if (response.statusCode != 200) {
      return null;
    }
    List<dynamic> listMap = jsonDecode(response.body);
    return listMap;
  }

  static Future<List<dynamic>?> GETS(String api) async {
    final response =
        await http.get(Uri.parse("https://api.unsplash.com$api"), headers: {
      "Authorization": 'Client-ID RXFnVFDtZ63maGJGpm-0wmAGRhg-xFUEv58LRaFT9fc',
      "Accept-Version": "v1"
    });

    if (response.statusCode != 200) {
      return null;
    }
    List<dynamic> listMap = jsonDecode(response.body)["results"];
    return listMap;
  }
}
