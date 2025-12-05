import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/providers/parking_provider.dart';
import 'package:parkmate/providers/parking_rate_provider.dart';
import 'dart:async';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'Vehicle Number';

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
    _searchController.dispose();
    super.dispose();
  }

  void _scanQR(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScanPage()),
    );

    if (result != null && result is String) {
      _handleScannedTicket(result);
    }
  }

  void _handleScannedTicket(String ticketId) {
    final parkingProvider = Provider.of<ParkingProvider>(
      context,
      listen: false,
    );
    final rateProvider = Provider.of<ParkingRateProvider>(
      context,
      listen: false,
    );

    try {
      final ticket = parkingProvider.activeTickets.firstWhere(
        (t) => t.id == ticketId,
      );

      final duration = DateTime.now().difference(ticket.checkInTime);
      final cost = rateProvider.calculateCost(ticket.vehicleType, duration);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Checkout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle: ${ticket.vehicleNumber}'),
              Text('Type: ${ticket.vehicleType}'),
              Text(
                'Duration: ${duration.inHours}h ${duration.inMinutes % 60}m',
              ),
              const SizedBox(height: 10),
              Text(
                'Total Cost: ₹${cost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await parkingProvider.checkOutTicket(
                  ticket.id,
                  DateTime.now(),
                  cost,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Checked out ${ticket.vehicleNumber}. Cost: ₹${cost.toStringAsFixed(2)}',
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                  Navigator.pop(context); // Close CheckOutPage and go to Home
                }
              },
              child: const Text('Check Out'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket not found or already checked out.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate =
        "${_currentTime.day.toString().padLeft(2, '0')}/${_currentTime.month.toString().padLeft(2, '0')}/${_currentTime.year}";
    final formattedTime = TimeOfDay.fromDateTime(_currentTime).format(context);
    final rateProvider = Provider.of<ParkingRateProvider>(context);

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search by $_filterType...',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.filter_list,
                    color: theme.colorScheme.primary,
                  ),
                  tooltip: 'Filter by',
                  onSelected: (String newValue) {
                    setState(() {
                      _filterType = newValue;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Vehicle Number',
                          child: Text('Vehicle Number'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Phone Number',
                          child: Text('Phone Number'),
                        ),
                      ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    _scanQR(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ParkingProvider>(
              builder: (context, parkingProvider, child) {
                final filteredTickets = parkingProvider.activeTickets.where((
                  ticket,
                ) {
                  final query = _searchController.text.toLowerCase();
                  if (query.isEmpty) return true;
                  if (_filterType == 'Vehicle Number') {
                    return ticket.vehicleNumber.toLowerCase().contains(query);
                  } else {
                    return ticket.phoneNumber?.toLowerCase().contains(query) ??
                        false;
                  }
                }).toList();

                if (filteredTickets.isEmpty) {
                  return Center(
                    child: Text(
                      'No vehicles found.',
                      style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 18,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = filteredTickets[index];
                    final duration = _currentTime.difference(
                      ticket.checkInTime,
                    );
                    final cost = rateProvider.calculateCost(
                      ticket.vehicleType,
                      duration,
                    );

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
                                      ticket.vehicleType == 'Bike'
                                          ? Icons.motorcycle
                                          : Icons.directions_car,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Check-In: ${ticket.checkInTime.day.toString().padLeft(2, '0')}/${ticket.checkInTime.month.toString().padLeft(2, '0')}/${ticket.checkInTime.year} ${TimeOfDay.fromDateTime(ticket.checkInTime).format(context)}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Check-Out: $formattedDate $formattedTime',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Duration: ${duration.inHours}h ${duration.inMinutes % 60}m',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Total Cost: ₹${cost.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (ticket.slotNumber != null)
                              Text(
                                'Slot: ${ticket.slotNumber}',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await parkingProvider.checkOutTicket(
                                    ticket.id,
                                    DateTime.now(),
                                    cost,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Checked out ${ticket.vehicleNumber}. Cost: ₹${cost.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Check Out',
                                  style: TextStyle(
                                    color: theme.colorScheme.onError,
                                  ),
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
          ),
        ],
      ),
    );
  }
}

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  late MobileScannerController controller;
  bool _isScanned = false;
  String _status = "Camera initializing...";

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      // Re-enabling specific settings as the lifecycle issues should be resolved by start/stop calls
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: [BarcodeFormat.qrCode],
      returnImage: false,
    );
    // Force start the camera
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.start();
    });
  }

  @override
  void dispose() {
    // Stop before disposing
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                setState(() {
                  _status = "Detected! Processing...";
                });
              }

              for (final barcode in barcodes) {
                if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                  setState(() {
                    _isScanned = true;
                  });
                  Navigator.pop(context, barcode.rawValue);
                  break;
                }
              }
            },
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Camera Error: ${error.errorCode}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      error.errorDetails?.message ?? 'Unknown error',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          const QRScannerOverlay(overlayColour: Colors.black54),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              "Align QR code within the frame",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({super.key, required this.overlayColour});

  final Color overlayColour;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(overlayColour, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
