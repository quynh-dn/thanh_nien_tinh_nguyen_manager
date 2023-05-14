import 'package:flutter/material.dart';
import 'package:haivn/common/style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'common_app/common_app.dart';

class CommonChart {
//Biểu đồ đường
  Widget sfCartesianChart(
      {required double heightBox,
      double? widthBox,
      String? lableBox,
      required List<ChartSeries> chartSeries,
      required double heightChart,
      Widget? titleBoxRight}) {
    return Container(
      // width: MediaQuery.of(context).size.width * 1,
      height: heightBox,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [containerShadow]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [titleBoxWidget(titleBox: lableBox), Expanded(child: titleBoxRight ?? Container())],
          ),
          CommonApp().dividerWidget(height: 1),
          CommonApp().sizeBoxWidget(height: 30),
          SizedBox(
            height: heightChart,
            child: SfCartesianChart(
              // title: ChartTitle(text: titleChart),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: chartSeries,
              primaryXAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              // primaryYAxis: NumericAxis(labelFormat: '{value}M', numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
            ),
          ),
        ],
      ),
    );
  }

  //BIểu đồ cột trơn
  Widget columnChart({
    required double heightBox,
    double? widthBox,
    String? lableBox,
    String? titleQuestion,
    String? numberAnswers,
    required List<ChartSeries> seriesChart,
  }) {
    return Container(
      // width: 300,
      height: heightBox,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [containerShadow]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              titleBoxWidget(titleBox: lableBox ?? ''),
            ],
          ),
          CommonApp().dividerWidget(height: 1),
          Text(titleQuestion ?? ""),
          Text(
            numberAnswers ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          CommonApp().sizeBoxWidget(height: 30),
          SizedBox(
              height: 400,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(), series: seriesChart,
                // <ChartSeries>[
                //   StackedColumnSeries<ChartData1, String>(
                //       dataLabelSettings: const DataLabelSettings(isVisible: true),
                //       dataSource: chartData1,
                //       xValueMapper: (ChartData1 data, _) => data.x,
                //       yValueMapper: (ChartData1 data, _) => data.y1),
                // ]
              )),
        ],
      ),
    );
  }

  //Biểu đồ cột xếp tầng
  Widget cascadingColumnChart(
      {required double heightBox,
      double? widthBox,
      String? lableBox,
      String? titleQuestion,
      String? numberAnswers,
      required List<ChartSeries> seriesChart}) {
    return Container(
      // width: MediaQuery.of(context).size.width * 1,
      height: heightBox,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [containerShadow]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              titleBoxWidget(titleBox: lableBox),
            ],
          ),
          CommonApp().dividerWidget(height: 1),
          Text(titleQuestion ?? ""),
          Text(
            numberAnswers ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          CommonApp().sizeBoxWidget(height: 30),
          SizedBox(height: 400, child: SfCartesianChart(primaryXAxis: CategoryAxis(), series: seriesChart)),
        ],
      ),
    );
  }

  //Tiêu đề box
  Widget titleBoxWidget({String? titleBox}) {
    return Text(
      '$titleBox',
      style: titleContainerBox,
    );
  }
}
