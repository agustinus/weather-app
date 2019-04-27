import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  WeatherEvent([List props = const []]) : super(props);
}

class WeatherEventGetWeather extends WeatherEvent {
  final String query;

  WeatherEventGetWeather({@required this.query})
      : assert(query != null),
        super([query]);
}
