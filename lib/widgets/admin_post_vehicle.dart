import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPostScreen extends StatefulWidget {
  final Color themeMain;
  final double headlineFontSize;

  const AdminPostScreen({
    super.key,
    required this.themeMain,
    required this.headlineFontSize,
  });

  @override
  State<AdminPostScreen> createState() => _AdminPostScreenState();
}

class _AdminPostScreenState extends State<AdminPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSubmitting = false;

  final List<String> _vehicleTypes = [
    'Bicycle',
    'Scooter',
    'Motorcycle',
    'Car',
    'Electric Vehicle'
  ];

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _availabilityController.text =
              DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDate!);
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Vehicle posted successfully!'),
            backgroundColor: widget.themeMain,
          ),
        );
        _formKey.currentState!.reset();
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Text(
                    "Post New Vehicle",
                    style: TextStyle(
                      fontSize: widget.headlineFontSize,
                      fontWeight: FontWeight.bold,
                      color: widget.themeMain,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Vehicle Details'),
                _buildVehicleTypeDropdown(),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _nameController,
                  label: 'Vehicle Name',
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _descController,
                  label: 'Description',
                  lineCount: 3,
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Pricing & Availability'),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextFormField(
                        controller: _priceController,
                        label: 'Price per hour',
                        keyboardType: TextInputType.number,
                        prefix: const Text('\$ '),
                        validator: (value) {
                          if (value!.isEmpty) return 'Required field';
                          if (double.tryParse(value) == null) return 'Invalid number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _buildTextFormField(
                        controller: _availabilityController,
                        label: 'Available From',
                        readOnly: true,
                        onTap: () => _selectDateAndTime(context),
                        validator: (value) => value!.isEmpty ? 'Required field' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.check_circle_outline),
                    label: Text(_isSubmitting ? 'Posting...' : 'Submit Vehicle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.themeMain,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: widget.headlineFontSize * 0.9,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    int? lineCount,
    TextInputType? keyboardType,
    Widget? prefix,
    bool readOnly = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefix: prefix,
        suffixIcon: readOnly ? const Icon(Icons.calendar_today) : null,
      ),
      maxLines: lineCount,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _vehicleTypes.first,
      decoration: InputDecoration(
        labelText: 'Vehicle Type',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
      items: _vehicleTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) => _typeController.text = value!,
      validator: (value) => value == null ? 'Required field' : null,
    );
  }
}