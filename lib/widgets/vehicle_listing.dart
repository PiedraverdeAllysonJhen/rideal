import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'vehicle_card.dart';

class VehicleListingWidget extends StatefulWidget {
  final List<Vehicle> vehicles;
  final Color themeMain;
  final Function(Vehicle)? onRentNow;

  const VehicleListingWidget({
    super.key,
    required this.vehicles,
    required this.themeMain,
    this.onRentNow,
  });

  @override
  State<VehicleListingWidget> createState() => _VehicleListingWidgetState();
}

class _VehicleListingWidgetState extends State<VehicleListingWidget> {
  String _sortBy = 'price';
  List<Vehicle> _sortedVehicles = [];

  @override
  void initState() {
    super.initState();
    _sortVehicles();
  }

  void _sortVehicles() {
    setState(() {
      _sortedVehicles = List.from(widget.vehicles)
        ..sort((a, b) {
          switch (_sortBy) {
            case 'price':
              return a.price.compareTo(b.price);
            case 'rating':
              return b.rating.compareTo(a.rating);
            case 'distance':
              return a.distance.compareTo(b.distance);
            default:
              return 0;
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSortHeader(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0),
              itemCount: _sortedVehicles.length,
              itemBuilder: (context, index) => VehicleCardWidget(
                vehicle: _sortedVehicles[index],
                themeMain: widget.themeMain,
                onRentNow: widget.onRentNow,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
              'Available Vehicles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _sortBy,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'price', child: Text('Price')),
              DropdownMenuItem(value: 'rating', child: Text('Rating')),
              DropdownMenuItem(value: 'distance', child: Text('Distance')),
            ],
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _sortVehicles();
              });
            },
          ),
        ],
      ),
    );
  }
}