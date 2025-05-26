import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleCardWidget extends StatelessWidget {
  final Vehicle vehicle;
  final bool isFeatured;
  final Color themeMain;

  const VehicleCardWidget({
    super.key,
    required this.vehicle,
    this.isFeatured = false,
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
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                  child: Image.network(
                    vehicle.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: themeMain,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeMain,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Rent Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}