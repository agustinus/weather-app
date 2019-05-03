import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';

void main() {
  group('Weather App', () {
    // First, define the Finders. We can use these to locate Widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys.
    final curTempFinder = find.byValueKey('curTemp');
    final curLocFinder = find.byValueKey('curLoc');
    final errorMsgFinder = find.byValueKey('errorMsg');
    final btnRetryFinder = find.byValueKey('btnRetry');
    final List<SerializableFinder>listForecastFinder = [];
    for (var i = 0; i < 4; i++) {
      listForecastFinder.add(find.byValueKey('listForecast$i'));
    }

    final List<SerializableFinder>listDaysFinder = [];
    for (var i = 0; i < 4; i++) {
      listDaysFinder.add(find.byValueKey('listDays$i'));
    } 

    FlutterDriver driver;
    MockWebServer _server;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      _server = new MockWebServer(port: 8092);
      await _server.start();
      await _server.enqueue(httpCode: 500);
      await _server.enqueue(
          body:
              '{"location":{"country":"Singapore"},"current":{"temp_c":29},"forecast":{"forecastday":[{"date_epoch":1556866235,"day":{"avgtemp_c":28.4}}, {"date_epoch":1556952635,"day":{"avgtemp_c":29.4}}, {"date_epoch":1557039035,"day":{"avgtemp_c":30.4}}, {"date_epoch":1557125435,"day":{"avgtemp_c":31.4}}, {"date_epoch":1557211835,"day":{"avgtemp_c":32.4}}]}}');

      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      _server.shutdown();

      if (driver != null) {
        driver.close();
      }
    });

    test('show error message when error 500', () async {
      expect(await driver.getText(errorMsgFinder),
          "Something went wrong at our end!");
    });

    test('show current temperature and location', () async {
      await driver.tap(btnRetryFinder);
      expect(await driver.getText(curTempFinder), "29°C");
      expect(await driver.getText(curLocFinder), "Singapore");
    });

    test('show forecast temperature', () async {
      expect(await driver.getText(listForecastFinder[0]), "29°C");
      expect(await driver.getText(listForecastFinder[1]), "30°C");
      expect(await driver.getText(listForecastFinder[2]), "31°C");
      expect(await driver.getText(listForecastFinder[3]), "32°C");
    });

    test('show forecast days', () async {
      expect(await driver.getText(listDaysFinder[0]), "Saturday");
      expect(await driver.getText(listDaysFinder[1]), "Sunday");
      expect(await driver.getText(listDaysFinder[2]), "Monday");
      expect(await driver.getText(listDaysFinder[3]), "Tuesday");
    });
  });
}
