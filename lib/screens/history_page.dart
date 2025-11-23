import 'package:flutter/material.dart';
// Removed unused import: import 'package:parkmate/utils/color_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedPeriod = 'Today'; // Default selected period

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
          'History',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: Column(
        children: [
          // Top Cards: Today's Revenue and Total Tickets
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context: context, // Pass context
                    title: "Today's Revenue",
                    value: "₹2,430",
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    context: context, // Pass context
                    title: "Total Tickets",
                    value: "78",
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          // Segmented Control (Today, Week, Month)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPeriodButton(context, 'Today'), // Pass context
                _buildPeriodButton(context, 'Week'), // Pass context
                _buildPeriodButton(context, 'Month'), // Pass context
              ],
            ),
          ),
          // History List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                HistoryListItem(
                  vehicleNumber: 'KA09MG3015',
                  ticketId: 'PM-2025-00072',
                  checkInTime: '10:45 AM',
                  checkOutTime: '12:50 PM',
                  amount: '₹80',
                  context: context, // Pass context
                ),
                HistoryListItem(
                  vehicleNumber: 'TN34F2196',
                  ticketId: 'PM-2025-00071',
                  checkInTime: '12:20 PM',
                  checkOutTime: '12:00 PM',
                  amount: '₹96',
                  context: context, // Pass context
                ),
                HistoryListItem(
                  vehicleNumber: 'KL52R8064',
                  ticketId: 'PM-2025-00070',
                  checkInTime: '11:00 AM',
                  checkOutTime: '11:00 PM',
                  amount: '₹100',
                  context: context, // Pass context
                ),
                HistoryListItem(
                  vehicleNumber: 'KA04HS5569',
                  ticketId: 'PM-2025-00069',
                  checkInTime: '10:10 AM',
                  checkOutTime: '10:00 PM',
                  amount: '₹80',
                  context: context, // Pass context
                ),
                // Add more HistoryListItem widgets as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required BuildContext context, required String title, required String value, required Color color}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: theme.colorScheme.surface, // Use theme's surface color
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: theme.colorScheme.onSurfaceVariant, // Use theme's onSurfaceVariant color
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(BuildContext context, String period) {
    final theme = Theme.of(context);
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: Column(
        children: [
          Text(
            period,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant, // Use theme colors
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 40,
              color: theme.colorScheme.primary, // Use theme's primary color
            ),
        ],
      ),
    );
  }
}

class HistoryListItem extends StatelessWidget {
  final String vehicleNumber;
  final String ticketId;
  final String checkInTime;
  final String checkOutTime;
  final String amount;
  final BuildContext context; // Add context to constructor

  const HistoryListItem({
    super.key,
    required this.vehicleNumber,
    required this.ticketId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.amount,
    required this.context, // Require context
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: theme.colorScheme.surface, // Use theme's surface color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vehicleNumber,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface, // Use theme's onSurface color
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary, // Use theme's primary color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              ticketId,
              style: TextStyle(
                fontSize: 14.0,
                color: theme.colorScheme.onSurfaceVariant, // Use theme's onSurfaceVariant color
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-in',
                      style: TextStyle(fontSize: 14.0, color: theme.colorScheme.onSurfaceVariant), // Use theme's onSurfaceVariant color
                    ),
                    Text(
                      checkInTime,
                      style: TextStyle(fontSize: 14.0, color: theme.colorScheme.onSurface), // Use theme's onSurface color
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Check-out',
                      style: TextStyle(fontSize: 14.0, color: theme.colorScheme.onSurfaceVariant), // Use theme's onSurfaceVariant color
                    ),
                    Text(
                      checkOutTime,
                      style: TextStyle(fontSize: 14.0, color: theme.colorScheme.onSurface), // Use theme's onSurface color
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
