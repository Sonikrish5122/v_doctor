import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

class SetTimerScreen extends StatefulWidget {
  @override
  State<SetTimerScreen> createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {
  List<bool> _daySwitchValues = List.filled(7, true);
  List<TimeOfDay?> _startTimes = List.filled(7, null);
  List<TimeOfDay?> _endTimes = List.filled(7, null);
  List<bool> _timeSelectionMade = List.filled(7, false); // Track time selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.11,
                  padding: EdgeInsets.all(20.0),
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
                            timingtxt,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1,
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: List.generate(7, (index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _getDayName(index),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: _daySwitchValues[index],
                                        activeTrackColor:
                                            ColorConstants.activeTrackColor,
                                        activeColor: ColorConstants.SwitchColor,
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            _daySwitchValues[index] = newValue;
                                            if (newValue) {
                                              if (!_timeSelectionMade[index]) {
                                                _startTimes[index] = null;
                                                _endTimes[index] = null;
                                                _timeSelectionMade[index] =
                                                    true;
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  if (_daySwitchValues[index]) ...[
                                    // SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Start Time',
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .appontmentDetailsTxt),
                                        ),
                                        Spacer(),
                                        Text(
                                          'End Time',
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .appontmentDetailsTxt),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              _selectStartTime(context, index),
                                          child: _startTimes[index] != null
                                              ? Text(
                                                  _formatTime(
                                                      _startTimes[index]!),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                )
                                              : Text(
                                                  'Select Start Time',
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () =>
                                              _selectEndTime(context, index),
                                          child: _endTimes[index] != null
                                              ? Text(
                                                  _formatTime(
                                                      _endTimes[index]!),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                )
                                              : Text(
                                                  'Select End Time',
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ],
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('SAVE'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTimes[index] ?? TimeOfDay(hour: 9, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.black87,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateColor.resolveWith(
                  (states) => ColorConstants.secondaryAppColor,
                ),
              ),
            ),
          ),
          child: Center(
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _startTimes[index]) {
      setState(() {
        _startTimes[index] = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTimes[index] ?? TimeOfDay(hour: 17, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.black87,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateColor.resolveWith(
                  (states) => ColorConstants.secondaryAppColor,
                ),
              ),
            ),
          ),
          child: Center(
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _endTimes[index]) {
      setState(() {
        _endTimes[index] = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime);
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return monday;
      case 1:
        return thursday;
      case 2:
        return wednesday;
      case 3:
        return thursday;
      case 4:
        return friday;
      case 5:
        return saturday;
      case 6:
        return sunday;
      default:
        return '';
    }
  }
}
