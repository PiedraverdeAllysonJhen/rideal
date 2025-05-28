// vehicle_card.dart
import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleCardWidget extends StatefulWidget {
  final Vehicle vehicle;
  final bool isFeatured;
  final Color themeMain;
  final Function(Vehicle)? onRentNow;  // Properly define callback

  const VehicleCardWidget({
    super.key,
    required this.vehicle,
    this.isFeatured = false,
    required this.themeMain,
    this.onRentNow,  // Add this parameter
  });

  @override
  State<VehicleCardWidget> createState() => _VehicleCardWidgetState();
}

class _VehicleCardWidgetState extends State<VehicleCardWidget> {
  void toggleBookmark() {
    setState(() {
      widget.vehicle.isBookmarked = !widget.vehicle.isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = widget.isFeatured ? 100 : 120;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: imageHeight,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                  child: Image.network(
                    widget.vehicle.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (widget.isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.themeMain,
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: toggleBookmark,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.vehicle.isBookmarked
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellowAccent,
                        size: 20,
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
                  widget.vehicle.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      ' ${widget.vehicle.rating} (${widget.vehicle.reviews})',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      '₱${widget.vehicle.price}/day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: widget.themeMain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.themeMain,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    onPressed: () {
                      if (widget.onRentNow != null) {
                        widget.onRentNow!(widget.vehicle);
                      }
                    },
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