class BufferSlot {
  final String bufferBookingId;
  final DateTime bufferBookingDate;

  BufferSlot({required this.bufferBookingId, required this.bufferBookingDate});

  factory BufferSlot.fromJson(Map<String, dynamic> json) {
    return BufferSlot(
      bufferBookingId: json['bufferbooking_id'],
      bufferBookingDate: DateTime.parse(json['buffer_booking_date']),
    );
  }
}