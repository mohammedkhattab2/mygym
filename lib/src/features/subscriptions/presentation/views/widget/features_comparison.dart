import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/features/subscriptions/domain/entities/subscription.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/widget/table_cell.dart';


class FeaturesComparison extends StatelessWidget {
  final List<SubscriptionBundle> bundles;
  const FeaturesComparison({super.key, required this.bundles});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Compare All Features"),
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Table(
            border: TableBorder.all(color: Colors.grey[300]!),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[100]),
                children: [
                  const TableCells(
                    text: "Features",
                    isHeader: true ,
                    ),
                    ...bundles.map((b)=> TableCells(text: b.name, isHeader: true,)),
                ]
              ),
              _buildFeatureRow("Visits", bundles.map((b)=> b.visitsText).toList()),
              _buildFeatureRow("Duration", bundles.map((b)=>b.period.displayName ).toList()),
              _buildFeatureRow("Price", bundles.map((b)=> b.formattedPrice).toList())
            ],
          ),
          )
      ],
      );
  }
  
  TableRow _buildFeatureRow(String feature , List<String>values ) {
    return TableRow(
      children: [
        TableCells(text: feature),
        ...values.map((v)=> TableCells(text: v)),
      ]
    );
  }
}