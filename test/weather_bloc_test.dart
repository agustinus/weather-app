import 'package:test/test.dart';
import 'package:weather_app/src/blocs/weather_bloc.dart';
import 'package:weather_app/src/blocs/weather_state.dart';

void main() {
  WeatherBloc bloc;

  setUp(() {
    bloc = WeatherBloc();
  });

  test('initial state is WeatherEmpty', () {
    expect(bloc.initialState, WeatherEmpty());
  });

  test('dispose does not emit new states', () {
    expectLater(
      bloc.state,
      emitsInOrder([]),
    );
    bloc.dispose();
  });
}
