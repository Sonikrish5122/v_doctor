class DiagnosisQuestionsModel {
  String? message;
  bool? success;
  List<Data>? data;

  DiagnosisQuestionsModel({this.message, this.success, this.data});

  DiagnosisQuestionsModel.fromJson(Map<String, dynamic> json) {
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
  List<Questions>? questions;

  Data({this.doctorId, this.questions});

  Data.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? ansType;
  String? question;
  String? inputType;
  String? answer;

  Questions({this.ansType, this.question, this.inputType, this.answer});

  Questions.fromJson(Map<String, dynamic> json) {
    ansType = json['ansType'];
    question = json['question'];
    inputType = json['inputType'];
    answer = '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ansType'] = this.ansType;
    data['question'] = this.question;
    data['inputType'] = this.inputType;
    data['answer'] = this.answer;
    return data;
  }
}
