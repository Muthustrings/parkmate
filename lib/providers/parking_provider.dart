import 'package:flutter/material.dart';
import 'package:parkmate/models/ticket.dart';
import 'package:parkmate/services/database_helper.dart';

class ParkingProvider with ChangeNotifier {
  List<Ticket> _activeTickets = [];
  List<Ticket> _historyTickets = [];
  String? _currentUserId;

  List<Ticket> get activeTickets => _activeTickets;
  List<Ticket> get historyTickets => _historyTickets;

  // Removed constructor loading, must be called explicitly with userId

  Future<void> loadTickets(String userId) async {
    _currentUserId = userId;
    await _loadActiveTickets(userId);
    await _loadHistoryTickets(userId);
  }

  Future<void> _loadActiveTickets(String userId) async {
    _activeTickets = await DatabaseHelper.instance.getActiveTickets(userId);
    notifyListeners();
  }

  Future<void> _loadHistoryTickets(String userId) async {
    _historyTickets = await DatabaseHelper.instance.getHistoryTickets(userId);
    notifyListeners();
  }

  Future<void> addTicket(Ticket ticket) async {
    if (_currentUserId == null) return; // Should not happen if logged in

    // Create a new ticket with the current user ID
    final ticketWithUser = Ticket(
      id: ticket.id,
      vehicleNumber: ticket.vehicleNumber,
      vehicleType: ticket.vehicleType,
      phoneNumber: ticket.phoneNumber,
      slotNumber: ticket.slotNumber,
      checkInTime: ticket.checkInTime,
      checkOutTime: ticket.checkOutTime,
      amount: ticket.amount,
      createdBy: _currentUserId,
    );

    await DatabaseHelper.instance.createTicket(ticketWithUser);
    _activeTickets.add(ticketWithUser);
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
        createdBy: oldTicket.createdBy, // Preserve creator
      );

      // Optimistic update: Update local state immediately
      _activeTickets.removeAt(index);
      _historyTickets.insert(0, newTicket);
      notifyListeners();

      try {
        await DatabaseHelper.instance.updateTicket(newTicket);

        // Reload from DB to ensure consistency and proper ordering
        if (_currentUserId != null) {
          // We can skip full reload if we trust our local update,
          // but reloading ensures we have the absolute latest state from DB
          // including any triggers or other changes (though none here).
          // To avoid UI flickering, we might want to skip this or do it silently.
          // For now, let's keep it but maybe catch errors here too.
          await _loadActiveTickets(_currentUserId!);
          await _loadHistoryTickets(_currentUserId!);
        }
      } catch (e) {
        debugPrint("Error checking out ticket: $e");
        // Revert optimistic update on failure
        _activeTickets.insert(index, oldTicket);
        _historyTickets.removeAt(0);
        notifyListeners();
        rethrow;
      }
    }
  }
}
