import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/providers/parking_rate_provider.dart';

class RateSettingsPage extends StatefulWidget {
  const RateSettingsPage({super.key});

  @override
  State<RateSettingsPage> createState() => _RateSettingsPageState();
}

class _RateSettingsPageState extends State<RateSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // Bike Controllers
  final TextEditingController _bikeRateController = TextEditingController();
  double _bikeDuration = 1.0;

  // Car Controllers
  final TextEditingController _carRateController = TextEditingController();
  double _carDuration = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rateProvider = Provider.of<ParkingRateProvider>(
        context,
        listen: false,
      );
      _bikeRateController.text = rateProvider.bikeRate.toString();
      _carRateController.text = rateProvider.carRate.toString();
      setState(() {
        _bikeDuration = rateProvider.bikeDuration;
        _carDuration = rateProvider.carDuration;
      });
    });
  }

  @override
  void dispose() {
    _bikeRateController.dispose();
    _carRateController.dispose();
    super.dispose();
  }

  void _saveRates() {
    if (_formKey.currentState!.validate()) {
      final rateProvider = Provider.of<ParkingRateProvider>(
        context,
        listen: false,
      );

      rateProvider.updateBikeRates(
        rate: double.parse(_bikeRateController.text),
        duration: _bikeDuration,
      );

      rateProvider.updateCarRates(
        rate: double.parse(_carRateController.text),
        duration: _carDuration,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rates updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildRateInput({
    required TextEditingController rateController,
    required double duration,
    required ValueChanged<double?> onDurationChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: rateController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Rate (₹)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.currency_rupee),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (double.tryParse(value) == null) return 'Invalid number';
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<double>(
            value: duration,
            decoration: const InputDecoration(
              labelText: 'Per Duration',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.timer),
            ),
            items: [0.5, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 12.0, 24.0].map((hours) {
              String label;
              if (hours == 0.5) {
                label = '30 Mins';
              } else {
                label = '${hours.toInt()} Hour${hours == 1 ? '' : 's'}';
              }
              return DropdownMenuItem(value: hours, child: Text(label));
            }).toList(),
            onChanged: onDurationChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Rates'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Bike Rates',
                Icons.motorcycle,
                theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              _buildRateInput(
                rateController: _bikeRateController,
                duration: _bikeDuration,
                onDurationChanged: (value) {
                  if (value != null) setState(() => _bikeDuration = value);
                },
              ),
              const Divider(height: 40, thickness: 1),
              _buildSectionHeader(
                'Car Rates',
                Icons.directions_car,
                theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              _buildRateInput(
                rateController: _carRateController,
                duration: _carDuration,
                onDurationChanged: (value) {
                  if (value != null) setState(() => _carDuration = value);
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveRates,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save Rates',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onPrimary,
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
}
