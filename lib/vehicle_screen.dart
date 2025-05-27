import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleScreen extends StatefulWidget {
  final List<Vehicle> vehicles;
  final Color themeMain;

  const VehicleScreen({
    super.key,
    required this.vehicles,
    this.themeMain = const Color(0xFF1976D2),
  });

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  List<Vehicle> get bookmarkedVehicles =>
      widget.vehicles.where((v) => v.isBookmarked).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Vehicles'),
        backgroundColor: widget.themeMain,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBDEFB),  // Light blue
              Colors.white,        // White
            ],
            stops: [0.0, 0.6],
          ),
        ),
        child: bookmarkedVehicles.isEmpty
            ? const Center(
          child: Text(
            'No bookmarked vehicles.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: bookmarkedVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = bookmarkedVehicles[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      ),
                      child: Image.network(
                        vehicle.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            vehicle.isBookmarked = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                            '₱${vehicle.price}/day',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.themeMain,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.themeMain,
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
        },
      ),
      ),
    );
  }
}
