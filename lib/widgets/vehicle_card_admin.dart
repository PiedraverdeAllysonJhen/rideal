import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleCardAdminWidget extends StatelessWidget {
  final Vehicle vehicle;
  final Color themeMain;

  const VehicleCardAdminWidget({
    super.key,
    required this.vehicle,
    required this.themeMain,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and featured badge (same as client version)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${vehicle.rating} (${vehicle.reviews})'),
                    const Spacer(),
                    Text(
                      '\$${vehicle.price}/day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: themeMain,
                      onPressed: () => _editVehicle(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _deleteVehicle(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editVehicle(BuildContext context) {
    // Handle edit vehicle
  }

  void _deleteVehicle(BuildContext context) {
    // Handle delete vehicle
  }
}