class Therapist {
  final String id;
  final String name;
  final String email;
  final String number;
  final String image;
  final String certificate;
  final String specialization;
  final String description;
  final String cost;

  Therapist({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.image,
    required this.certificate,
    required this.specialization,
    required this.description,
    required this.cost,
  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      id: json['prag_therapist_id'] ?? '',
      name: json['therapist_name'] ?? '',
      email: json['therapist_email'] ?? '',
      number: json['therapist_number'] ?? '',
      image: json['therapist_img'] ?? '',
      certificate: json['therapist_certificate'] ?? '',
      specialization: json['therapist_speclist'] ?? '',
      description: json['therapist_description'] ?? '',
      cost: json['therapist_cost'] ?? '',
    );
  }
}
