import 'package:flutter/material.dart';
import 'package:parkmate/utils/color_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedPeriod = 'Today'; // Default selected period

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
          'History',
          style: TextStyle(color: Colors.white),
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
                    title: "Today's Revenue",
                    value: "₹2,430",
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    title: "Total Tickets",
                    value: "78",
                    color: AppColors.primaryColor,
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
                _buildPeriodButton('Today'),
                _buildPeriodButton('Week'),
                _buildPeriodButton('Month'),
              ],
            ),
          ),
          // History List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                HistoryListItem(
                  vehicleNumber: 'KA09MG3015',
                  ticketId: 'PM-2025-00072',
                  checkInTime: '10:45 AM',
                  checkOutTime: '12:50 PM',
                  amount: '₹80',
                ),
                HistoryListItem(
                  vehicleNumber: 'TN34F2196',
                  ticketId: 'PM-2025-00071',
                  checkInTime: '12:20 PM',
                  checkOutTime: '12:00 PM',
                  amount: '₹96',
                ),
                HistoryListItem(
                  vehicleNumber: 'KL52R8064',
                  ticketId: 'PM-2025-00070',
                  checkInTime: '11:00 AM',
                  checkOutTime: '11:00 PM',
                  amount: '₹100',
                ),
                HistoryListItem(
                  vehicleNumber: 'KA04HS5569',
                  ticketId: 'PM-2025-00069',
                  checkInTime: '10:10 AM',
                  checkOutTime: '10:00 PM',
                  amount: '₹80',
                ),
                // Add more HistoryListItem widgets as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value, required Color color}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
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

  Widget _buildPeriodButton(String period) {
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
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 40,
              color: AppColors.primaryColor,
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

  const HistoryListItem({
    super.key,
    required this.vehicleNumber,
    required this.ticketId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
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
                  vehicleNumber,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              ticketId,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Check-in',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text(
                      checkInTime,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Check-out',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text(
                      checkOutTime,
                      style: const TextStyle(fontSize: 14.0),
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
