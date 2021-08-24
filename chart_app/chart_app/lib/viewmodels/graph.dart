import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chart_app/repositories/firebase_repository.dart';

  final CollectionReference fireData = Firestore.instance.collection('users');

  Widget buildgraph(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<void>(
      stream: fireData.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<ChartData> chartData = <ChartData>[];
          for (int index = 0; index < snapshot.data.documents.length; index++) {
            DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
            List values = documentSnapshot.get('personalMessages');
       // print('List received: $values');


        // For each map (each message card) in the list, add a MessageCard to the MessageCard list (using the fromJson method)
        for(Map<String, dynamic> map in values ) {
          print('Map received in List: $map');
            // here we are storing the data into a list which is used for chart’s data source
            chartData.add(ChartData.fromMap(map));}
          }
          widget = Container(
              child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries<ChartData, dynamic>>[
              ColumnSeries<ChartData, dynamic>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.xValue,
                  yValueMapper: (ChartData data, _) => data.yValue)
            ],
          ));
        }
        return widget;
      },
    ));
  }


class ChartData {
  ChartData({this.xValue, this.yValue});
  ChartData.fromMap(Map<String, dynamic> dataMap)
      : xValue = dataMap['year'],
        yValue = dataMap['stat'];
  final int xValue;
  final int yValue;
}
