import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthKit Running Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HealthFactory _health = HealthFactory();
  List<HealthDataPoint> _healthDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchRunningData();
  }

  Future<void> _fetchRunningData() async {
    // HealthKit 권한 요청
    bool isAuthorized = await _health.requestAuthorization([HealthDataType.DISTANCE_WALKING_RUNNING]);

    if (isAuthorized) {
      // 러닝 데이터 읽기
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        DateTime.now().subtract(Duration(days: 7)),
        DateTime.now(),
        [HealthDataType.DISTANCE_WALKING_RUNNING],
      );

      setState(() {
        _healthDataList = healthData;
      });

      // 콘솔에 출력
      for (var data in healthData) {
        print('Data point: ${data.value}, Date: ${data.dateFrom}');
      }
    } else {
      print('Authorization not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthKit Running Data'),
      ),
      body: ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (context, index) {
          HealthDataPoint dataPoint = _healthDataList[index];
          return ListTile(
            title: Text('Distance: ${dataPoint.value} meters'),
            subtitle: Text('Date: ${dataPoint.dateFrom}'),
          );
        },
      ),
    );
  }
}
