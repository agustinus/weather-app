import 'package:flutter/material.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F7),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 56.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '20°',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: 96.0,
                  color: Color(0xFF2A2A2A),
                  height: 1.2,
                ),
              ),
              Text(
                'Singapore',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  fontSize: 36.0,
                  color: Color(0xFF556799),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCurrentTemperature() {
    
  }
}
