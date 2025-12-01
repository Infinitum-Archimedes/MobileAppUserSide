import 'package:flutter/material.dart';

class DiseaseDetailPage extends StatelessWidget {
  final String location;
  final String diseaseName;
  final int totalCases;
  final int casesToday;
  final int casesThisWeek;

  const DiseaseDetailPage({
    Key? key,
    required this.location,
    required this.diseaseName,
    required this.totalCases,
    required this.casesToday,
    required this.casesThisWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$diseaseName: $totalCases Cases',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Cases Per Week',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Placeholder for bar chart
            Container(
              height: 200,
              color: Colors.blue[100],
              child: Center(child: Text('Bar Chart Placeholder')),
            ),
            SizedBox(height: 20),
            Text(
              'Selected: $diseaseName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Cases today: $casesToday diagnoses'),
            Text('Cases this week: $casesThisWeek diagnoses'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action for more information
              },
              child: Text('Information about $diseaseName'),
            ),
          ],
        ),
      ),
    );
  }
}
