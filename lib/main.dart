import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _MainScreenState extends State<MainScreen> {
  static const Color colorBlack = Color(0xFF2A2A2A);
  static const Color colorBlack2 = Color(0xFF556799);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  WeatherBloc _weatherBloc;

  @override
  void initState() {
    super.initState();

    _weatherBloc = WeatherBloc();
    _weatherBloc.dispatch(WeatherEventGetWeather(query: '180.129.34.196'));
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
      backgroundColor: Color(0xFFF5F6F7),
      body: SafeArea(
          child: BlocBuilder(
        bloc: _weatherBloc,
        builder: (_, WeatherState state) {
          return PendingAction();
          if (state is WeatherEmpty) {
            print('Empty');
            return Container();
          }
          if (state is WeatherReceiving) {
            print('Receiving');
            return PendingAction();
          }
          if (state is WeatherReceived) {
            final weather = state.weather;
            return _buildCurrentTemperature(
                weather.currentTemp, weather.country);
          }
          if (state is WeatherError) {
            print('Error');
            return Container();
          }
        },
      )),
    );
  }

  _buildBottomSheet(WeatherModel weather) {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(child: _buildFourDaysForecast(weather));
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
}
