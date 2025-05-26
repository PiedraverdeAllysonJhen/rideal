import 'package:flutter/material.dart';
import 'widgets/search_bar.dart';
import 'widgets/promo_slider.dart';
import 'widgets/vehicle_categories.dart';
import 'widgets/featured_vehicles_admin.dart';
import 'widgets/vehicle_listing_admin.dart';
import 'models/vehicle.dart';
import 'widgets/admin_post_vehicle.dart';

class HomeAdminScreen extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Color themeMain;
  final Color themeLite;

  const HomeAdminScreen({
    super.key,
    required this.vehicles,
    required this.themeMain,
    required this.themeLite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: themeMain,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showAnalytics(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPostScreen(
                  themeMain: themeMain,
                  headlineFontSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDashboardHeader(context),
          Expanded(
            child: ListView(
              children: [
                const SearchBarWidget(),
                _buildQuickStatsRow(),
                const PromoSliderWidget(),
                VehicleCategoriesWidget(themeMain: themeMain),
                FeaturedVehiclesAdminWidget(vehicles: vehicles, themeMain: themeMain),
                VehicleListingAdminWidget(vehicles: vehicles, themeMain: themeMain),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeMain,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPostScreen(
              themeMain: themeMain,
              headlineFontSize: 22,
            ),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDashboardHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${vehicles.length} registered vehicles',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          _buildStatBadge('Active', '24', themeMain),
          const SizedBox(width: 8),
          _buildStatBadge('Available', '18', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickStatItem('Users', '1,234', Icons.people_alt),
          ),
          Expanded(
            child: _buildQuickStatItem('Revenue', '\$12,345', Icons.attach_money),
          ),
          Expanded(
            child: _buildQuickStatItem('Bookings', '89', Icons.calendar_today),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: themeMain, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeMain,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showAnalytics(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Platform Analytics'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildAnalyticsItem('Total Vehicles', vehicles.length.toString()),
              _buildAnalyticsItem('Active Rentals', '24'),
              _buildAnalyticsItem('Registered Users', '1,234'),
              _buildAnalyticsItem('Monthly Revenue', '\$12,345'),
              _buildAnalyticsItem('Maintenance Issues', '3'),
              _buildAnalyticsItem('Pending Approvals', '5'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(String title, String value) {
    return ListTile(
      title: Text(title),
      trailing: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: themeMain,
          fontSize: 16,


        ),
      ),
    );
  }
}