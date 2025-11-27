class Ticket {
  final String id;
  final String vehicleNumber;
  final String vehicleType;
  final String? phoneNumber;
  final String? slotNumber;
  final DateTime checkInTime;
  DateTime? checkOutTime;
  final double? amount;
  final String? createdBy;

  Ticket({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    this.phoneNumber,
    this.slotNumber,
    required this.checkInTime,
    this.checkOutTime,
    this.amount,
    this.createdBy,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'phoneNumber': phoneNumber,
      'slotNumber': slotNumber,
      'checkInTime': checkInTime.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'amount': amount,
      'createdBy': createdBy,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      vehicleNumber: map['vehicleNumber'],
      vehicleType: map['vehicleType'],
      phoneNumber: map['phoneNumber'],
      slotNumber: map['slotNumber'],
      checkInTime: DateTime.parse(map['checkInTime']),
      checkOutTime: map['checkOutTime'] != null
          ? DateTime.parse(map['checkOutTime'])
          : null,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
      createdBy: map['createdBy'],
    );
  }
}
