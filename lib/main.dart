import 'package:flutter/material.dart';
import 'package:health/health.dart';

// Minimal stub for HealthFactory so the symbol is defined and the code compiles.
// This stub returns no data and false for authorization; replace with real implementation
// or remove the stub if your environment provides HealthFactory from the package.
class HealthFactory {
  Future<bool> requestAuthorization(List<HealthDataType> types) async {
    // No-op stub: assume authorization not granted.
    return false;
  }

  Future<List<HealthDataPoint>> getHealthDataFromTypes(
    DateTime startDate,
    DateTime endDate,
    List<HealthDataType> types,
  ) async {
    // No-op stub: return empty list.
    return <HealthDataPoint>[];
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HealthScreen(),
    );
  }
}

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> _healthDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    bool requested = await health.requestAuthorization([HealthDataType.HEART_RATE]);
    if (requested) {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 24));
      try {
        List<HealthDataPoint> data = await health.getHealthDataFromTypes(startDate, endDate, [HealthDataType.HEART_RATE]);
        setState(() {
          _healthDataList = data;
        });
      } catch (e) {
        print("Błąd pobierania danych HealthKit: $e");
      }
    } else {
      print("Brak zgody na HealthKit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Health Data')),
      body: ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (context, index) {
          HealthDataPoint point = _healthDataList[index];
          return ListTile(
            title: Text("${point.value} bpm"),
            subtitle: Text("${point.dateFrom} - ${point.dateTo}"),
          );
        },
      ),
    );
  }
}
