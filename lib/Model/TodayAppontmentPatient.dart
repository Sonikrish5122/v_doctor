class TodayAppointmentPatientModel {
  String? message;
  List<Data>? data;
  bool? success;

  TodayAppointmentPatientModel({this.message, this.data, this.success});

  TodayAppointmentPatientModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  String? appointmentDate;
  String? time;
  String? startTime;
  String? endTime;
  String? appointmentMode;
  String? appointmentType;
  bool? isCompleted;
  bool? isConfirmed;
  bool? isCanceled;
  DoctorDetails? doctorDetails;
  String? appointmentId;
  String? paymentStatus;
  String? paymentMode;

  Data(
      {this.appointmentDate,
        this.time,
        this.startTime,
        this.endTime,
        this.appointmentMode,
        this.appointmentType,
        this.isCompleted,
        this.isConfirmed,
        this.isCanceled,
        this.doctorDetails,
        this.appointmentId,
        this.paymentStatus,
        this.paymentMode});

  Data.fromJson(Map<String, dynamic> json) {
    appointmentDate = json['appointmentDate'];
    time = json['time'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    appointmentMode = json['appointmentMode'];
    appointmentType = json['appointmentType'];
    isCompleted = json['is_completed'];
    isConfirmed = json['is_confirmed'];
    isCanceled = json['is_canceled'];
    doctorDetails = json['doctorDetails'] != null
        ? new DoctorDetails.fromJson(json['doctorDetails'])
        : null;
    appointmentId = json['appointment_id'];
    paymentStatus = json['paymentStatus'];
    paymentMode = json['paymentMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentDate'] = this.appointmentDate;
    data['time'] = this.time;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['appointmentMode'] = this.appointmentMode;
    data['appointmentType'] = this.appointmentType;
    data['is_completed'] = this.isCompleted;
    data['is_confirmed'] = this.isConfirmed;
    data['is_canceled'] = this.isCanceled;
    if (this.doctorDetails != null) {
      data['doctorDetails'] = this.doctorDetails!.toJson();
    }
    data['appointment_id'] = this.appointmentId;
    data['paymentStatus'] = this.paymentStatus;
    data['paymentMode'] = this.paymentMode;
    return data;
  }
}

class DoctorDetails {
  String? name;
  String? mobileNo;
  String? email;
  String? profilePic;
  int? experience;

  DoctorDetails(
      {this.name, this.mobileNo, this.email, this.profilePic, this.experience});

  DoctorDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobile_no'];
    email = json['email'];
    profilePic = json['profile_pic'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile_no'] = this.mobileNo;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['experience'] = this.experience;
    return data;
  }
}