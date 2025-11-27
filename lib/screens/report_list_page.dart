import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmate/models/ticket.dart';
import 'package:parkmate/services/database_helper.dart';
import 'package:parkmate/services/export_service.dart';
import 'package:parkmate/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReportType { checkIn, checkOut, allTickets }

class ReportListPage extends StatefulWidget {
  final ReportType reportType;

  const ReportListPage({super.key, required this.reportType});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'Vehicle Number';

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
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

      List<Ticket> tickets = [];
      switch (widget.reportType) {
        case ReportType.checkIn:
          tickets = await DatabaseHelper.instance.getAllTickets(userPhone);
          break;
        case ReportType.checkOut:
          tickets = await DatabaseHelper.instance.getHistoryTickets(userPhone);
          break;
        case ReportType.allTickets:
          tickets = await DatabaseHelper.instance.getAllTickets(userPhone);
          break;
      }

      if (mounted) {
        setState(() {
          _tickets = tickets;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading tickets: $e');
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

  String get _title {
    switch (widget.reportType) {
      case ReportType.checkIn:
        return 'Check-In Report';
      case ReportType.checkOut:
        return 'Check-Out Report';
      case ReportType.allTickets:
        return 'All Tickets Report';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter tickets based on search query
    List<Ticket> filteredTickets = _tickets.where((ticket) {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) return true;

      if (_filterType == 'Vehicle Number') {
        return ticket.vehicleNumber.toLowerCase().contains(query);
      } else {
        return ticket.phoneNumber?.toLowerCase().contains(query) ?? false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: theme.colorScheme.surface,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () async {
              if (filteredTickets.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Generating PDF...')),
                );
                final success = await ExportService.instance.exportTicketsPdf(
                  filteredTickets,
                  _title,
                  widget.reportType,
                );
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
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: 'Export Excel',
            onPressed: () async {
              if (filteredTickets.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Generating Excel...')),
                );
                final success = await ExportService.instance.exportTicketsExcel(
                  filteredTickets,
                  _title,
                  widget.reportType,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Excel exported successfully'
                            : 'Failed to export Excel',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTickets.isEmpty
                ? Center(
                    child: Text(
                      'No records found',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(
                          color: theme.colorScheme.outlineVariant,
                          width: 1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        columnWidths: _getColumnWidths(),
                        children: [
                          _buildHeaderRow(theme),
                          ..._buildDataRows(theme, filteredTickets),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths() {
    final widths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(40), // S.No
      1: const FlexColumnWidth(2), // Vehicle No
      2: const FlexColumnWidth(2), // Phone No
      3: const FlexColumnWidth(2), // Check-In
    };

    if (widget.reportType != ReportType.checkIn) {
      widths[4] = const FlexColumnWidth(2); // Check-Out
      widths[5] = const FlexColumnWidth(1.5); // Amount
    }

    return widths;
  }

  TableRow _buildHeaderRow(ThemeData theme) {
    final List<Widget> cells = [
      _buildHeaderCell('S.No', theme),
      _buildHeaderCell('Vehicle', theme),
      _buildHeaderCell('Phone', theme),
      _buildHeaderCell('In', theme),
    ];

    if (widget.reportType != ReportType.checkIn) {
      cells.add(_buildHeaderCell('Out', theme));
      cells.add(_buildHeaderCell('Amt', theme));
    }

    return TableRow(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      children: cells,
    );
  }

  Widget _buildHeaderCell(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<TableRow> _buildDataRows(ThemeData theme, List<Ticket> tickets) {
    final dateFormat = DateFormat('dd/MM/yy h:mm a');
    return List<TableRow>.generate(tickets.length, (index) {
      final ticket = tickets[index];
      final List<Widget> cells = [
        _buildDataCell('${index + 1}'),
        _buildDataCell(ticket.vehicleNumber, isBold: true),
        _buildDataCell(ticket.phoneNumber ?? '-'),
        _buildDataCell(dateFormat.format(ticket.checkInTime)),
      ];

      if (widget.reportType != ReportType.checkIn) {
        cells.add(
          _buildDataCell(
            ticket.checkOutTime != null
                ? dateFormat.format(ticket.checkOutTime!)
                : 'Pending',
          ),
        );
        cells.add(
          _buildDataCell(
            ticket.amount != null
                ? '₹${ticket.amount!.toStringAsFixed(0)}'
                : '-',
            color: theme.colorScheme.primary,
            isBold: true,
          ),
        );
      }

      return TableRow(children: cells);
    });
  }

  Widget _buildDataCell(String text, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
