import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/PatientAPI/TimeSlotsAPI.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Model/TimeSlotsModel.dart';
import 'package:v_doctor/Screen/BookAppointment/DiagnosisQuestionsN.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class BookAppointment extends StatefulWidget {
  final String name;
  final String doctor_id;
  final String fees;
  final String address;
  final String appointmentMode;

  const BookAppointment({
    Key? key,
    required this.name,
    required this.doctor_id,
    required this.fees,
    required this.address,
    required this.appointmentMode,
  }) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  DateTime _selectedDate = DateTime.now();
  SessionManager? sessionManager;
  UserData? userData;
  Dio dio = Dio();
  bool isLoading = false;
  String? errorMessage;
  TimeSlotsModel? timeSlotsModel;
  String? selectedSlot;

  @override
  void initState() {
    super.initState();
    sessionManager = SessionManager();
    getTimeSlots();
  }

  void getTimeSlots() async {
    await sessionManager?.getUserInfo().then((value) {
      if (value != null) {
        userData = value;

        fetchTimeSlots(_selectedDate);
      }
    });
  }

  void fetchTimeSlots(DateTime selectedDate) async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;
      String formattedDate = DateFormat("dd-MM-yyyy").format(selectedDate);

      timeSlotsModel = await TimeSlotsAPIService().getTimeSlots(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
        doctorId: widget.doctor_id,
        date: formattedDate,
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

  List<DateTime> getDisabledDates() {
    List<DateTime> disabledDates = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < now.month; i++) {
      DateTime monthStart = DateTime(now.year, i + 1, 1);
      for (DateTime date = monthStart;
          date.isBefore(today);
          date = date.add(Duration(days: 1))) {
        disabledDates.add(date);
      }
    }
    return disabledDates;
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
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    children: [
                      EasyDateTimeLine(
                        initialDate: DateTime.now(),
                        disabledDates: getDisabledDates(),
                        onDateChange: (selectedDate) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                          fetchTimeSlots(selectedDate);
                        },
                        headerProps: const EasyHeaderProps(
                          dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
                          monthPickerType: MonthPickerType.switcher,
                          monthStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        dayProps: EasyDayProps(
                          height: 70.0,
                          width: 70.0,
                          dayStructure: DayStructure.dayNumDayStr,
                          activeDayStyle: DayStyle(
                            dayNumStyle: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          activeDayDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: ColorConstants.DateSelecte,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      isLoading
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Expanded(
                              child: GridView.count(
                                primary: false,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio: 4 / 0.9,
                                shrinkWrap: true,
                                children: _buildTimeSlots(),
                              ),
                            ),
                      if (timeSlotsModel?.data?.isEmpty ?? true)
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'No available time slots',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      else
                        SizedBox(height: 20,),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1),
                            color: Colors.blue,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedSlot == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select a time slot.'),
                                  ),
                                );
                              } else {
                                Get.to(DiagnosisQuestionsN(
                                  name: widget.name,
                                  doctor_id: widget.doctor_id,
                                  fees: (widget.fees).toString(),
                                  address: widget.address,
                                  selectedDate: _selectedDate,
                                  selectedSlot: selectedSlot!,
                                  selectedDay:
                                      DateFormat('EEEE').format(_selectedDate),
                                    appointmentMode : widget.appointmentMode
                                ));
                              }
                            },

                            child: Row(
                              children: [
                                Image.asset(
                                  BookIcon,
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(width: 8),
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

  List<Widget> _buildTimeSlots() {
    if (timeSlotsModel?.data?.isNotEmpty ?? false) {
      List<AvailableTimings>? availableTimings =
          timeSlotsModel!.data![0].availableTimings;

      if (availableTimings != null && availableTimings.isNotEmpty) {
        return availableTimings.map((timing) {
          bool isBooked = timing.isBooked ?? true;
          bool isSelected = timing.time == selectedSlot;
          return GestureDetector(
            onTap: isBooked
                ? null
                : () {
                    setState(() {
                      selectedSlot = timing.time;
                    });
                  },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? Colors.blue
                    : (isBooked ? Colors.grey : Colors.transparent),
                border: Border.all(
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  timing.time ?? 'Unknown',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isBooked ? Colors.white : Colors.black),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList();
      }
    }
    return [];
  }
}
