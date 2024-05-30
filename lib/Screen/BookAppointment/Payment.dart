import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/BookAppointmentAPI.dart';
import 'package:v_doctor/API/PatientAPI/GetPaymentMethods.dart';
import 'package:v_doctor/Model/BookAppointmentModel.dart';
import 'package:v_doctor/Model/DiagnosisQuestionsModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/PaymentModel.dart';
import 'package:v_doctor/apikeys/apikeys.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  final String name;
  final String doctorId;
  final String fees;
  final Map<int, dynamic> questionData;
  final Map<int, String> textFieldData;
  final List<Questions> questions;
  final String symptomsText;
  final List<String> selectedReportIds;
  final String address;
  final DateTime selectedDate;
  final String selectedSlot;
  final String selectedDay;
  final String appointmentMode;

  const Payment({
    Key? key,
    required this.name,
    required this.doctorId,
    required this.appointmentMode,
    required this.fees,
    required this.questionData,
    required this.textFieldData,
    required this.questions,
    required this.symptomsText,
    required this.selectedReportIds,
    required this.address,
    required this.selectedDate,
    required this.selectedSlot,
    required this.selectedDay,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  SessionManager? sessionManager;
  UserData? userData;
  Dio dio = Dio();
  bool isLoading = false;
  String? errorMessage;
  PaymentModel? paymentModel;
  String? selectedPaymentMethod;
  bool showButton = false;
  BookAppointmentModel? bookAppointmentModel;
  late Map<String, dynamic> paymentIntent;
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getPayment();
  }

  void getPayment() async {
    userData = await sessionManager?.getUserInfo();
    if (userData != null) {
      fetchPayment();
    }
  }

  void fetchPayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      paymentModel = await GetPaymentAPIService().getPayment(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        doctorId: widget.doctorId,
      );

      setState(() {
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

  void getBookAppointment() async {
    userData = await sessionManager?.getUserInfo();
    if (userData != null) {
      getData();
    }
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      String formattedSelectedDate =
          DateFormat("yyyy-MM-dd").format(widget.selectedDate);

      List<String> timeComponents = widget.selectedSlot.split("-");
      String startTimeString = timeComponents[0].trim();
      String endTimeString = timeComponents[1].trim();

      DateTime startTime = DateFormat("hh:mm a").parse(startTimeString);
      DateTime endTime = DateFormat("hh:mm a").parse(endTimeString);

      String formattedStartTime =
          DateFormat("${formattedSelectedDate}THH:mm:ss").format(startTime);
      String formattedEndTime =
          DateFormat("${formattedSelectedDate}THH:mm:ss").format(endTime);

      List<Map<String, String>> preDiagnosisQuestions = [];

      for (int i = 0; i < widget.questions.length; i++) {
        preDiagnosisQuestions.add({
          'question': widget.questions[i].question ?? '',
          'answer': widget.questionData.containsKey(i)
              ? (widget.questionData[i] == true ? 'Yes' : 'No')
              : widget.textFieldData[i] ?? '',
        });
      }

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < preDiagnosisQuestions.length; i++)
            ListTile(
              title: Text(
                'Q-${i + 1}. ${preDiagnosisQuestions[i]['question']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("Ans. ${preDiagnosisQuestions[i]['answer']}"),
            ),
        ],
      );

      bookAppointmentModel =
          await BookAppointmentAPIService().getBookAppointment(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        doctorId: widget.doctorId,
        appointmentMode: widget.appointmentMode,
        time: widget.selectedSlot,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        date: DateFormat("yyyy-MM-dd").format(widget.selectedDate),
        appointmentType: 'new',
        comment: widget.symptomsText,
        paymentMode: 'offline',
        preDiagnosisQuestions: preDiagnosisQuestions,
        testReports: widget.selectedReportIds,
      );
      setState(() {
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

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(widget.fees, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                billingDetails: BillingDetails(name: "Bhautik",
                email: "bhautik@yopmail.com",
                phone: "+919033278089",
                address: Address(city: "Ahmedabad", country: "India", line1: "211 ashirwad paras", line2: "prahladnagar", postalCode: "380015", state: "Gujarat")),
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.dark,
            merchantDisplayName: 'Test',
          ))
          .then((value) {});

      displayPaymentSheet();
    } catch (e) {
      if (kDebugMode) {
        print("exception $e");
      }
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent == null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };
      var SECRET_KEY = APIKey.STRIPE_SECRET;
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
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
                        "Payment Method",
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: height * 0.90,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      paymentModel != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var method
                                    in paymentModel!.data!.adminMethods!)
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: 20,
                                    ),
                                    padding: EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(style: BorderStyle.solid),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: RadioListTile<String>(
                                            title: Text(
                                              method.name ?? '',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            value: method.name!,
                                            groupValue: selectedPaymentMethod,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedPaymentMethod = value!;
                                                showButton = true;
                                              });
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          indent: 20,
                                        ),
                                        if (showButton &&
                                            selectedPaymentMethod ==
                                                method.name)
                                          ElevatedButton(
                                            onPressed: () {
                                              if (method.type == 0) {
                                                makePayment();
                                              } else {
                                                print(
                                                    'Payment method type is not supported for direct payment');
                                              }
                                            },
                                            child: Text('Pay Now'),
                                          ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                if (widget.appointmentMode == 'offline')
                                  Container(
                                    padding: EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            style: BorderStyle.solid)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        RadioListTile(
                                          title: Text('Pay in Clinic',
                                              style: TextStyle(fontSize: 24)),
                                          value: 'Pay in Clinic',
                                          groupValue: selectedPaymentMethod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedPaymentMethod = value;
                                              showButton = true;
                                            });
                                          },
                                        ),
                                        Divider(
                                          thickness: 2,
                                          indent: 20,
                                        ),
                                        if (showButton &&
                                            selectedPaymentMethod ==
                                                'Pay in Clinic')
                                          ElevatedButton(
                                            onPressed: isLoading
                                                ? null
                                                : () {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    getBookAppointment();
                                                  },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                if (isLoading)
                                                  CircularProgressIndicator(),
                                                Text('Pay Now'),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                              ],
                            )
                          : Center(
                              child: Text(errorMessage ?? 'No data available'),
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
