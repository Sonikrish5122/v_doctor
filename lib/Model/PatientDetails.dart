class PatientDetails {
  final String user_id;
  final String user_type;

  PatientDetails({
    required this.user_id,
    required this.user_type,
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      user_id: json['user-id'],
      user_type: json['user-type'],
    );
  }
}
