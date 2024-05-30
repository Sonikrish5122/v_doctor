class AvailabilityModel {
  String? message;
  bool? success;
  List<Data>? data;

  AvailabilityModel({this.message, this.success, this.data});

  AvailabilityModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? doctorId;
  int? bufferTime;
  int? slotDuration;
  List<Timings>? timings;

  Data({this.doctorId, this.bufferTime, this.slotDuration, this.timings});

  Data.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    bufferTime = json['bufferTime'];
    slotDuration = json['slotDuration'];
    if (json['timings'] != null) {
      timings = <Timings>[];
      json['timings'].forEach((v) {
        timings!.add(new Timings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    data['bufferTime'] = this.bufferTime;
    data['slotDuration'] = this.slotDuration;
    if (this.timings != null) {
      data['timings'] = this.timings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timings {
  String? day;
  bool? isAvailable;
  List<String>? availability;
  String? startTime;
  String? endTime;
  List<String>? timeSlots;

  Timings(
      {this.day,
        this.isAvailable,
        this.availability,
        this.startTime,
        this.endTime,
        this.timeSlots});

  Timings.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    isAvailable = json['isAvailable'];
    availability = json['availability'].cast<String>();
    startTime = json['startTime'];
    endTime = json['endTime'];
    timeSlots = json['timeSlots'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['isAvailable'] = this.isAvailable;
    data['availability'] = this.availability;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['timeSlots'] = this.timeSlots;
    return data;
  }
}