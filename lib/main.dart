import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import 'src/models/weather_model.dart';
import 'src/blocs/weather_bloc.dart';
import 'src/blocs/weather_state.dart';
import 'src/blocs/weather_event.dart';

import 'src/widgets/pending_actions.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MainScreen(title: 'Weather Forcast'),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  static const Color colorBlack = Color(0xFF2A2A2A);
  static const Color colorBlack2 = Color(0xFF556799);
  static const Color colorBgRedError = Color(0xFFE85959);
  static const Color colorBgWhite = Color(0xFFF5F6F7);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorBtn = Color(0xFF4A4A4A);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  WeatherBloc _weatherBloc;

  final Location _locationProvider = new Location();
  Map<String, double> _userLocation;

  @override
  void initState() {
    super.initState();

    _weatherBloc = WeatherBloc();

    // Get user location
    _getLocation().then((value) {
      setState(() {
        _userLocation = value;
        _getWeatherForecast();
      });
    });

    _weatherBloc.state.listen((data) {
      if (data is WeatherReceived) {
        _buildBottomSheet(data.weather);
      }
    });
  }

  @override
  void dispose() {
    _weatherBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorBgWhite,
      body: SafeArea(
        child: BlocBuilder(
          bloc: _weatherBloc,
          builder: (_, WeatherState state) {
            if (state is WeatherEmpty) {
              return Container();
            }
            if (state is WeatherReceiving) {
              return PendingAction();
            }
            if (state is WeatherReceived) {
              final weather = state.weather;
              return _buildCurrentTemperature(
                  weather.currentTemp, weather.country);
            }
            if (state is WeatherError) {
              return _buildErrorWidget();
            }
          },
        ),
      ),
    );
  }

  // Dispatch a bloc event to get weather forecast data
  _getWeatherForecast() {
    _weatherBloc.dispatch(WeatherEventGetWeather(
        query:
            '${_userLocation['latitude'].toString()},${_userLocation['longitude'].toString()}'));
  }

  _buildErrorWidget() {
    return Container(
      color: colorBgRedError,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 44.0),
            child: Text(
              'Something went wrong at our end!',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 54.0,
                color: colorWhite,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              _getWeatherForecast();
            },
            child: Text(
              'RETRY',
              style: TextStyle(
                color: colorWhite,
              ),
            ),
            color: colorBtn,
          )
        ],
      ),
    );
  }

  _buildBottomSheet(WeatherModel weather) {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return Container(child: _buildFourDaysForecast(weather));
    });
  }

  _buildCurrentTemperature(String temperature, String location) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 56.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$temperature°C',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w900,
                fontSize: 96.0,
                color: colorBlack,
                height: 1.2,
              ),
            ),
            Text(
              location,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100,
                fontSize: 36.0,
                color: colorBlack2,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.0,
    );
  }

  Widget _buildForecastListTile(String title,
      {String trailingText, dynamic onTapFunc}) {
    TextStyle textStyle = TextStyle(
      fontFamily: 'Roboto',
      color: colorBlack,
      fontSize: 16.0,
      height: 1.2,
    );
    return Container(
      alignment: Alignment(0.0, 0.0),
      height: 80.0,
      child: ListTile(
        onTap: onTapFunc,
        title: Text(
          title,
          style: textStyle,
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trailingText,
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFourDaysForecast(WeatherModel weather) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x22AAAAAA),
            offset: new Offset(0.0, 0.0),
            blurRadius: 3.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildForecastList(weather.forecastDay),
      ),
    );
  }

  List<Widget> _buildForecastList(List<ForecastDay> forecastDays) {
    List<Widget> listTiles = [];
    for (var forecastDay in forecastDays) {
      listTiles.add(
        _buildForecastListTile(forecastDay.weekday,
            trailingText: '${forecastDay.avgTemp}°C'),
      );
      listTiles.add(
        _buildDivider(),
      );
    }
    return listTiles;
  }

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await _locationProvider.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
