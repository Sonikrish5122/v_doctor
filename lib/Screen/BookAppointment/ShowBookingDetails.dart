import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/Model/DiagnosisQuestionsModel.dart';
import 'package:v_doctor/Screen/BookAppointment/Payment.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class ShowBookingDetails extends StatefulWidget {
  final String name;
  final String doctor_id;
  final String fees;
  final Map<int, dynamic> questionData;
  final Map<int, String> textFieldData;
  final List<Questions> questions;
  final String symptomsText;
  final List<String> selectedReportName, selectedReportId;
  final String address;
  final DateTime selectedDate;
  final String selectedSlot;
  final String selectedDay;
  final String appointmentMode;

  const ShowBookingDetails({
    Key? key,
    required this.name,
    required this.doctor_id,
    required this.fees,
    required this.questionData,
    required this.textFieldData,
    required this.questions,
    required this.symptomsText,
    required this.selectedReportName,
    required this.address,
    required this.selectedDate,
    required this.selectedSlot,
    required this.selectedDay,
    required this.appointmentMode,
    required this.selectedReportId,
  }) : super(key: key);

  @override
  State<ShowBookingDetails> createState() => _ShowBookingDetailsState();
}

class _ShowBookingDetailsState extends State<ShowBookingDetails> {
  bool isLoading = false;

  Widget _buildQuestionList(List<Questions> questions,
      Map<int, dynamic> questionData, Map<int, String> textFieldData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < questions.length; i++)
          ListTile(
            title: Text(
              'Q-${i + 1}. ${questions[i].question}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: questionData.containsKey(i)
                ? Text(
                    "Ans.${questionData[i] == true ? 'Yes' : 'No'}",
                    style: TextStyle(
                        color: ColorConstants.LightGray, fontSize: 14),
                  )
                : Text(
                    "Ans.${textFieldData[i] ?? ''}",
                    style: TextStyle(
                        color: ColorConstants.LightGray, fontSize: 14),
                  ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height * 0.08,
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
                        "Booking Details",
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
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          appointment_icon,
                                          width: 30,
                                          height: 28,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Appointment Details",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    Divider(),
                                    Text(
                                      "Doctor Details :",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.LightGray),
                                    ),
                                    Text(
                                      "${widget.name} ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: ColorConstants.LightGray),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Patient Name :",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorConstants.LightGray,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    FutureBuilder<String?>(
                                      future: ProfileManager().getName(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            '${snapshot.data}',
                                            style: TextStyle(
                                              color: ColorConstants.LightGray,
                                              fontSize: 16,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            'Hi, Jess', // Default name
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.04,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Address: ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorConstants.LightGray,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${widget.address} ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: ColorConstants.LightGray),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Date & Time",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorConstants.LightGray,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${widget.selectedDay} ,${DateFormat('dd-MMMM-yyyy').format(widget.selectedDate)}, ${widget.selectedSlot}  ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: ColorConstants.LightGray),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          questions_icon,
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Questions",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    _buildQuestionList(
                                        widget.questions,
                                        widget.questionData,
                                        widget.textFieldData),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Symptoms :",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            widget.symptomsText,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            medical_report_icon,
                                            width: 30,
                                            height: 30,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Selected Report",
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: widget.selectedReportName
                                            .map((reportId) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 3),
                                            child: Text(
                                              reportId,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          secure_payment,
                                          width: 30,
                                          height: 28,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Payment Details",
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text("Service Fees",
                                            style: TextStyle(
                                              fontSize: 20,
                                            )),
                                        Spacer(),
                                        Text("${widget.fees} \$",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text("Any Extra Charges",
                                            style: TextStyle(fontSize: 20)),
                                        Spacer(),
                                        Text("0 \$",
                                            style: TextStyle(fontSize: 20))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Total Amount",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text("${widget.fees} \$",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(Payment(
                                        name: widget.name,
                                        doctorId: widget.doctor_id,
                                        fees: widget.fees,
                                        questionData: widget.questionData,
                                        textFieldData: widget.textFieldData,
                                        questions: widget.questions,
                                        symptomsText: widget.symptomsText,
                                        selectedReportIds:
                                            widget.selectedReportId,
                                        address: widget.address,
                                        selectedDate: widget.selectedDate,
                                        selectedSlot: widget.selectedSlot,
                                        selectedDay: DateFormat('EEEE')
                                            .format(widget.selectedDate),
                                        appointmentMode:
                                            widget.appointmentMode));
                                  },
                                  child: Text("Payment")),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
