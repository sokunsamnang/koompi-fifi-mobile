import 'package:flutter/material.dart';
import 'package:koompi_hotspot/screens/speedtest/constants/palette.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar {
  LinearPercentIndicator showBar(double displayPer) {
    return LinearPercentIndicator(
      width: 300,
      lineHeight: 24.0,
      percent: displayPer / 100.0,
      center: Text(
        "${displayPer.toStringAsFixed(1)}%",
        style: TextStyle(
          fontSize: 14.0,
          color: txtCol,
        ),
      ),
      barRadius: const Radius.circular(16),
      backgroundColor: progressBg,
      progressColor: progressFill,
    );
  }
}
