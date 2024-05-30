class UpdateStatusModel {
  final String message;
  final bool success;
  final List<StatusData> data;

  UpdateStatusModel({required this.message, required this.success, required this.data});

  factory UpdateStatusModel.fromJson(Map<String, dynamic> json) {
    return UpdateStatusModel(
      message: json['message'],
      success: json['success'],
      data: (json['data'] as List).map((item) => StatusData.fromJson(item)).toList(),
    );
  }
}

class StatusData {
  final String completionStatus;
  final String updatedBy;
  final String appointmentId;

  StatusData({required this.completionStatus, required this.updatedBy, required this.appointmentId});

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      completionStatus: json['completionStatus'],
      updatedBy: json['updatedBy'],
      appointmentId: json['appointment_id'],
    );
  }
}
