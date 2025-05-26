// widgets/featured_vehicles_admin.dart
import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'vehicle_card_admin.dart';

class FeaturedVehiclesAdminWidget extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Color themeMain;

  const FeaturedVehiclesAdminWidget({
    super.key,
    required this.vehicles,
    required this.themeMain,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Featured Vehicles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vehicles.length,
            itemBuilder: (context, index) => SizedBox(
              width: 280,
              child: VehicleCardAdminWidget(
                vehicle: vehicles[index],
                themeMain: themeMain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}