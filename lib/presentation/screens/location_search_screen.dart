import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../providers/location_provider.dart';
import '../../domain/entities/location_entity.dart';

/// Màn hình tìm kiếm và chọn vị trí
class LocationSearchScreen extends ConsumerStatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  ConsumerState<LocationSearchScreen> createState() =>
      _LocationSearchScreenState();
}

class _LocationSearchScreenState extends ConsumerState<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus search field
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
    if (query.trim().isNotEmpty) {
      ref.read(locationProvider.notifier).searchLocations(query);
    } else {
      ref.read(locationProvider.notifier).clearSearchResults();
    }
  }

  void _onLocationSelected(LocationEntity location) {
    ref.read(locationProvider.notifier).selectLocation(location);
    Navigator.of(context).pop();
  }

  void _onUseCurrentLocation() {
    ref.read(locationProvider.notifier).getCurrentLocation();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final currentLocation = locationState.currentLocation;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Chọn vị trí'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thành phố...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: AppTheme.radius2xl,
                  borderSide: BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppTheme.radius2xl,
                  borderSide: BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppTheme.radius2xl,
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
            ),
          ),

          // Use Current Location Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _LocationTile(
              icon: Icons.gps_fixed,
              title: currentLocation != null
                  ? currentLocation.name
                  : 'Sử dụng vị trí GPS',
              subtitle: currentLocation != null
                  ? currentLocation.shortDisplayName
                  : 'Lấy vị trí hiện tại từ GPS',
              onTap: _onUseCurrentLocation,
              isSelected: currentLocation != null,
            ),
          ),

          SizedBox(height: 16.h),

          // Search Results
          Expanded(
            child: locationState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : locationState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48.w,
                              color: AppTheme.textSecondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              locationState.error!,
                              style: TextStyle(color: AppTheme.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : locationState.searchResults.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 48.w,
                                  color: AppTheme.textTertiary,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Nhập tên thành phố để tìm kiếm',
                                  style: TextStyle(
                                    color: AppTheme.textTertiary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: locationState.searchResults.length,
                            itemBuilder: (context, index) {
                              final location =
                                  locationState.searchResults[index];
                              final isSelected =
                                  currentLocation?.id == location.id;
                              return _LocationTile(
                                icon: Icons.location_on,
                                title: location.name,
                                subtitle: location.displayName,
                                onTap: () => _onLocationSelected(location),
                                isSelected: isSelected,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

/// Widget cho location tile
class _LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isSelected;

  const _LocationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.radius2xl,
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radius2xl,
          border: isSelected
              ? Border.all(color: AppTheme.primaryColor, width: 2)
              : Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.border,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 24.w,
              ),
          ],
        ),
      ),
    );
  }
}

