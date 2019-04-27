import 'package:intl/intl.dart';

class WeatherModel {
  String _currentTemp;
  String _country;
  List<ForecastDay> _forecastDay = [];

  WeatherModel.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson.isNotEmpty) {
      _country = parsedJson['location']['country'];
      // Asumption: Current temperature being shown is rounded and no decimal (int)
      _currentTemp = parsedJson['current']['temp_c'].round().toString();

      List<dynamic> forecastDays = parsedJson['forecast']['forecastday'];
      // Note: exclude today, based on the requirement it's stated forecast for the next 4 days
      for (var i = 1; i < forecastDays.length; i++) {
        _forecastDay.add(ForecastDay(forecastDays[i]));
      }
    }
  }

  String get currentTemp => _currentTemp;
  String get country => _country;
  List<ForecastDay> get forecastDay => _forecastDay;
}

class ForecastDay {
  String _avgTemp;
  String _weekday;

  ForecastDay(forecastData) {
    _weekday = DateFormat('EEEE').format(
        DateTime.fromMillisecondsSinceEpoch(forecastData['date_epoch'] * 1000));
    // Asumption: Average temperature being shown is rounded and no decimal (int)
    _avgTemp = forecastData['day']['avgtemp_c'].round().toString();
  }

  String get avgTemp => _avgTemp;
  String get weekday => _weekday;
}
