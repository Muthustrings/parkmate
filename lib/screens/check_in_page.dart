import 'package:flutter/material.dart';
// Removed unused import: import 'package:parkmate/utils/color_page.dart';

import 'package:provider/provider.dart';
import 'package:parkmate/providers/parking_provider.dart';
import 'package:parkmate/models/ticket.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  String _selectedVehicleType = 'Bike'; // Default to Bike
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _slotController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = "${DateTime.now().toLocal()}".split(' ')[0];
    // We can't use context in initState for TimeOfDay.format(context) easily without a delayed callback or just using a default format.
    // Let's use a simple default format for now or wait for the first frame.
    // A simple way is to just use string interpolation for now, or use a post-frame callback.
    // However, TimeOfDay.now().format(context) requires context which is not available in initState.
    // I'll use a listener or just set it in didChangeDependencies.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize time here where context is available
    if (_timeController.text.isEmpty) {
      _timeController.text = TimeOfDay.now().format(context);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface, // Use surface for AppBar background
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface), // Use onSurface for icon color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Check-In',
          style: TextStyle(color: theme.colorScheme.onSurface), // Use onSurface for title color
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Added padding to the scroll view
        child: Column(
          children: [
            // Vehicle Type Selection
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedVehicleType = 'Bike';
                      });
                    },
                    icon: Icon(Icons.motorcycle,
                        color: _selectedVehicleType == 'Bike'
                            ? theme.colorScheme.onSecondary // Use onSecondary for selected icon
                            : theme.colorScheme.onSurface), // Use onSurface for unselected icon
                    label: Text('Bike',
                        style: TextStyle(
                            color: _selectedVehicleType == 'Bike'
                                ? theme.colorScheme.onSecondary // Use onSecondary for selected text
                                : theme.colorScheme.onSurface)), // Use onSurface for unselected text
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedVehicleType == 'Bike'
                          ? theme.colorScheme.secondary // Use secondary for selected background
                          : theme.colorScheme.surface, // Use surface for unselected background
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: _selectedVehicleType == 'Bike'
                                ? Colors.transparent
                                : theme.colorScheme.outline), // Use outline for unselected border
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedVehicleType = 'Car';
                      });
                    },
                    icon: Icon(Icons.directions_car,
                        color: _selectedVehicleType == 'Car'
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface),
                    label: Text('Car',
                        style: TextStyle(
                            color: _selectedVehicleType == 'Car'
                                ? theme.colorScheme.onSecondary
                                : theme.colorScheme.onSurface)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedVehicleType == 'Car'
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.surface,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: _selectedVehicleType == 'Car'
                                ? Colors.transparent
                                : theme.colorScheme.outline),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Vehicle Number Input
            TextField(
              controller: _vehicleNumberController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Vehicle Number',
                labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                prefixIcon: Icon(Icons.numbers, color: theme.colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            // Phone Number Input
            TextField(
              controller: _phoneController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Phone Number (optional)',
                labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                prefixIcon: Icon(Icons.phone, color: theme.colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            // Date and Time Selection
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Date',
                      labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.colorScheme.primary),
                      ),
                      prefixIcon: Icon(Icons.calendar_today, color: theme.colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant,
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    readOnly: true,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Time',
                      labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.colorScheme.primary),
                      ),
                      prefixIcon: Icon(Icons.access_time, color: theme.colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant,
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _timeController.text = pickedTime.format(context);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Slot No. Input
            TextField(
              controller: _slotController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Slot No. (optional)',
                labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                prefixIcon: Icon(Icons.local_parking, color: theme.colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            // Generate Ticket Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_vehicleNumberController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter vehicle number', style: TextStyle(color: theme.colorScheme.onSurface))),
                    );
                    return;
                  }

                  final ticket = Ticket(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    vehicleNumber: _vehicleNumberController.text,
                    vehicleType: _selectedVehicleType,
                    phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
                    slotNumber: _slotController.text.isNotEmpty ? _slotController.text : null,
                    checkInTime: DateTime.now(), // Use current time for simplicity or parse from controllers if needed
                  );

                  Provider.of<ParkingProvider>(context, listen: false).addTicket(ticket);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ticket Generated Successfully!', style: TextStyle(color: theme.colorScheme.onSurface)),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Generate Ticket',
                  style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
