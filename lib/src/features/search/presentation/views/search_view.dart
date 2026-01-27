import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';
import 'package:mygym/src/features/home/domain/entities/fitness_class_entity.dart';

/// Premium Luxury Search View
///
/// Features:
/// - Real-time search for gyms and classes
/// - Premium styling with gold accents
/// - Recent searches history
/// - Category filters
/// - Full Light/Dark mode compliance
class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<GymEntity> _filteredGyms = [];
  List<FitnessClassEntity> _filteredClasses = [];
  String _selectedCategory = 'all'; // 'all', 'gyms', 'classes'
  bool _isSearching = false;
  
  // Recent searches (in real app, this would be persisted)
  final List<String> _recentSearches = [
    "Gold's Gym",
    "Yoga classes",
    "Swimming pool",
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      
      if (query.isEmpty) {
        _filteredGyms = [];
        _filteredClasses = [];
        return;
      }
      
      final lowerQuery = query.toLowerCase();
      
      // Filter gyms
      if (_selectedCategory == 'all' || _selectedCategory == 'gyms') {
        _filteredGyms = HomeDummyDataSource.gyms.where((gym) {
          return gym.name.toLowerCase().contains(lowerQuery) ||
              gym.location.toLowerCase().contains(lowerQuery);
        }).toList();
      } else {
        _filteredGyms = [];
      }
      
      // Filter classes
      if (_selectedCategory == 'all' || _selectedCategory == 'classes') {
        _filteredClasses = HomeDummyDataSource.classes.where((cls) {
          return cls.name.toLowerCase().contains(lowerQuery) ||
              cls.instructor.toLowerCase().contains(lowerQuery);
        }).toList();
      } else {
        _filteredClasses = [];
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _onSearchChanged(_searchController.text);
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    _onSearchChanged(search);
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _onGymTap(GymEntity gym) {
    // Add to recent searches
    if (!_recentSearches.contains(gym.name)) {
      _recentSearches.insert(0, gym.name);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    }
    context.push('${RoutePaths.gyms}/${gym.id}');
  }

  void _onClassTap(FitnessClassEntity cls) {
    // Add to recent searches
    if (!_recentSearches.contains(cls.name)) {
      _recentSearches.insert(0, cls.name);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    }
    // Navigate to class detail (placeholder for now)
    context.push('${RoutePaths.classes}/${cls.id}');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              luxury.surfaceElevated,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search header
              _buildSearchHeader(colorScheme, luxury, isDark),
              
              // Category filters
              _buildCategoryFilters(colorScheme, luxury),
              
              // Results or suggestions
              Expanded(
                child: _isSearching
                    ? _buildSearchResults(colorScheme, luxury)
                    : _buildSuggestions(colorScheme, luxury),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: luxury.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: luxury.gold.withValues(alpha: 0.15),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18.sp,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          
          // Search field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [luxury.surfaceElevated, luxury.surfacePremium]
                      : [colorScheme.surface, colorScheme.surfaceContainerHighest],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? luxury.gold.withValues(alpha: 0.3)
                      : luxury.gold.withValues(alpha: 0.12),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: luxury.cardShadow.withValues(alpha: isDark ? 0.3 : 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          colorScheme.onSurface.withValues(alpha: 0.6),
                          luxury.gold.withValues(alpha: 0.6),
                        ],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.search_rounded,
                      size: 22.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: _onSearchChanged,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search gyms, classes...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 15.sp,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: _clearSearch,
                      child: Icon(
                        Icons.close_rounded,
                        size: 20.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    final categories = [
      ('all', 'All'),
      ('gyms', 'Gyms'),
      ('classes', 'Classes'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat.$1;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => _onCategorySelected(cat.$1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            luxury.gold.withValues(alpha: 0.2),
                            luxury.gold.withValues(alpha: 0.1),
                          ],
                        )
                      : null,
                  color: isSelected ? null : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? luxury.gold.withValues(alpha: 0.4)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  cat.$2,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? luxury.gold : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchResults(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    final hasGyms = _filteredGyms.isNotEmpty;
    final hasClasses = _filteredClasses.isNotEmpty;
    
    if (!hasGyms && !hasClasses) {
      return _buildNoResults(colorScheme, luxury);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gyms section
          if (hasGyms) ...[
            _buildSectionTitle('Gyms', '${_filteredGyms.length} found', luxury),
            SizedBox(height: 12.h),
            ...List.generate(_filteredGyms.length, (index) {
              return _buildGymResultCard(_filteredGyms[index], colorScheme, luxury);
            }),
            SizedBox(height: 20.h),
          ],
          
          // Classes section
          if (hasClasses) ...[
            _buildSectionTitle('Classes', '${_filteredClasses.length} found', luxury),
            SizedBox(height: 12.h),
            ...List.generate(_filteredClasses.length, (index) {
              return _buildClassResultCard(_filteredClasses[index], colorScheme, luxury);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String count, LuxuryThemeExtension luxury) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: luxury.gold,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: luxury.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGymResultCard(
    GymEntity gym,
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return GestureDetector(
      onTap: () => _onGymTap(gym),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: luxury.surfaceElevated,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            // Gym emoji/icon
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.2),
                    luxury.gold.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  gym.emoji,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            
            // Gym info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gym.name,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14.sp,
                        color: luxury.textTertiary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${gym.location} • ${gym.distance}',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: luxury.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Rating
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 16.sp,
                  color: luxury.gold,
                ),
                SizedBox(width: 4.w),
                Text(
                  gym.rating.toStringAsFixed(1),
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassResultCard(
    FitnessClassEntity cls,
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return GestureDetector(
      onTap: () => _onClassTap(cls),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: luxury.surfaceElevated,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            // Class emoji/icon
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondary.withValues(alpha: 0.2),
                    luxury.gold.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  cls.emoji,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            
            // Class info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cls.name,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'with ${cls.instructor}',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: luxury.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cls.time,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  cls.duration,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: luxury.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64.sp,
            color: luxury.textTertiary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No results found',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try a different search term',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: luxury.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT SEARCHES',
                    style: GoogleFonts.montserrat(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: luxury.gold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _recentSearches.clear();
                      });
                    },
                    child: Text(
                      'Clear',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: luxury.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            ...List.generate(_recentSearches.length, (index) {
              return _buildRecentSearchItem(_recentSearches[index], colorScheme, luxury);
            }),
            SizedBox(height: 24.h),
          ],
          
          // Popular searches
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'POPULAR SEARCHES',
              style: GoogleFonts.montserrat(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: luxury.gold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                _buildPopularSearchChip('Yoga', Icons.self_improvement_rounded, colorScheme, luxury),
                _buildPopularSearchChip('HIIT', Icons.directions_run_rounded, colorScheme, luxury),
                _buildPopularSearchChip('Spinning', Icons.pedal_bike_rounded, colorScheme, luxury),
                _buildPopularSearchChip('Gold\'s Gym', Icons.fitness_center_rounded, colorScheme, luxury),
                _buildPopularSearchChip('Fitness First', Icons.fitness_center_rounded, colorScheme, luxury),
                _buildPopularSearchChip('Smart Gym', Icons.fitness_center_rounded, colorScheme, luxury),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(
    String search,
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return GestureDetector(
      onTap: () => _onRecentSearchTap(search),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: luxury.surfaceElevated.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: 18.sp,
              color: luxury.textTertiary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                search,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.north_west_rounded,
              size: 16.sp,
              color: luxury.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSearchChip(
    String label,
    IconData icon,
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return GestureDetector(
      onTap: () => _onRecentSearchTap(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: luxury.surfaceElevated,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: luxury.gold.withValues(alpha: 0.8),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}