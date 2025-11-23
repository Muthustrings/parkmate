import 'package:flutter/material.dart';
import 'package:parkmate/models/ticket.dart';

class ParkingProvider with ChangeNotifier {
  final List<Ticket> _activeTickets = [];
  final List<Ticket> _historyTickets = [];

  List<Ticket> get activeTickets => _activeTickets;
  List<Ticket> get historyTickets => _historyTickets;

  void addTicket(Ticket ticket) {
    _activeTickets.add(ticket);
    notifyListeners();
  }

  void checkOutTicket(String ticketId, DateTime checkOutTime) {
    final index = _activeTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final ticket = _activeTickets[index];
      ticket.checkOutTime = checkOutTime;
      _activeTickets.removeAt(index);
      _historyTickets.add(ticket);
      notifyListeners();
    }
  }
}
