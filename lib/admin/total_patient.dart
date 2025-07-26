import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static String routeName = 'Dashboard_Doctor';
  static String routePath = '/DashboardDoctor';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int todayCount = 0;
  Map<String, int> last7DaysData = {};

  @override
  void initState() {
    super.initState();
    fetchTodayCount();
    fetchLast7Days();
  }

  Future<void> fetchTodayCount() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day);
    DateTime end = start.add(Duration(days: 1));

    var snapshot = await FirebaseFirestore.instance
        .collection('Record')
        .where('Timestamp', isGreaterThanOrEqualTo: start)
        .where('Timestamp', isLessThan: end)
        .get();

    setState(() {
      todayCount = snapshot.docs.length;
    });
  }

  Future<void> fetchLast7Days() async {
    Map<String, int> data = {};
    DateTime now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));
      String label = "${day.month}/${day.day}";

      DateTime start = DateTime(day.year, day.month, day.day);
      DateTime end = start.add(Duration(days: 1));

      var snapshot = await FirebaseFirestore.instance
          .collection('Record')
          .where('Timestamp', isGreaterThanOrEqualTo: start)
          .where('Timestamp', isLessThan: end)
          .get();

      data[label] = snapshot.docs.length;
    }

    setState(() {
      last7DaysData = data;
    });
  }


  Future<void> deleteAllDocuments(String collectionName) async {
    final db = FirebaseFirestore.instance;

    final snapshot = await db.collection(collectionName).get();
    final batch = db.batch();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('All documents have been save.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard"),backgroundColor: const Color(0xFF4A90E2),),
      backgroundColor: const Color.fromARGB(255, 114, 137, 216),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today Patients", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("$todayCount", style: TextStyle(fontSize: 36)),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text("Last 7 Days Report", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: buildChart()),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed:() async {
                await deleteAllDocuments("Booking");
              },
              icon: Icon(Icons.save),
              label: Text("Save Report"),
            )
          ],
        ),
      ),
    );
  }

  Widget buildChart() {
    if (last7DaysData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final barGroups = last7DaysData.entries.toList().asMap().entries.map((entry) {
      int index = entry.key;
      String label = entry.value.key;
      int value = entry.value.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: value.toDouble(), color: const Color.fromARGB(255, 7, 72, 125)),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int index = value.toInt();
                if (index >= 0 && index < last7DaysData.length) {
                  return Text(last7DaysData.keys.elementAt(index), style: TextStyle(fontSize: 10));
                }
                return Text('');
              },
            ),
          ),
        ),
      ),
    );
  }
}
