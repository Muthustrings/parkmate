import 'package:flutter/material.dart';
// Removed unused import: import 'package:parkmate/utils/color_page.dart';

import 'package:provider/provider.dart';
import 'package:parkmate/providers/parking_provider.dart';
import 'package:parkmate/models/ticket.dart';
import 'package:parkmate/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  String _selectedVehicleType = 'Bike'; // Default to Bike
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _slotController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = "${_selectedDate.toLocal()}".split(' ')[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize time here where context is available
    if (_timeController.text.isEmpty) {
      _timeController.text = _selectedTime.format(context);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Check-In',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                      icon: Icon(
                        Icons.motorcycle,
                        color: _selectedVehicleType == 'Bike'
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface,
                      ),
                      label: Text(
                        'Bike',
                        style: TextStyle(
                          color: _selectedVehicleType == 'Bike'
                              ? theme.colorScheme.onSecondary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedVehicleType == 'Bike'
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.surface,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: _selectedVehicleType == 'Bike'
                                ? Colors.transparent
                                : theme.colorScheme.outline,
                          ),
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
                      icon: Icon(
                        Icons.directions_car,
                        color: _selectedVehicleType == 'Car'
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface,
                      ),
                      label: Text(
                        'Car',
                        style: TextStyle(
                          color: _selectedVehicleType == 'Car'
                              ? theme.colorScheme.onSecondary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
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
                                : theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (value.length == 10) {
                    _checkExistingCustomer(value);
                  }
                },
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Phone number must contain only digits';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Vehicle Number Input
              TextFormField(
                controller: _vehicleNumberController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Vehicle Number',
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  prefixIcon: Icon(
                    Icons.numbers,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle number';
                  }
                  return null;
                },
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
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _dateController.text = "${pickedDate.toLocal()}"
                                .split(' ')[0];
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
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.access_time,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant,
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
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
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  prefixIcon: Icon(
                    Icons.local_parking,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
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
                    if (_formKey.currentState!.validate()) {
                      final DateTime checkInDateTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );

                      final userProvider = Provider.of<UserProvider>(
                        context,
                        listen: false,
                      );
                      final createdBy = userProvider.user?.phone;

                      final ticket = Ticket(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        vehicleNumber: _vehicleNumberController.text,
                        vehicleType: _selectedVehicleType,
                        phoneNumber: _phoneController.text.isNotEmpty
                            ? _phoneController.text
                            : null,
                        slotNumber: _slotController.text.isNotEmpty
                            ? _slotController.text
                            : null,
                        checkInTime: checkInDateTime,
                        createdBy: createdBy,
                      );

                      Provider.of<ParkingProvider>(
                        context,
                        listen: false,
                      ).addTicket(ticket);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Ticket Generated Successfully!',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          duration: const Duration(seconds: 2),
                        ),
                      );

                      if (ticket.phoneNumber != null &&
                          ticket.phoneNumber!.isNotEmpty) {
                        _launchWhatsApp(ticket);
                      }

                      Navigator.pop(context);
                    }
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
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkExistingCustomer(String phoneNumber) async {
    final parkingProvider = Provider.of<ParkingProvider>(
      context,
      listen: false,
    );
    // Combine active and history tickets to find all past records
    final allTickets = [
      ...parkingProvider.activeTickets,
      ...parkingProvider.historyTickets,
    ];

    // Find unique vehicle numbers associated with this phone number
    final userVehicles = allTickets
        .where((ticket) => ticket.phoneNumber == phoneNumber)
        .map((ticket) => ticket.vehicleNumber)
        .toSet()
        .toList();

    if (userVehicles.isNotEmpty) {
      if (userVehicles.length == 1) {
        // Only one vehicle found, auto-fill
        setState(() {
          _vehicleNumberController.text = userVehicles.first;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehicle number auto-filled!'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        // Multiple vehicles found, show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Select Vehicle'),
              children: userVehicles.map((vehicle) {
                return SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      _vehicleNumberController.text = vehicle;
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(vehicle, style: const TextStyle(fontSize: 16)),
                  ),
                );
              }).toList(),
            );
          },
        );
      }
    }
  }

  Future<void> _launchWhatsApp(Ticket ticket) async {
    final message =
        "ParkMate Ticket\n"
        "Vehicle: ${ticket.vehicleNumber}\n"
        "Type: ${ticket.vehicleType}\n"
        "Slot: ${ticket.slotNumber ?? 'N/A'}\n"
        "Check-In: ${ticket.checkInTime.toString()}";

    final url = Uri.parse(
      "https://wa.me/${ticket.phoneNumber}?text=${Uri.encodeComponent(message)}",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    }
  }
}
