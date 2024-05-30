class TimeSlotsModel {
  String? message;
  List<Data>? data;
  bool? success;

  TimeSlotsModel({this.message, this.data, this.success});

  TimeSlotsModel.fromJson(Map<String, dynamic> json) {
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
  String? doctorId;
  List<String>? availability;
  List<AvailableTimings>? availableTimings;

  Data({this.doctorId, this.availability, this.availableTimings});

  Data.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    availability = json['availability'].cast<String>();
    if (json['availableTimings'] != null) {
      availableTimings = <AvailableTimings>[];
      json['availableTimings'].forEach((v) {
        availableTimings!.add(new AvailableTimings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['availability'] = this.availability;
    if (this.availableTimings != null) {
      data['availableTimings'] =
          this.availableTimings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableTimings {
  String? time;
  bool? isBooked;

  AvailableTimings({this.time, this.isBooked});

  AvailableTimings.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    isBooked = json['isBooked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['isBooked'] = this.isBooked;
    return data;
  }
}
