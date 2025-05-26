import 'package:flutter/material.dart';

class VehicleCategoriesWidget extends StatelessWidget {
  final Color themeMain;

  const VehicleCategoriesWidget({super.key, required this.themeMain});

  @override
  Widget build(BuildContext context) {
    const categories = ['Cars', 'Bikes', 'Scooters', 'Luxury'];
    const icons = [
      Icons.directions_car,
      Icons.motorcycle,
      Icons.electric_scooter,
      Icons.directions_boat
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          categories.length,
              (index) => GestureDetector(
            onTap: () => _handleCategorySelect(categories[index]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: themeMain.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icons[index],
                    size: 32,
                    color: themeMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: themeMain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCategorySelect(String category) {
    // Implement category selection logic
    print('Selected category: $category');
  }
}