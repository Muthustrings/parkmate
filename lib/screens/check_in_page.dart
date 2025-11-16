import 'package:flutter/material.dart';
import 'package:parkmate/utils/color_page.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  String _selectedVehicleType = 'Bike'; // Default to Bike

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Check-In',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                              ? Colors.white
                              : AppColors.primaryColor),
                      label: Text('Bike',
                          style: TextStyle(
                              color: _selectedVehicleType == 'Bike'
                                  ? Colors.white
                                  : AppColors.primaryColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedVehicleType == 'Bike'
                            ? AppColors.secondaryColor
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: _selectedVehicleType == 'Bike'
                                  ? Colors.transparent
                                  : AppColors.primaryColor),
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
                              ? Colors.white
                              : AppColors.primaryColor),
                      label: Text('Car',
                          style: TextStyle(
                              color: _selectedVehicleType == 'Car'
                                  ? Colors.white
                                  : AppColors.primaryColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedVehicleType == 'Car'
                            ? AppColors.secondaryColor
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: _selectedVehicleType == 'Car'
                                  ? Colors.transparent
                                  : AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Vehicle Number Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),
              // Phone Number Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              // Slot No. Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'Slot No. (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.local_parking),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              // Generate Ticket Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Generate Ticket
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Generate Ticket',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
