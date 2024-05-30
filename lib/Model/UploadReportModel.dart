class UploadReportModel {
  String? message;
  List<Data>? data;
  bool? success;

  UploadReportModel({this.message, this.data, this.success});

  UploadReportModel.fromJson(Map<String, dynamic> json) {
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
  String? patientName;
  String? patientId;
  Report? report;
  String? reportDate;
  String? reportId;

  Data(
      {this.patientName,
        this.patientId,
        this.report,
        this.reportDate,
        this.reportId});

  Data.fromJson(Map<String, dynamic> json) {
    patientName = json['patientName'];
    patientId = json['patient_id'];
    report =
    json['report'] != null ? new Report.fromJson(json['report']) : null;
    reportDate = json['reportDate'];
    reportId = json['report_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientName'] = this.patientName;
    data['patient_id'] = this.patientId;
    if (this.report != null) {
      data['report'] = this.report!.toJson();
    }
    data['reportDate'] = this.reportDate;
    data['report_id'] = this.reportId;
    return data;
  }
}

class Report {
  String? name;
  String? url;

  Report({this.name, this.url});

  Report.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}