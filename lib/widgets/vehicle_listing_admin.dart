import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'vehicle_card_admin.dart';

class VehicleListingAdminWidget extends StatefulWidget {
  final List<Vehicle> vehicles;
  final Color themeMain;

  const VehicleListingAdminWidget({
    super.key,
    required this.vehicles,
    required this.themeMain,
  });

  @override
  State<VehicleListingAdminWidget> createState() => _VehicleListingAdminWidgetState();
}

class _VehicleListingAdminWidgetState extends State<VehicleListingAdminWidget> {
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
            case 'price': return a.price.compareTo(b.price);
            case 'rating': return b.rating.compareTo(a.rating);
            case 'distance': return a.distance.compareTo(b.distance);
            default: return 0;
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSortHeader(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: _sortedVehicles.length,
          itemBuilder: (context, index) => VehicleCardAdminWidget(
            vehicle: _sortedVehicles[index],
            themeMain: widget.themeMain,
          ),
        ),
      ],
    );
  }

  Widget _buildSortHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Manage Vehicles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _sortBy,
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