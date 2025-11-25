import 'package:flutter/material.dart';
import 'package:parkmate/models/ticket.dart';
import 'package:parkmate/services/database_helper.dart';

class ParkingProvider with ChangeNotifier {
  List<Ticket> _activeTickets = [];
  List<Ticket> _historyTickets = [];

  List<Ticket> get activeTickets => _activeTickets;
  List<Ticket> get historyTickets => _historyTickets;

  ParkingProvider() {
    _loadActiveTickets();
    _loadHistoryTickets();
  }

  Future<void> _loadActiveTickets() async {
    _activeTickets = await DatabaseHelper.instance.getActiveTickets();
    notifyListeners();
  }

  Future<void> _loadHistoryTickets() async {
    _historyTickets = await DatabaseHelper.instance.getHistoryTickets();
    notifyListeners();
  }

  Future<void> addTicket(Ticket ticket) async {
    await DatabaseHelper.instance.createTicket(ticket);
    _activeTickets.add(ticket);
    notifyListeners();
  }

  Future<void> checkOutTicket(
    String ticketId,
    DateTime checkOutTime,
    double amount,
  ) async {
    final index = _activeTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final oldTicket = _activeTickets[index];
      final newTicket = Ticket(
        id: oldTicket.id,
        vehicleNumber: oldTicket.vehicleNumber,
        vehicleType: oldTicket.vehicleType,
        phoneNumber: oldTicket.phoneNumber,
        slotNumber: oldTicket.slotNumber,
        checkInTime: oldTicket.checkInTime,
        checkOutTime: checkOutTime,
        amount: amount,
      );

      await DatabaseHelper.instance.updateTicket(newTicket);

      // Reload from DB to ensure consistency and proper ordering
      await _loadActiveTickets();
      await _loadHistoryTickets();
    }
  }
}
