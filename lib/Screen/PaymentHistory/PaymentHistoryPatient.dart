import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:v_doctor/API/PatientAPI/PaymentHistoryPatientAPI.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/PaymentHistoryPatientModel.dart';
import 'package:v_doctor/Screen/Drawer/PatientDrawer.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class PaymentHistoryPatient extends StatefulWidget {
  const PaymentHistoryPatient({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryPatient> createState() => _PaymentHistoryPatientState();
}

class _PaymentHistoryPatientState extends State<PaymentHistoryPatient> {
  late double height;
  late double width;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SessionManager? sessionManager;
  late UserData? userData;
  late bool isLoading;
  late String? errorMessage;
  late PaymentHistoryPatientModel? paymentHistoryPatientModel;

  @override
  void initState() {
    super.initState();

    sessionManager = SessionManager();
    isLoading = false;
    errorMessage = null;

    getPaymentHistoryPatientInfo();
  }

  void getPaymentHistoryPatientInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchPaymentHistoryPatient();
      }
    });
  }

  void fetchPaymentHistoryPatient() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      paymentHistoryPatientModel = await PaymentHistoryPatientAPIService()
          .PaymentHistoryPatientInfo(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: PatientDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: ColorConstants.white),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Transactions History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                  padding: const EdgeInsets.all(20.0),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : paymentHistoryPatientModel != null &&
                      paymentHistoryPatientModel!.data != null
                      ? ListView.builder(
                    itemCount:
                    paymentHistoryPatientModel!.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Data paymentData =
                      paymentHistoryPatientModel!.data![index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              _formatPaymentDate(paymentData.paidOn),
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Amount: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),

                                    ),
                                    Text(
                                      '${paymentData.amount ?? 'N/A'} \$',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Payment Method: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${paymentData.paidUsing ?? 'N/A'}',
                                    ),
                                  ],
                                ),

                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Payment Status: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${paymentData.status ?? 'N/A'}',
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      errorMessage ?? 'No data available',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPaymentDate(String? paymentDate) {
    if (paymentDate == null) return 'N/A';
    DateTime parsedDate = DateTime.parse(paymentDate);
    return DateFormat('EEEE, dd MMMM yyyy, hh:mm a').format(parsedDate);
  }
}
