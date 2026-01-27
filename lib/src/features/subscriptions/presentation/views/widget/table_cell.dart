import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableCells extends StatelessWidget {
  final String text;
  final bool isHeader;
  const TableCells({super.key, required this.text, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader? FontWeight.bold : FontWeight.normal,
          fontSize: 12
        ),
      ),
      );
  }
}
