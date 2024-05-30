import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/API/PatientAPI/DiagnosisQuestionsAPI.dart';
import 'package:v_doctor/Model/DiagnosisQuestionsModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class DiagnosisQuestions extends StatefulWidget {
  final String name;
  final String doctor_id;
  final String fees;

  const DiagnosisQuestions({
    Key? key,
    required this.name,
    required this.doctor_id,
    required this.fees,
  }) : super(key: key);

  @override
  State<DiagnosisQuestions> createState() => _DiagnosisQuestionsState();
}

class _DiagnosisQuestionsState extends State<DiagnosisQuestions> {
  bool isExpanded = false;
  bool isAddressExpanded = false;
  SessionManager? sessionManager;
  UserData? userData;
  Dio dio = Dio();
  bool isLoading = false;
  String? errorMessage;
  DiagnosisQuestionsModel? diagnosisQuestions;
  bool? answer;

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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: height * 0.11,
                  padding: EdgeInsets.all(10.0),
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
                            widget.name,
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
                Container(
                  height: height * 0.90,
                  width: double.infinity,
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
                          ? Center(child: CircularProgressIndicator())
                          : diagnosisQuestions != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var data in diagnosisQuestions!.data!)
                                      SingleChildScrollView(
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Answer some Diagnosis Questions:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                for (var question
                                                    in data.questions!)
                                                  question.inputType == 'text'
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                question.question ??
                                                                    "",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextField(
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.black),
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                  )),
                                                            ],
                                                          ),
                                                        )
                                                      : question.inputType ==
                                                              'radio'
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                    question.question ??
                                                                        "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Radio(
                                                                      value:
                                                                          true,
                                                                      groupValue:
                                                                          answer,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          answer =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                    Text("Yes"),
                                                                    Radio(
                                                                      value:
                                                                          false,
                                                                      groupValue:
                                                                          answer,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          answer =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                    Text("No"),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                  'No diagnosis questions found',
                                  style: TextStyle(color: Colors.red),
                                )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1),
                color: Colors.blue,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Get.to(UploadReports(
                  //   name: widget.name,
                  //   doctor_id: widget.doctor_id,
                  //   fees: (widget.fees).toString(),
                  // ));
                },
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
