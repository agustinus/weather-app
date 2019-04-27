import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../models/weather_model.dart';

abstract class WeatherState extends Equatable {
  WeatherState([List props = const []]) : super(props);
}

class WeatherEmpty extends WeatherState {}

class WeatherReceiving extends WeatherState {}

class WeatherReceived extends WeatherState {
  final WeatherModel weather;

  WeatherReceived({@required this.weather})
      : assert(weather != null),
        super([weather]);
}

class WeatherError extends WeatherState {}