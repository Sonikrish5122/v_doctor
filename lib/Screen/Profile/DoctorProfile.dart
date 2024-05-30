  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:v_doctor/Screen/CustomDialog/CustomDialog.dart';
  import 'package:v_doctor/Screen/Drawer/DoctorDrawer.dart';
  import 'package:v_doctor/Screen/SetTime/TimerScreen.dart';
  import 'package:v_doctor/utils/colors.dart';
  import 'package:v_doctor/utils/String.dart';

  class DoctorProfileScreen extends StatefulWidget {
    const DoctorProfileScreen({Key? key}) : super(key: key);

    @override
    State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
  }

  class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
    late double height;
    late double width;

    GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

    TextEditingController _textFieldController = TextEditingController();
    TextEditingController _dateOfBirthController = TextEditingController();

    String? _selectedGender;
    List<bool> isSelected = [true, false, false];

    String timing = '';
    List<bool> selectedSpecialties = List.filled(7, false);
    TextEditingController searchController = TextEditingController();

    Widget buildTransparentBox(String text,
        {required Color color, required int index}) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isSelected[index] = !isSelected[index];
          });
        },
        child: Container(
          width: 100,
          height: 100,
          color:
              isSelected[index] ? color.withOpacity(0.5) : color.withOpacity(0.3),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;

      return Scaffold(
        key: _globalKey,
        backgroundColor: ColorConstants.primaryColor,
        drawer: DoctorDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * 0.11,
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
                          "Profile",
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
              Container(
                height: height * 2,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://file.xunruicms.com/admin_html/assets/pages/media/profile/profile_user.jpg",
                                ),
                                radius: 70,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              left: 100,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants.primaryColor,
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.camera),
                                  color: Colors.white,
                                  iconSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            personalDetailsText,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            labelText: 'Mobile',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _dateOfBirthController,
                          decoration: InputDecoration(
                            labelText: 'Birth Date',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              icon: Icon(Icons.calendar_today),
                            ),
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          items: <String>['Select Gender', 'Female', 'Male']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            EduandExpTxt,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            labelText: degreetxt,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    selectedSpecialties: selectedSpecialties);
                              },
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(specialityText),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            labelText: experiencetxt,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              yeartxt,
                            )),
                        SizedBox(height: 20),
                        TextField(
                          controller: _textFieldController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: aboutustxt,
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            ClinicTxt,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 20),
                        ToggleButtons(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Offline'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Online'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Both'),
                            ),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
                                isSelected[buttonIndex] = (buttonIndex == index);
                              }
                            });
                          },
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          isSelected: isSelected,
                          selectedColor: Colors.white,
                          fillColor: ColorConstants.primaryColor,
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 120,
                          ),
                        ),
                        if (isSelected[0])
                          Column(
                            children: [
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  offlinefeetxt,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: firsttimefees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: normalfees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (isSelected[1])
                          Column(
                            children: [
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  onlinefeetxt,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: firsttimefees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: normalfees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (isSelected[2])
                          Column(
                            children: [
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  offlinefeetxt,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: firsttimefees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: normalfees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  onlinefeetxt,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: firsttimefees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _textFieldController,
                                      decoration: InputDecoration(
                                        labelText: normalfees,
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetTimerScreen()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              timing.isNotEmpty ? timing : 'Add Timing',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: timing.isNotEmpty
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            labelText: clinicaddress,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _saveProfile();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime.now()) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        setState(() {
          _dateOfBirthController.text = formattedDate;
        });
      }
    }

    void _saveProfile() {
      print('Name: ${_textFieldController.text}');
      print('Mobile: ${_textFieldController.text}');
      print('Birth Date: ${_dateOfBirthController.text}');
      print('Gender: $_selectedGender');
    }
  }
