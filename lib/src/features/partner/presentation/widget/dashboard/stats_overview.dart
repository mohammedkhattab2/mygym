import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/dashboard/stat_card.dart';

class StatsOverview extends StatelessWidget {
  final PartnerReport report;
  const StatsOverview({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.people_rounded, 
            value: report.visitSummary.totalVisits.toString(), 
            label: "Visits",
            growth: report.visitSummary.growthPercentage, 
            color: Colors.blue
            )
          ),
          SizedBox(width: 12.w,),
          Expanded(
            child: StatCard(
              icon: Icons.person_add_rounded, 
              value: report.visitSummary.uniqueVisitors.toString(), 
              label: "Unique Visits", 
              color: Colors.purple
              )
            ),
            SizedBox(width: 12.w,),
            Expanded(
              child: StatCard(
                icon: Icons.repeat_rounded, 
                value: report.visitSummary.averageVisitsPerUser.toStringAsFixed(1), 
                label: "Avg/User", 
                color: Colors.teal
                )
              )
      ],
    );
  }
}