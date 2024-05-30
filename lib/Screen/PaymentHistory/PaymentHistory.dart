import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/DoctorAPI/PaymentHistoryAPI.dart';
import 'package:v_doctor/Model/DoctorModel/PaymentHistoryModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/Appointments/view_appointments_details.dart';
import 'package:v_doctor/Screen/Drawer/DoctorDrawer.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';
import 'package:v_doctor/utils/String.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  late double height;
  late double width;

  late GlobalKey<ScaffoldState> _globalKey;

  late SessionManager? sessionManager;
  late UserData? userData;
  late bool isLoading;
  late String? errorMessage;
  late PaymentHistoryModel? paymentHistoryModel;

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey<ScaffoldState>();
    sessionManager = SessionManager();
    isLoading = false;
    errorMessage = null;
    paymentHistoryModel = null;
    getPaymentHistoryInfo();
  }

  void getPaymentHistoryInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchPaymentHistory();
      }
    });
  }

  void fetchPaymentHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      paymentHistoryModel = await PaymentHistoryAPIService().PaymentHistoryInfo(
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
      key: _globalKey,
      backgroundColor: ColorConstants.primaryColor,
      drawer: DoctorDrawer(),
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
                        _globalKey.currentState?.openDrawer();
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
                      : paymentHistoryModel != null
                      ? ListView.builder(
                    itemCount: paymentHistoryModel!.data!.length,
                    itemBuilder: (context, index) {
                      var payment =
                      paymentHistoryModel!.data![index];
                      String formattedPaidOn = DateFormat(
                          'EEEE, dd MMMM yyyy, hh:mm a')
                          .format(
                          DateTime.parse(payment.paidOn ?? ''));

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewAppointmentDetailsScreen(
                                    doctorId: payment.doctorId ?? '',
                                    patientId: payment.patientId ?? '',
                                    appointmentId:
                                    payment.appointmentId ?? '',
                                    name: '',
                                    gender: '',
                                    time: '',
                                  ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: ListTile(
                            title: Text(formattedPaidOn),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Appointment Fees: ${payment.appointmentFees}'),
                                Text(
                                    'Platform Fees: ${payment.platformFees}%'),
                                Text(
                                    'Receivable Amount: ${payment.amount}'),
                                Text(
                                    'Payment Status: ${payment.status}'),
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
}
