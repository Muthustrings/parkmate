import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/providers/parking_provider.dart';
import 'package:parkmate/models/ticket.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedPeriod = 'Today'; // Default selected period
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'Vehicle Number';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
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
          // Search Bar and Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search...',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filterType,
                      dropdownColor: theme.colorScheme.surface,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      items: <String>['Vehicle Number', 'Phone Number'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _filterType = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ParkingProvider>(
              builder: (context, parkingProvider, child) {
                final historyTickets = parkingProvider.historyTickets;

                // Filter tickets based on selected period and search query
                List<Ticket> filteredTickets = historyTickets.where((ticket) {
                  if (ticket.checkOutTime == null) return false;
                  final now = DateTime.now();
                  bool matchesPeriod = false;

                  if (_selectedPeriod == 'Today') {
                    matchesPeriod =
                        ticket.checkOutTime!.year == now.year &&
                        ticket.checkOutTime!.month == now.month &&
                        ticket.checkOutTime!.day == now.day;
                  } else if (_selectedPeriod == 'Week') {
                    final difference = now.difference(ticket.checkOutTime!);
                    matchesPeriod = difference.inDays <= 7;
                  } else if (_selectedPeriod == 'Month') {
                    final difference = now.difference(ticket.checkOutTime!);
                    matchesPeriod = difference.inDays <= 30;
                  } else {
                    matchesPeriod = true;
                  }

                  if (!matchesPeriod) return false;

                  final query = _searchController.text.toLowerCase();
                  if (query.isEmpty) return true;

                  if (_filterType == 'Vehicle Number') {
                    return ticket.vehicleNumber.toLowerCase().contains(query);
                  } else {
                    return ticket.phoneNumber?.toLowerCase().contains(query) ??
                        false;
                  }
                }).toList();

                // Stats calculation based on filtered tickets
                final totalTickets = filteredTickets.length;
                final revenueValue = filteredTickets.fold(
                  0.0,
                  (sum, ticket) => sum + (ticket.amount ?? 0.0),
                );
                final revenue = "₹${revenueValue.toStringAsFixed(2)}";

                return Column(
                  children: [
                    // Top Cards: Revenue and Total Tickets for Selected Period
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              context: context,
                              title: "$_selectedPeriod's Revenue",
                              value: revenue,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              context: context,
                              title: "Total Tickets",
                              value: totalTickets.toString(),
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Segmented Control (Today, Week, Month)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPeriodButton(context, 'Today'),
                          _buildPeriodButton(context, 'Week'),
                          _buildPeriodButton(context, 'Month'),
                        ],
                      ),
                    ),
                    // History List
                    Expanded(
                      child: filteredTickets.isEmpty
                          ? Center(
                              child: Text(
                                'No history available for $_selectedPeriod',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: filteredTickets.length,
                              itemBuilder: (context, index) {
                                final ticket = filteredTickets[index];
                                return HistoryListItem(
                                  ticket: ticket,
                                  context: context,
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                color: theme.colorScheme.onSurfaceVariant,
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
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 40,
              color: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }
}

class HistoryListItem extends StatelessWidget {
  final Ticket ticket;
  final BuildContext context;

  const HistoryListItem({
    super.key,
    required this.ticket,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final checkInDate =
        "${ticket.checkInTime.day.toString().padLeft(2, '0')}/${ticket.checkInTime.month.toString().padLeft(2, '0')}/${ticket.checkInTime.year}";
    final checkInTimeStr = TimeOfDay.fromDateTime(
      ticket.checkInTime,
    ).format(context);

    String checkOutDisplay = "Pending";
    if (ticket.checkOutTime != null) {
      final coDate =
          "${ticket.checkOutTime!.day.toString().padLeft(2, '0')}/${ticket.checkOutTime!.month.toString().padLeft(2, '0')}/${ticket.checkOutTime!.year}";
      final coTime = TimeOfDay.fromDateTime(
        ticket.checkOutTime!,
      ).format(context);
      checkOutDisplay = "$coDate $coTime";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: theme.colorScheme.surface,
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
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  ticket.amount != null
                      ? '₹${ticket.amount!.toStringAsFixed(2)}'
                      : 'N/A',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              "ID: ${ticket.id}",
              style: TextStyle(
                fontSize: 12.0,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-in',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      "$checkInDate $checkInTimeStr",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Check-out',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      checkOutDisplay,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
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
