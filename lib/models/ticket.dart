class Ticket {
  final String id;
  final String vehicleNumber;
  final String vehicleType;
  final String? phoneNumber;
  final String? slotNumber;
  final DateTime checkInTime;
  DateTime? checkOutTime;

  Ticket({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    this.phoneNumber,
    this.slotNumber,
    required this.checkInTime,
    this.checkOutTime,
  });
}
