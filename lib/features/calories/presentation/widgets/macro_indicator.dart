import 'package:cal_scanner/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MacroIndicator extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final Color color;

  const MacroIndicator({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(height: 4),
      LinearPercentIndicator(
        width: 80,
        lineHeight: 8,
        percent: (value / goal).clamp(0.0, 1.0),
        backgroundColor: AppColors.kPrimaryGrey,
        progressColor: color,
        padding: EdgeInsets.zero,
        barRadius: const Radius.circular(4),
      ),
      SizedBox(height: 5.h),
      Text(
        '${value.toInt()}/${goal.toInt()}g',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
