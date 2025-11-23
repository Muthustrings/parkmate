import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/providers/parking_provider.dart';
import 'package:parkmate/models/ticket.dart';

import 'dart:async'; // Import Timer

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = "${_currentTime.day.toString().padLeft(2, '0')}/${_currentTime.month.toString().padLeft(2, '0')}/${_currentTime.year}";
    final formattedTime = TimeOfDay.fromDateTime(_currentTime).format(context);

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
          'Check-Out',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: Consumer<ParkingProvider>(
        builder: (context, parkingProvider, child) {
          if (parkingProvider.activeTickets.isEmpty) {
            return Center(
              child: Text(
                'No vehicles parked currently.',
                style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: parkingProvider.activeTickets.length,
            itemBuilder: (context, index) {
              final ticket = parkingProvider.activeTickets[index];
              return Card(
                color: theme.colorScheme.surface,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ticket.vehicleNumber,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                ticket.vehicleType,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                ticket.vehicleType == 'Bike' ? Icons.motorcycle : Icons.directions_car,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Check-In: ${ticket.checkInTime.day.toString().padLeft(2, '0')}/${ticket.checkInTime.month.toString().padLeft(2, '0')}/${ticket.checkInTime.year} ${TimeOfDay.fromDateTime(ticket.checkInTime).format(context)}',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Check-Out: $formattedDate $formattedTime',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                      ),
                      if (ticket.slotNumber != null)
                        Text(
                          'Slot: ${ticket.slotNumber}',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            parkingProvider.checkOutTicket(ticket.id, DateTime.now());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Checked out ${ticket.vehicleNumber}', style: TextStyle(color: theme.colorScheme.onSurface)),
                                backgroundColor: theme.colorScheme.primary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Check Out',
                            style: TextStyle(color: theme.colorScheme.onError),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
