class Therapy {
  final String therapyId;
  final String therapyName;
  final String therapyIcon;
  final String cost;

  Therapy({
    required this.therapyId,
    required this.therapyName,
    required this.therapyIcon,
    required this.cost,
  });

  factory Therapy.fromJson(Map<String, dynamic> json) {
    return Therapy(
      therapyId: json['therapy_id'],
      therapyName: json['therapy_name'],
      therapyIcon: 'https://askmyg.com/${json['therapy_icon']}',
      cost: json['cost'],
    );
  }
}
