import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RentalRequest {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String vehicleId;
  final String vehicleName;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  RentalRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.vehicleId,
    required this.vehicleName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.totalPrice,
    this.status = 'pending',
    required this.createdAt,
  });
}

class AdminRequestsScreen extends StatefulWidget {
  final Color themeMain;
  final Color themeLite;
  final Color themeGrey;

  const AdminRequestsScreen({
    super.key,
    this.themeMain = const Color(0xFF1976D2),
    this.themeLite = const Color(0xFFBBDEFB),
    this.themeGrey = const Color(0xFF424242),
  });

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  List<RentalRequest> requests = [];
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Pending', 'Approved', 'Rejected', 'Completed'];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    requests = [
      RentalRequest(
        id: '1',
        userId: 'user1',
        userName: 'Juan Dela Cruz',
        userEmail: 'juan@example.com',
        vehicleId: 'v1',
        vehicleName: 'Honda Civic 2023',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 3)),
        totalDays: 3,
        totalPrice: 7200,
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      RentalRequest(
        id: '2',
        userId: 'user2',
        userName: 'Maria Santos',
        userEmail: 'maria@example.com',
        vehicleId: 'v2',
        vehicleName: 'Toyota Fortuner',
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        totalDays: 4,
        totalPrice: 12000,
        status: 'approved',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RentalRequest(
        id: '3',
        userId: 'user3',
        userName: 'Pedro Reyes',
        userEmail: 'pedro@example.com',
        vehicleId: 'v3',
        vehicleName: 'Suzuki Ertiga',
        startDate: DateTime.now().add(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 7)),
        totalDays: 5,
        totalPrice: 10000,
        status: 'rejected',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RentalRequest(
        id: '4',
        userId: 'user4',
        userName: 'Ana Torres',
        userEmail: 'ana@example.com',
        vehicleId: 'v4',
        vehicleName: 'Mitsubishi Montero',
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 1)),
        totalDays: 3,
        totalPrice: 9000,
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
    setState(() {});
  }

  List<RentalRequest> get filteredRequests {
    if (selectedFilter == 'All') return requests;
    return requests.where((r) => r.status.toLowerCase() == selectedFilter.toLowerCase()).toList();
  }

  void _updateRequestStatus(String requestId, String newStatus) {
    setState(() {
      final index = requests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        requests[index] = RentalRequest(
          id: requests[index].id,
          userId: requests[index].userId,
          userName: requests[index].userName,
          userEmail: requests[index].userEmail,
          vehicleId: requests[index].vehicleId,
          vehicleName: requests[index].vehicleName,
          startDate: requests[index].startDate,
          endDate: requests[index].endDate,
          totalDays: requests[index].totalDays,
          totalPrice: requests[index].totalPrice,
          status: newStatus,
          createdAt: requests[index].createdAt,
        );
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return widget.themeMain;
      default:
        return widget.themeGrey;
    }
  }

  // Use more compact date format
  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yy').format(date);
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MM/dd/yy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Requests'),
        backgroundColor: widget.themeMain,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Filter Requests',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ...filterOptions.map((option) {
                              return RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: selectedFilter,
                                onChanged: (value) {
                                  setState(() => selectedFilter = value!);
                                  Navigator.pop(context);
                                  this.setState(() {});
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFBBDEFB), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final option = filterOptions[index];
                  final isSelected = selectedFilter == option;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (_) => setState(() => selectedFilter = option),
                      selectedColor: widget.themeLite,
                      checkmarkColor: widget.themeMain,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: filteredRequests.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  return _buildRequestCard(filteredRequests[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.request_quote, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              selectedFilter == 'All' ? 'No Rental Requests' : 'No $selectedFilter Requests',
              style: TextStyle(fontSize: 22, color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              selectedFilter == 'All'
                  ? 'All requests are processed'
                  : 'No ${selectedFilter.toLowerCase()} requests at the moment',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(RentalRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      request.vehicleName,
                      style: const TextStyle(
                        fontSize: 16, // Slightly smaller font
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 100), // Smaller max width
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
                    decoration: BoxDecoration(
                      color: _getStatusColor(request.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: _getStatusColor(request.status)),
                    ),
                    child: Text(
                      request.status.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(request.status),
                        fontSize: 11, // Smaller font size
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _infoRow(Icons.person, request.userName),
              _infoRow(Icons.email, request.userEmail),
              const Divider(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start', style: TextStyle(fontSize: 11, color: widget.themeGrey)), // Smaller font
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(request.startDate),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Smaller font
                      ),
                    ],
                  ),
                  const SizedBox(width: 16), // Reduced spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End', style: TextStyle(fontSize: 11, color: widget.themeGrey)), // Smaller font
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(request.endDate),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Smaller font
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 11, color: Colors.grey)), // Smaller font
                      const SizedBox(height: 2),
                      Text(
                        '₱${request.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey[600]), // Smaller icon
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeAgo(request.createdAt),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]), // Smaller font
                      ),
                    ],
                  ),
                  if (request.status == 'pending')
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: () => _updateRequestStatus(request.id, 'rejected'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Smaller padding
                            minimumSize: const Size(0, 32), // Smaller height
                          ),
                          child: const Text('Reject', style: TextStyle(fontSize: 13)), // Smaller font
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          onPressed: () => _updateRequestStatus(request.id, 'approved'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Smaller padding
                            minimumSize: const Size(0, 32), // Smaller height
                          ),
                          child: const Text('Approve', style: TextStyle(fontSize: 13)), // Smaller font
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4), // Reduced padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 14, color: widget.themeGrey), // Smaller icon
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: widget.themeGrey), // Smaller font
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}