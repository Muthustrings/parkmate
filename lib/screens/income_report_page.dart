import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/services/database_helper.dart';
import 'package:parkmate/services/export_service.dart';
import 'package:parkmate/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeReportPage extends StatefulWidget {
  const IncomeReportPage({super.key});

  @override
  State<IncomeReportPage> createState() => _IncomeReportPageState();
}

class _IncomeReportPageState extends State<IncomeReportPage> {
  double _totalIncome = 0.0;
  double _todayIncome = 0.0;
  double _weekIncome = 0.0;
  double _monthIncome = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _calculateIncome();
  }

  Future<void> _calculateIncome() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      var userPhone = userProvider.user?.phone;

      if (userPhone == null) {
        final prefs = await SharedPreferences.getInstance();
        userPhone = prefs.getString('userPhone');
      }

      if (userPhone == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final tickets = await DatabaseHelper.instance.getHistoryTickets(
        userPhone,
      );
      final now = DateTime.now();

      double total = 0.0;
      double today = 0.0;
      double week = 0.0;
      double month = 0.0;

      for (var ticket in tickets) {
        if (ticket.amount != null && ticket.checkOutTime != null) {
          double amount = ticket.amount!;
          total += amount;

          if (ticket.checkOutTime!.year == now.year &&
              ticket.checkOutTime!.month == now.month &&
              ticket.checkOutTime!.day == now.day) {
            today += amount;
          }

          final difference = now.difference(ticket.checkOutTime!);
          if (difference.inDays <= 7) {
            week += amount;
          }

          if (difference.inDays <= 30) {
            month += amount;
          }
        }
      }

      if (mounted) {
        setState(() {
          _totalIncome = total;
          _todayIncome = today;
          _weekIncome = week;
          _monthIncome = month;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error calculating income: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Income Report',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating PDF...')),
              );
              final success = await ExportService.instance.exportIncomePdf({
                'Total Income': _totalIncome,
                "Today's Income": _todayIncome,
                'This Week': _weekIncome,
                'This Month': _monthIncome,
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'PDF exported successfully'
                          : 'Failed to export PDF',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.description),
            tooltip: 'Export CSV',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating CSV...')),
              );
              final success = await ExportService.instance.exportIncomeCsv({
                'Total Income': _totalIncome,
                "Today's Income": _todayIncome,
                'This Week': _weekIncome,
                'This Month': _monthIncome,
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'CSV exported successfully'
                          : 'Failed to export CSV',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildIncomeCard(
                    context,
                    'Total Income',
                    _totalIncome,
                    theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIncomeCard(
                          context,
                          "Today's Income",
                          _todayIncome,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildIncomeCard(
                          context,
                          "This Week",
                          _weekIncome,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildIncomeCard(
                    context,
                    "This Month",
                    _monthIncome,
                    Colors.purple,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildIncomeCard(
    BuildContext context,
    String title,
    double amount,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: theme.colorScheme.surface,
      child: Padding(
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
              '₹${amount.toStringAsFixed(2)}',
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
}
