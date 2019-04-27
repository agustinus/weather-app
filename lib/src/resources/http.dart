import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';

class Http {
  static Future<Object> request(
    String url, {
    body = const {},
    HttpMethod method = HttpMethod.GET,
  }) async {
    Client _client = Client();

    Map<String, String> httpHeaders = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    var response;
    switch (method) {
      case HttpMethod.POST:
        response = await _client.post(url,
            headers: httpHeaders, body: json.encode(body));
        break;
      case HttpMethod.GET:
        response = await _client.get(url, headers: httpHeaders);
        break;
      default:
        response = await _client.post(url,
            headers: httpHeaders, body: json.encode(body));
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw Exception('Request failed');
    }
  }
}

enum HttpMethod { POST, GET, PUT }
