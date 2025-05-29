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
            onPressed: () => _navigateToPostScreen(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBDEFB),
              Colors.white,
            ],
            stops: [0.0, 0.6],
          ),
        ),
        child: Column(
          children: [
            _buildDashboardHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  const SearchBarWidget(),
                  _buildQuickStatsRow(),
                  const PromoSliderWidget(),
                  VehicleCategoriesWidget(themeMain: themeMain),
                  const SizedBox(height: 24),
                  FeaturedVehiclesAdminWidget(
                    vehicles: vehicles,
                    themeMain: themeMain,
                  ),
                  VehicleListingAdminWidget(
                    vehicles: vehicles,
                    themeMain: themeMain,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeMain,
        onPressed: () => _navigateToPostScreen(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPostScreen(
          themeMain: themeMain,
          headlineFontSize: 22,
        ),
      ),
    );
  }

  Widget _buildDashboardHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
          const SizedBox(width: 12),
          _buildStatBadge('Available', '18', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
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
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: _buildQuickStatItem('Users', '1,234', Icons.people_alt)),
          Expanded(child: _buildQuickStatItem('Revenue', '\₱12,345', Icons.currency_exchange)),
          Expanded(child: _buildQuickStatItem('Bookings', '89', Icons.calendar_today)),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: themeMain, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeMain,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalytics(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE3F2FD),
                Colors.white,
              ],
              stops: [0.0, 0.6],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Platform Analytics',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeMain,
                  ),
                ),
              ),
              ..._buildAnalyticsItems(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: themeMain,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnalyticsItems() {
    return [
      _buildAnalyticsItem('Total Vehicles', vehicles.length.toString()),
      _buildAnalyticsItem('Active Rentals', '24'),
      _buildAnalyticsItem('Registered Users', '1,234'),
      _buildAnalyticsItem('Monthly Revenue', '\₱12,345'),
      _buildAnalyticsItem('Maintenance Issues', '3'),
      _buildAnalyticsItem('Pending Approvals', '5'),
    ];
  }

  Widget _buildAnalyticsItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeMain,
            ),
          ),
        ],
      ),
    );
  }
}