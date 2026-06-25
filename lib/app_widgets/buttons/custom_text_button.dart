import 'package:cal_scanner/theme/app_colors.dart';
import 'package:cal_scanner/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? textSize;
  const CustomTextButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.kBlack,
        fontSize: textSize ?? 15.sp,
      ),
    ),
  );
}
