import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_doctor/API/PatientAPI/DoctorInfoAPI.dart';
import 'package:v_doctor/Model/DoctorInfoModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Screen/BookAppointment/BookAppointment.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class ViewDoctorDetails extends StatefulWidget {
  final String doctorId;

  const ViewDoctorDetails({Key? key, required this.doctorId}) : super(key: key);

  @override
  _ViewDoctorDetailsState createState() => _ViewDoctorDetailsState();
}

class _ViewDoctorDetailsState extends State<ViewDoctorDetails> {
  bool isExpanded = false;
  bool isAddressExpanded = false;
  SessionManager? sessionManager;
  UserData? userData;
  Dio dio = Dio();
  bool isLoading = false;
  String? errorMessage;
  DoctorInfoModel? doctorInfo;

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getDoctorInfo();
  }

  void getDoctorInfo() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        fetchDoctorInfo();
      }
    });
  }

  void fetchDoctorInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      doctorInfo = await DoctorInfoAPIService().getDoctorDetails(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        doctorId: '${widget.doctorId}',
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                          doctorInfo?.doctorProfile.name ?? '',
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                          heightFactor: 22,
                        )
                      : Padding(
                          padding: EdgeInsets.all(width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: width * 0.1,
                                    backgroundImage: NetworkImage(
                                      doctorInfo?.doctorProfile.profilePic ??
                                          profileTemp,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doctorInfo?.speciality
                                                  .map((speciality) =>
                                                      speciality.specialityName)
                                                  .join(' , ') ??
                                              '',
                                          style: TextStyle(
                                            fontSize: width * 0.04,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          doctorInfo?.degrees
                                                  .map((degree) =>
                                                      degree.degreeName)
                                                  .join(' , ') ??
                                              '',
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .secondaryTextColor),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.all(width * 0.02),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          Experience,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          doctorInfo?.doctorProfile.experience
                                                  ?.toString() ??
                                              '',
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    VerticalDivider(
                                      width: 20,
                                      thickness: 2,
                                      indent: 40,
                                      endIndent: 10,
                                      color: Colors.black,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          duration,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("10 min"),
                                      ],
                                    ),
                                    VerticalDivider(),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          callTxt,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(doctorInfo
                                                ?.doctorProfile.mobileNo ??
                                            ''),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: height * 0.14,
                                width: double.infinity,
                                child: Card(
                                  color: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.05,
                                            vertical: width * 0.02),
                                        child: Row(
                                          children: [
                                            Text(
                                              FeesTxt,
                                              style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            Text(
                                              OnlineCallTxt,
                                              style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              OfflineTxt,
                                              style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.05),
                                        child: Row(
                                          children: [
                                            Text(
                                              FirsttimeText,
                                              style: TextStyle(
                                                  fontSize: width * 0.04),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${doctorInfo?.fees.offlineNewCaseFees ?? ''}',
                                              style: TextStyle(
                                                  fontSize: width * 0.035),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${doctorInfo?.fees.offlineOngoingCaseFees ?? ''}',
                                              style: TextStyle(
                                                  fontSize: width * 0.035),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.05,
                                            vertical: width * 0.02),
                                        child: Row(
                                          children: [
                                            Text(
                                              NormalTxt,
                                              style: TextStyle(
                                                  fontSize: width * 0.04),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${doctorInfo?.fees.onlineNewCaseFees ?? ''}',
                                              style: TextStyle(
                                                  fontSize: width * 0.035),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${doctorInfo?.fees.onlineOngoingCaseFees ?? ''}',
                                              style: TextStyle(
                                                  fontSize: width * 0.035),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          addressTxt,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.04),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launch(
                                                'https://www.google.com/maps?q=${Uri.encodeComponent(doctorInfo?.clinicInfo.address ?? 'Not available')}');
                                          },
                                          child: SvgPicture.asset(
                                            navigationImg,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        '${doctorInfo?.clinicInfo.address ?? 'Not available'}',
                                        style: TextStyle(
                                          fontSize: width * 0.035,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      aboutTxt,
                                      style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      doctorInfo?.doctorProfile.about ?? '',
                                      style: TextStyle(
                                          fontSize: width * 0.035,
                                          color: ColorConstants
                                              .secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = !isExpanded;
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        availabilityTxt,
                                        style: TextStyle(
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Spacer(),
                                      Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up_sharp
                                            : Icons.keyboard_arrow_down_sharp,
                                        size: width * 0.07,
                                        color:
                                            ColorConstants.secondaryTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isExpanded && doctorInfo != null) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: doctorInfo!.availability
                                      .map((availability) {
                                    final startTime = availability['startTime'];
                                    final endTime = availability['endTime'];
                                    final isAvailable =
                                        availability['isAvailable'];

                                    if (startTime == null ||
                                        endTime == null ||
                                        isAvailable == false) {
                                      return Row(
                                        children: [
                                          Text(
                                              '${availability['day'] ?? 'All Days '}  '),
                                          Spacer(),
                                          Text('Closed'),
                                        ],
                                      );
                                    } else {
                                      DateTime parsedStartTime =
                                          DateTime.parse(startTime);
                                      DateTime parsedEndTime =
                                          DateTime.parse(endTime);

                                      String formattedStartTime =
                                          DateFormat('hh:mm a').format(
                                              parsedStartTime.toLocal());
                                      String formattedEndTime =
                                          DateFormat('hh:mm a')
                                              .format(parsedEndTime.toLocal());

                                      return Row(
                                        children: [
                                          Text('${availability['day']} '),
                                          Spacer(),
                                          Text(
                                              '$formattedStartTime - $formattedEndTime'),
                                        ],
                                      );
                                    }
                                  }).toList(),
                                ),
                              ],
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1),
                                  color: ColorConstants.btnColor,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(BookAppointment(
                                      name:
                                          doctorInfo?.doctorProfile.name ?? '',
                                      doctor_id:
                                          doctorInfo?.doctorProfile.doctorId ??
                                              '',
                                      fees: (doctorInfo?.fees
                                                  .offlineOngoingCaseFees ??
                                              '')
                                          .toString(),
                                      address: doctorInfo?.clinicInfo.address ??
                                          'Not available',
                                      appointmentMode:
                                          'offline', // Pass appointment mode here
                                    ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        BookIcon,
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        bookbtn,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.045,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                    primary: Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1),
                                  color: ColorConstants.primaryColor,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(BookAppointment(
                                      name:
                                          doctorInfo?.doctorProfile.name ?? '',
                                      doctor_id:
                                          doctorInfo?.doctorProfile.doctorId ??
                                              '',
                                      fees: (doctorInfo?.fees
                                                  .onlineOngoingCaseFees ??
                                              '')
                                          .toString(),
                                      address: doctorInfo?.clinicInfo.address ??
                                          'Not available',
                                      appointmentMode: 'online',
                                    ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        videoIcon,
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        bookvideoBtn,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.045,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                    primary: Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
