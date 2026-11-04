class PaymentModel {
  final int? id;
  final int bookingId;
  final String method; // transfer | qris | silmapay | cash
  final int amount;
  final String status; // unpaid | paid | refunded | failed
  final String? referenceNo;
  final String? paidAt;
  final String? createdAt;

  PaymentModel({
    this.id,
    required this.bookingId,
    required this.method,
    required this.amount,
    this.status = 'unpaid',
    this.referenceNo,
    this.paidAt,
    this.createdAt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      bookingId: map['booking_id'] ?? 0,
      method: map['method'] ?? 'transfer',
      amount: map['amount'] ?? 0,
      status: map['status'] ?? 'unpaid',
      referenceNo: map['reference_no'],
      paidAt: map['paid_at'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'booking_id': bookingId,
      'method': method,
      'amount': amount,
      'status': status,
      'reference_no': referenceNo,
      'paid_at': paidAt,
      'created_at': createdAt,
    };
  }

  bool get isPaid => status == 'paid';

  @override
  String toString() =>
      'PaymentModel(id: $id, booking: $bookingId, method: $method, amount: $amount, status: $status)';
}
