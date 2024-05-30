  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:v_doctor/utils/String.dart';
  import 'package:v_doctor/utils/colors.dart';
  import 'package:intl/intl.dart';


  class ViewAppointmentDetails extends StatefulWidget {
    const ViewAppointmentDetails({super.key});

    @override
    State<ViewAppointmentDetails> createState() => _ViewAppointmentDetailsState();
  }
  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString).toLocal(); // Parse and convert to local time
      final formattedTime = DateFormat.jm().format(dateTime); // Format to 12-hour format
      return formattedTime;
    } catch (e) {
      print('Error formatting time: $e');
      return 'Invalid Time';
    }
  }
  class _ViewAppointmentDetailsState extends State<ViewAppointmentDetails> {
    late double height;
    late double width;
    late String name;
    late String mobileNo;
    late String profile_pic;
    late String date;
    late String startTime;
    late String experience;
    late int unique_id;
    late bool isCompleted;
    @override
    void initState() {
      super.initState();
      final Map args = Get.arguments;
      name = args['name'] ?? 'Name not available';
      mobileNo = args['mobileNo'] ?? 'Mobile number not available';
      profile_pic = args['profile_pic'] ?? profileTemp;
      date = args['date'] ?? "Invalid Date";
      startTime = _formatTime(args['StartTime']) ?? 'Start Time Not Defined';
      unique_id = args['unique_id'] ?? '';
      isCompleted = args['isCompleted'] ?? '';

    }


    @override
    Widget build(BuildContext context) {
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 30, bottom: 20),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Row(
              children: [
                Text(
                  appointmentTxt,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Ink(
                  decoration: BoxDecoration(
                      color: ColorConstants.iconBackground,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100.0),
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: isCompleted ? Colors.green : Colors.red,
                  size: 25,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Appointment ${isCompleted ? 'Completed' : 'Pending'}" ,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.red,
                    fontSize: 20,
                  ),
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  color: ColorConstants.PendingBackground,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          unique_id.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
                child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage("$profile_pic"),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Female",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorConstants.appontmentDetailsTxt,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: " - ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.appontmentDetailsTxt,
                            ),
                          ),
                          TextSpan(
                            text: "Age",
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConstants.appontmentDetailsTxt,
                            ),
                          ),
                          TextSpan(
                            text: " - ",
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConstants.appontmentDetailsTxt,
                            ),
                          ),
                          TextSpan(
                            text: "20",
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConstants.appontmentDetailsTxt,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: ColorConstants.iconBackground,
                        size: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "$mobileNo",
                        style: TextStyle(
                            color: ColorConstants.appontmentDetailsTxt,
                            fontSize: 20),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: ColorConstants.iconBackground,
                        size: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "$date - $startTime",
                        style: TextStyle(
                            color: ColorConstants.appontmentDetailsTxt,
                            fontSize: 20),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        PrescriptionImg,
                        height: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Prescription",
                        style: TextStyle(
                            color: ColorConstants.appontmentDetailsTxt,
                            fontSize: 20),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        )),
      ));
    }
  }
