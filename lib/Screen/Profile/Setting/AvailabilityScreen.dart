import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/API/DoctorAPI/AvailabilityAPI.dart';
import 'package:v_doctor/Model/DoctorModel/AvailabilityModel.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({Key? key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  bool isLoading = false;
  SessionManager sessionManager = SessionManager();
  UserData? userData;
  AvailabilityModel? availabilityModel;
  String? errorMessage;
  Dio dio = Dio();
  Data? clinicData;
  List<int> slotDurations = [10, 20, 30, 40];
  List<int> bufferTimes = [2, 5, 10, 15, 20];
  int? selectedSlotDuration;
  int? selectedBufferTime;

  @override
  void initState() {
    super.initState();
    getAvailability();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void getAvailability() async {
    await sessionManager.getUserInfo().then((value) {
      if (value != null) {
        userData = value;
        getAvailabilityInfo();
      }
    });
  }

  void getAvailabilityInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      availabilityModel = await AvailabilityAPIService().getAvailability(
        accessToken: accessToken,
        userId: userId,
        userType: userType,
      );

      if (availabilityModel!.success == true &&
          availabilityModel!.data != null &&
          availabilityModel!.data!.isNotEmpty) {
        setState(() {
          isLoading = false;
          clinicData = availabilityModel!.data![0];
          selectedSlotDuration = clinicData!.slotDuration;
          selectedBufferTime = clinicData!.bufferTime;
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

  void updateAvailability() async {
    Map<String, dynamic> availability = {
      'slotDuration': selectedSlotDuration,
      'bufferTime': selectedBufferTime,
      'availabilityData': clinicData!.timings!.map((timing) {
        return {
          'day': timing.day,
          'availability': timing.availability ?? [],
          'isAvailable': timing.isAvailable,
          'startTime': timing.isAvailable == true ? timing.startTime : "",
          'endTime': timing.isAvailable == true ? timing.endTime : "",
        };
      }).toList(),
    };

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      await dio.patch(
        API +
            'doctor/add-or-update-doctor-availability/$userId?step=3&first_login=true',
        data: availability,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'user-id': userId,
          'user-type': userType,
        }),
      );

      showSnackbar('Availability updated successfully');
    } catch (e) {
      print(e);
      showSnackbar('Failed to update availability');
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm a');
    List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];


    String formatTimeOfDay(TimeOfDay timeOfDay) {
      final now = DateTime.now();
      return DateTime(
              now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute)
          .toString();
    }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Slot Duration",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton<int>(
                              value:
                                  selectedSlotDuration ?? slotDurations.first,
                              onChanged: (value) {
                                setState(() {
                                  selectedSlotDuration = value;
                                });
                              },
                              items: slotDurations
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("${value.toString()} Minutes"),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Buffer Time",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton<int>(
                              value: selectedBufferTime ?? bufferTimes.first,
                              onChanged: (value) {
                                setState(() {
                                  selectedBufferTime = value;
                                });
                              },
                              items: bufferTimes
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("${value.toString()} Minutes"),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      ],
                    ),
                    if (clinicData != null && clinicData!.timings != null)
                      ...clinicData!.timings!.asMap().entries.map((entry) {
                        int index = entry.key;
                        Timings timing = entry.value;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  timing.day ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Spacer(),
                                Switch(
                                  value: timing.isAvailable ?? true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      timing.isAvailable = newValue;
                                      if (!newValue) {
                                        timing.startTime = null;
                                        timing.endTime = null;
                                        timing.availability = [];
                                      } else {
                                        timing.startTime = null;
                                        timing.endTime = null;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (timing.isAvailable == true) ...[
                              ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("From"),
                                          GestureDetector(
                                            onTap: () async {
                                              final selectedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if (selectedTime != null) {
                                                setState(() {
                                                  timing.startTime =
                                                      formatTimeOfDay(
                                                          selectedTime);
                                                });
                                              }
                                            },
                                            child: Text(
                                              '${timing.startTime != null ? timeFormat.format(DateTime.parse(timing.startTime!)) : 'Start Time '}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("To"),
                                        GestureDetector(
                                          onTap: () async {
                                            final selectedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (selectedTime != null) {
                                              setState(() {
                                                timing.endTime =
                                                    formatTimeOfDay(
                                                        selectedTime);
                                              });
                                            }
                                          },
                                          child: Text(
                                            '${timing.endTime != null ? timeFormat.format(DateTime.parse(timing.endTime!)) : 'End Time'}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Availability:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: timing.availability
                                                ?.contains("online") ??
                                            false,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {
                                              timing.availability
                                                  ?.add("online");
                                            } else {
                                              timing.availability
                                                  ?.remove("online");
                                            }
                                          });
                                        },
                                      ),
                                      Text("Online"),
                                      SizedBox(width: 10),
                                      Checkbox(
                                        value: timing.availability
                                                ?.contains("offline") ??
                                            false,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {
                                              timing.availability
                                                  ?.add("offline");
                                            } else {
                                              timing.availability
                                                  ?.remove("offline");
                                            }
                                          });
                                        },
                                      ),
                                      Text("Offline"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ],
                        );
                      }).toList(),
                    ElevatedButton(
                      onPressed: () {
                        updateAvailability();
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
