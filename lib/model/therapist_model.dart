class Therapist {
  final String id;
  final String name;
  final String number;
  final String image;
  final String certificate;
  final String description;
  final String weekOff;
  final String multipleBranch;
  final List<Map<String, String>> timeSchedule;

  Therapist({
    required this.id,
    required this.name,
    required this.number,
    required this.image,
    required this.certificate,
    required this.description,
    required this.weekOff,
    required this.multipleBranch,
    required this.timeSchedule,
  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      id: json['prag_therapist_id'] ?? '',
      name: json['therapist_name'] ?? '',
      number: json['therapist_number'] ?? '',
      image: json['therapist_img'] ?? '',
      certificate: json['therapist_certificate'] ?? '',
      description: json['therapist_description'] ?? '',
      weekOff: json['week_off'] ?? '',
      multipleBranch: json['multiple_branch'] ?? '',
      timeSchedule: List<Map<String, String>>.from(json['timeschedule']?.map((x) => Map<String, String>.from(x)) ?? []),
    );
  }
}
