import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'vehicle_card.dart';

class FeaturedVehiclesWidget extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Color themeMain;
  final Function(Vehicle)? onRentNow;

  const FeaturedVehiclesWidget({
    super.key,
    required this.vehicles,
    required this.themeMain,
    this.onRentNow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Featured Vehicles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 225,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              itemCount: vehicles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) => SizedBox(
                width: 230,
                child: VehicleCardWidget(
                  vehicle: vehicles[index],
                  themeMain: themeMain,
                  isFeatured: true,
                  onRentNow: (vehicle) => onRentNow?.call(vehicle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}