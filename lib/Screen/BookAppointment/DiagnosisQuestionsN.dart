import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/DiagnosisQuestionsAPI.dart';
import 'package:v_doctor/Model/DiagnosisQuestionsModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/BookAppointment/QuestionsItemWidget.dart';
import 'package:v_doctor/Screen/BookAppointment/Upload_Reports.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class DiagnosisQuestionsN extends StatefulWidget {
  final String name;
  final String doctor_id;
  final String fees;
  final String address;
  final DateTime selectedDate;
  final String selectedSlot;
  final String selectedDay;
  final String appointmentMode;

  const DiagnosisQuestionsN({
    Key? key,
    required this.name,
    required this.doctor_id,
    required this.fees,
    required this.address,
    required this.selectedDate,
    required this.selectedSlot,
    required this.selectedDay,
    required this.appointmentMode,
  }) : super(key: key);

  @override
  State<DiagnosisQuestionsN> createState() => _DiagnosisQuestionsNState();
}

class _DiagnosisQuestionsNState extends State<DiagnosisQuestionsN> {
  bool isExpanded = false;
  bool isAddressExpanded = false;
  SessionManager? sessionManager;
  UserData? userData;
  Dio dio = Dio();
  bool isLoading = false;
  String? errorMessage;
  DiagnosisQuestionsModel? diagnosisQuestions;
  Map<int, dynamic> selectedOptionData = {};
  Map<int, String> textFieldData = {};
  String symptomsText = '';

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getDiagnosisQuestions();
  }

  void getDiagnosisQuestions() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchDiagnosisQuestions();
      }
    });
  }

  void fetchDiagnosisQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      DiagnosisQuestionsModel diagnosisQuestionsModel =
          await DiagnosisQuestionsAPIService().getDiagnosisQuestions(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        doctorId: '${widget.doctor_id}',
      );

      setState(() {
        diagnosisQuestions = diagnosisQuestionsModel;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again later.';
        isLoading = false;
        print(errorMessage);
      });
      print(e);
    }
  }

  void handleTextFieldChanged(int index, String value) {
    textFieldData[index] = value;
  }

  void handleRadioButtonSelected(int index, bool? value) {
    selectedOptionData[index] = value;
  }

  void handleSymptomsTextChanged(String value) {
    setState(() {
      symptomsText = value;
    });
  }

  void navigateToUploadReports() {
    if (textFieldData.isEmpty && selectedOptionData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Get.to(
        UploadReports(
          name: widget.name,
          doctor_id: widget.doctor_id,
          fees: widget.fees,
          selectedDate: widget.selectedDate,
          selectedSlot: widget.selectedSlot,
          selectedDay: DateFormat('EEEE').format(widget.selectedDate),
          questionData: selectedOptionData,
          textFieldData: textFieldData,
          symptomsText: symptomsText,
          questions: diagnosisQuestions!.data!
              .map((data) => data.questions!)
              .expand((questions) => questions)
              .toList(),
          address: widget.address,
          appointmentMode: widget.appointmentMode,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(

              children: [
                Container(

                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryColor,

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: ColorConstants.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Questions",
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.04),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                              heightFactor: 22,
                            )
                          : diagnosisQuestions != null
                              ? SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          QuestionItemWidget(
                                            questions: diagnosisQuestions!.data!
                                                .map((data) => data.questions!)
                                                .expand(
                                                    (questions) => questions)
                                                .toList(),
                                            onTextFieldChanged:
                                                handleTextFieldChanged,
                                            onRadioButtonSelected:
                                                handleRadioButtonSelected,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Symptoms:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Write symptoms (Option)",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: 4,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Add Symptoms or what are you feeling',
                                                    alignLabelWithHint: true,
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged:
                                                      handleSymptomsTextChanged,
                                                )
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(width: 1),
                                          color: Colors.blue,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: navigateToUploadReports,
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              Text(
                                                'Next',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.045,
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'No diagnosis questions found',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (errorMessage != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
