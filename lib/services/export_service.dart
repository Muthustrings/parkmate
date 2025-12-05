import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:parkmate/models/ticket.dart';
import 'package:parkmate/screens/report_list_page.dart';

class ExportService {
  static final ExportService instance = ExportService._();
  ExportService._();

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy h:mm a');

  // --- Ticket Export ---

  Future<bool> exportTicketsPdf(
    List<Ticket> tickets,
    String title,
    ReportType reportType,
  ) async {
    try {
      final doc = pw.Document();

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            List<String> headers = ['Vehicle No', 'Type', 'Check-In'];
            if (reportType != ReportType.checkIn) {
              headers.addAll(['Check-Out', 'Amount']);
            }

            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  headers,
                  ...tickets.map((ticket) {
                    List<String> row = [
                      ticket.vehicleNumber,
                      ticket.vehicleType,
                      _dateFormat.format(ticket.checkInTime),
                    ];
                    if (reportType != ReportType.checkIn) {
                      row.addAll([
                        ticket.checkOutTime != null
                            ? _dateFormat.format(ticket.checkOutTime!)
                            : 'Pending',
                        ticket.amount != null
                            ? 'Rs. ${ticket.amount!.toStringAsFixed(2)}'
                            : '-',
                      ]);
                    }
                    return row;
                  }),
                ],
              ),
            ];
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await doc.save(),
        filename: '${title.replaceAll(' ', '_')}.pdf',
      );
      return true;
    } catch (e) {
      debugPrint('Error exporting PDF: $e');
      return false;
    }
  }

  Future<bool> exportTicketsCsv(
    List<Ticket> tickets,
    String title,
    ReportType reportType,
  ) async {
    try {
      List<List<dynamic>> rows = [];

      // Header
      List<String> headers = [
        'Vehicle Number',
        'Vehicle Type',
        'Phone Number',
        'Slot Number',
        'Check-In Time',
      ];

      if (reportType != ReportType.checkIn) {
        headers.addAll(['Check-Out Time', 'Amount']);
      }

      rows.add(headers);

      // Data
      for (var ticket in tickets) {
        List<dynamic> row = [
          ticket.vehicleNumber,
          ticket.vehicleType,
          ticket.phoneNumber ?? '',
          ticket.slotNumber ?? '',
          _dateFormat.format(ticket.checkInTime),
        ];

        if (reportType != ReportType.checkIn) {
          row.addAll([
            ticket.checkOutTime != null
                ? _dateFormat.format(ticket.checkOutTime!)
                : 'Pending',
            ticket.amount != null ? ticket.amount!.toStringAsFixed(2) : '',
          ]);
        }

        rows.add(row);
      }

      String csv = const ListToCsvConverter().convert(rows);

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${title.replaceAll(' ', '_')}.csv');
      await file.writeAsString(csv);
      await Share.shareXFiles([XFile(file.path)], text: 'Here is the $title');
      return true;
    } catch (e) {
      debugPrint('Error exporting CSV: $e');
      return false;
    }
  }

  // --- Income Export ---

  Future<bool> exportIncomePdf(Map<String, double> data) async {
    try {
      final doc = pw.Document();

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'Income Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Generated on: ${_dateFormat.format(DateTime.now())}'),
                pw.SizedBox(height: 30),
                ...data.entries.map((entry) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 10),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          entry.key,
                          style: const pw.TextStyle(fontSize: 18),
                        ),
                        pw.Text(
                          'Rs. ${entry.value.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Income',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Rs. ${data['Total Income']?.toStringAsFixed(2) ?? '0.00'}',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await doc.save(),
        filename: 'Income_Report.pdf',
      );
      return true;
    } catch (e) {
      debugPrint('Error exporting Income PDF: $e');
      return false;
    }
  }

  Future<bool> exportIncomeCsv(Map<String, double> data) async {
    try {
      List<List<dynamic>> rows = [];

      rows.add(['Report Type', 'Amount']);

      for (var entry in data.entries) {
        rows.add([entry.key, entry.value]);
      }

      String csv = const ListToCsvConverter().convert(rows);

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/Income_Report.csv');
      await file.writeAsString(csv);
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Here is the Income Report');
      return true;
    } catch (e) {
      debugPrint('Error exporting Income CSV: $e');
      return false;
    }
  }
}
