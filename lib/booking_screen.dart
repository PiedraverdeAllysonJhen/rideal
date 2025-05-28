import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/vehicle.dart';

class BookingScreen extends StatefulWidget {
  final Vehicle? selectedVehicle;
  final Color themeMain;
  final VoidCallback? onBookingComplete;

  const BookingScreen({
    super.key,
    this.selectedVehicle,
    required this.themeMain,
    this.onBookingComplete,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _totalDays = 0;
  double _totalPrice = 0.0;
  int _currentStep = 0;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }

        if (_startDate != null && _endDate != null) {
          _totalDays = _endDate!.difference(_startDate!).inDays + 1;
          _totalPrice = _totalDays * (widget.selectedVehicle?.price ?? 0);
        }
      });
    }
  }

  void _completeBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmed'),
        content: const Text('Your payment was successful!\nEnjoy your ride!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onBookingComplete != null) {
                widget.onBookingComplete!();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings & Payments'),
        backgroundColor: widget.themeMain,
        foregroundColor: Colors.white,
      ),
      body: widget.selectedVehicle == null
          ? _buildEmptyState()
          : _buildBookingStepper(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'No Active Bookings',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start by renting a vehicle from the Home screen',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingStepper() {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: () {
        if (_currentStep == 0 && (_startDate == null || _endDate == null)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select both dates')),
          );
          return;
        }
        setState(() => _currentStep = _currentStep < 1 ? _currentStep + 1 : 0);
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() => _currentStep--);
        }
      },
      steps: [
        Step(
          title: const Text('Booking Details'),
          content: _buildBookingDetails(),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text('Payment'),
          content: _buildPaymentSection(),
          isActive: _currentStep >= 1,
        ),
      ],
    );
  }

  Widget _buildBookingDetails() {
    return Column(
      children: [
        _buildVehicleInfo(),
        const SizedBox(height: 20),
        _buildDateSelector('Start Date', _startDate, true),
        const SizedBox(height: 15),
        _buildDateSelector('End Date', _endDate, false),
        const SizedBox(height: 20),
        _buildPriceSummary(),
      ],
    );
  }

  Widget _buildVehicleInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.selectedVehicle!.imageUrl,
            width: 100,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.selectedVehicle!.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(' ${widget.selectedVehicle!.rating}'),
                  const SizedBox(width: 10),
                  Text('${widget.selectedVehicle!.reviews} reviews'),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                '₱${widget.selectedVehicle!.price}/day',
                style: TextStyle(
                  color: widget.themeMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, bool isStartDate) {
    return InkWell(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date != null
                      ? DateFormat('MMM dd, yyyy').format(date)
                      : 'Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    color: date != null ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
            Icon(Icons.calendar_month, color: widget.themeMain),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildSummaryRow('Daily Rate', '₱${widget.selectedVehicle!.price}'),
            _buildSummaryRow('Total Days', _totalDays.toString()),
            const Divider(),
            _buildSummaryRow('Total Price', '₱$_totalPrice', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? widget.themeMain : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Card Number',
            prefixIcon: Icon(Icons.credit_card),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.themeMain,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          onPressed: _completeBooking,
          child: const Text('Confirm Payment'),
        ),
      ],
    );
  }
}