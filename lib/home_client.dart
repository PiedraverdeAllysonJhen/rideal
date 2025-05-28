import 'package:flutter/material.dart';
import 'package:rideal/search_results_screen.dart';
import 'widgets/search_bar.dart';
import 'widgets/promo_slider.dart';
import 'widgets/vehicle_categories.dart';
import 'widgets/featured_vehicles.dart';
import 'widgets/vehicle_listing.dart';
import 'models/vehicle.dart';
import 'booking_screen.dart';

class HomeClientScreen extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Color themeMain;
  final Color themeLite;
  final Function(Vehicle)? onRentNow;

  const HomeClientScreen({
    super.key,
    required this.vehicles,
    this.onRentNow,
    this.themeMain = const Color(0xFF1976D2),
    this.themeLite = const Color(0xFFBBDEFB),
  });

  void _handleSearchSubmitted(String query, BuildContext context) {
    if (query.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          query: query,
          vehicles: vehicles,
          themeMain: themeMain,
          onRentNow: onRentNow,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent a Vehicle'),
        backgroundColor: themeMain,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBDEFB),
              Colors.white,
            ],
            stops: [0.0, 0.8],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            SearchBarWidget(
              onSubmitted: (query) => _handleSearchSubmitted(query, context),
            ),
            const PromoSliderWidget(),
            VehicleCategoriesWidget(themeMain: themeMain),
            const SizedBox(height: 12),
            FeaturedVehiclesWidget(
              vehicles: vehicles,
              themeMain: themeMain,
              onRentNow: onRentNow,
            ),
            VehicleListingWidget(
              vehicles: vehicles,
              themeMain: themeMain,
              onRentNow: onRentNow,
            ),
          ],
        ),
      ),
    );
  }
}