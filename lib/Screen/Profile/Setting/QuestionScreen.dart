import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/API/DoctorAPI/DiagnosisQuestionAPI.dart';
import 'package:v_doctor/Model/DoctorModel/DiagnosisQuestionModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool isLoading = false;
  SessionManager sessionManager = SessionManager();
  UserData? userData;
  DiagnosisQuestionModel? diagnosisQuestionModel;
  String? errorMessage;
  Dio dio = Dio();
  Data? clinicData;
  List<TextEditingController> textControllers = [];
  Map<String, String?> selectedAnswerTypes = {};

  @override
  void initState() {
    super.initState();
    getDiagnosisQuestion();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void getDiagnosisQuestion() async {
    await sessionManager.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        getDiagnosisQuestionInfo();
      }
    });
  }

  void getDiagnosisQuestionInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      diagnosisQuestionModel =
          await DiagnosisQuestionAPIService().getDiagnosisQuestion(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      if (diagnosisQuestionModel!.success == true &&
          diagnosisQuestionModel!.data != null &&
          diagnosisQuestionModel!.data!.isNotEmpty) {
        setState(() {
          isLoading = false;
          diagnosisQuestionModel!.data!.forEach((questionData) {
            questionData.questions!.forEach((question) {
              selectedAnswerTypes[question.question!] = question.ansType;
            });
          });
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again later.';
        isLoading = false;
      });
      print(e);
    }
  }

  void addNewQuestion() {
    setState(() {
      TextEditingController newController = TextEditingController();
      textControllers.add(newController);

      selectedAnswerTypes[newController.text] = 'descriptive';
    });
  }

  void updateQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      // Create a list of updated questions
      List<Map<String, dynamic>> updatedQuestions = [];
      diagnosisQuestionModel!.data!.forEach((questionData) {
        questionData.questions!.forEach((question) {
          updatedQuestions.add({
            'question': question.question,
            'ansType': selectedAnswerTypes[question.question],
          });
        });
      });

      // Add newly added questions to the updated list
      textControllers.forEach((controller) {
        String newQuestion = controller.text;
        if (newQuestion.isNotEmpty) {
          updatedQuestions.add({
            'question': newQuestion,
            'ansType': selectedAnswerTypes[newQuestion],
          });
        }
      });

      // Create the payload for the POST request
      Map<String, dynamic> payload = {
        'questions': updatedQuestions,
      };

      String endpoint =
          'doctor/add-or-update-diagnosis-questions/$userId?step=4';
      if (diagnosisQuestionModel == null ||
          diagnosisQuestionModel!.data!.isEmpty) {
        endpoint +=
            '&first_login=true'; // Append first_login=true if it's the first login
      } else {
        endpoint += '&first_login=false'; // Append first_login=false otherwise
      }

      Response response = await dio.post(
        API + endpoint,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': userType,
          },
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        showSnackbar('Questions updated successfully');
      } else {
        showSnackbar('Failed to update questions. Please try again later.');
      }
    } catch (e) {
      showSnackbar('Failed to update questions. Please try again later.');
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Diagnosis Question",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (diagnosisQuestionModel != null &&
                        diagnosisQuestionModel!.data != null)
                      for (var questionData in diagnosisQuestionModel!.data!)
                        for (var question in questionData.questions!)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: question.question ?? ''),
                                  onChanged: (value) {
                                    setState(() {
                                      question.question =
                                          value; // Update the question text
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Question Title",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'descriptive',
                                    groupValue:
                                        selectedAnswerTypes[question.question!],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswerTypes[
                                            question.question!] = value;
                                      });
                                    },
                                  ),
                                  Text('Descriptive'),
                                  SizedBox(width: 20),
                                  Radio<String>(
                                    value: 'boolean',
                                    groupValue:
                                        selectedAnswerTypes[question.question!],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswerTypes[
                                            question.question!] = value;
                                      });
                                    },
                                  ),
                                  Text('Yes/No'),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          questionData.questions!
                                              .remove(question);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                    for (var controller in textControllers)
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      labelText: "New Question",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'descriptive',
                                  groupValue:
                                      selectedAnswerTypes[controller.text],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswerTypes[controller.text] =
                                          value;
                                    });
                                  },
                                ),
                                Text('Descriptive'),
                                SizedBox(width: 20),
                                Radio<String>(
                                  value: 'boolean',
                                  groupValue:
                                      selectedAnswerTypes[controller.text],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswerTypes[controller.text] =
                                          value;
                                    });
                                  },
                                ),
                                Text('Yes/No'),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.red),
                                    borderRadius: BorderRadius.circular(
                                        5),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        textControllers.remove(controller);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          textControllers.add(TextEditingController());
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(
                              width:
                                  5),
                          Text("Add New Question",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0),
                            side: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                                style: BorderStyle
                                    .solid),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateQuestions();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
