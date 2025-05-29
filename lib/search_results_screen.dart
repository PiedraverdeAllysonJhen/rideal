import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'widgets/vehicle_listing.dart';
import 'booking_screen.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBDEFB), // Light blue
              Colors.white,
            ],
            stops: [0.2, 0.8],
          ),
        ),
        child: _filteredVehicles.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.blueGrey[300],
                ),
                const SizedBox(height: 20),
                Text(
                  'No vehicles found for "$query"',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Try searching for different keywords like "sedan", "SUV", or campus location',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
            : VehicleListingWidget(
          vehicles: _filteredVehicles,
          themeMain: themeMain,
          onRentNow: (vehicle) => _handleRentNow(context, vehicle),
        ),
      ),
    );
  }
}