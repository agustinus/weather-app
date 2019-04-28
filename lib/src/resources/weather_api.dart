import 'dart:async';
import '../models/weather_model.dart';
import 'http.dart';

class WeatherApi {
  // This API key is being hardcoded now.
  // We can store this at the server and pass this along when we have and do authentication
  static const String apiKey = 'fda4b8881f404fb9bfc141319192604';

  Future<WeatherModel> fetchWeatherForecast({String q, int days: 4}) async {
    assert(q != null);
    // The requirement is to show forecast for the next 4 days, so today is excluded
    // Because the API will include today in the forecast, thus we should get 5 days forecast
    int nextDays = days + 1;
    try {
      final response = await Http.request(
          "https://api.apixu.com/v1/forecast.json?key=$apiKey&q=$q&days=$nextDays",
          method: HttpMethod.GET);
      // This is used by flutter driver test + mock_web_server
      // For now it's manually by commenting and un commenting these lines of code
      // final response = await Http.request(
      //     "http://127.0.0.1:8092/forecast.json?key=$apiKey&q=$q&days=$nextDays",
      //     method: HttpMethod.GET);
      return WeatherModel.fromJson(response);
    } catch (e) {
      print(('Error: ' + e.toString()));
      return null;
    }
  }
}
