import 'package:bloc/bloc.dart';

import '../resources/weather_api.dart';
import '../models/weather_model.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApi weatherApi = WeatherApi(); 

  @override
  WeatherState get initialState => WeatherEmpty();

  @override
  Stream<WeatherState> mapEventToState(currentState, WeatherEvent event) async* {
    if (event is WeatherEventGetWeather) {
      yield WeatherReceiving();
      try {
        final WeatherModel weather = await weatherApi.fetchWeatherForecast(q: event.query);
        yield WeatherReceived(weather: weather);
      } catch (_) {
        yield WeatherError();
      }
    }
  }
}