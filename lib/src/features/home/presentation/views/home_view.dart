import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/features/home/domain/entities/fitness_class_entity.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';
import 'package:mygym/src/features/home/presentation/widget/build_bannar.dart';
import 'package:mygym/src/features/home/presentation/widget/build_header.dart';
import 'package:mygym/src/features/home/presentation/widget/build_nearby_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_popular_classes.dart';
import 'package:mygym/src/features/home/presentation/widget/build_search_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String _userName = "Ahmed";
    int _currentNavIndex = 0;

    
    
    
    

    
    

    

    void onNavTap(int index) {
      setState(() {
        _currentNavIndex = index;
        // هنا لو حابب تعمل تبويب حقيقي باستخدام go_router
    // switch(index) { ... }
      });
    }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold( 
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A14),
              Color(0xFF0F0F1A),
            ]
          )
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildHeader(userName: _userName),
                SizedBox(height: 20.h,),
                BuildSearchBar(),
                SizedBox(height: 24.h,),
                BuildBannar(),
                SizedBox(height: 24.h,),
                BuildNearbyGyms(),
                SizedBox(height: 24.h,),
                BuildPopularClasses(),
                SizedBox(height: 24.h,),
                
                
              ],
            ),
          )
          ),
      ),
    );
  }
}

