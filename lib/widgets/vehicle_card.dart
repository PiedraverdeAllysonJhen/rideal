import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleCardWidget extends StatefulWidget {
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
  State<VehicleCardWidget> createState() => _VehicleCardWidgetState();
}

class _VehicleCardWidgetState extends State<VehicleCardWidget> {
  bool isBookmarked = false;

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });

    // Optional: Call a method to store bookmark state, e.g., via a service
  }

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
                    widget.vehicle.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Featured Label
                if (widget.isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

                // Bookmark Icon (Star)
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
                        isBookmarked ? Icons.star : Icons.star_border,
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${widget.vehicle.rating} (${widget.vehicle.reviews})'),
                    const Spacer(),
                    Text(
                      '₱${widget.vehicle.price}/day',
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
  }
}
