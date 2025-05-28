import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'widgets/vehicle_listing.dart';
import 'booking_screen.dart'; // Make sure to import your BookingScreen

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final List<Vehicle> vehicles;
  final Color themeMain;
  final Function(Vehicle)? onRentNow;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.vehicles,
    required this.themeMain,
    this.onRentNow,
  });

  List<Vehicle> get _filteredVehicles {
    final lowerQuery = query.toLowerCase();
    return vehicles.where((vehicle) {
      return vehicle.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void _handleRentNow(BuildContext context, Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          selectedVehicle: vehicle,
          themeMain: themeMain,
          onBookingComplete: () {
            // Handle any post-booking logic if needed
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search: "$query"'),
        backgroundColor: themeMain,
        foregroundColor: Colors.white,
      ),
      body: _filteredVehicles.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No results found for "$query"',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      )
          : VehicleListingWidget(
        vehicles: _filteredVehicles,
        themeMain: themeMain,
        onRentNow: (vehicle) => _handleRentNow(context, vehicle),
      ),
    );
  }
}