import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dio/dio.dart'; // Import Dio package
import 'package:v_doctor/API/DoctorAPI/AddPrescriptionAPI.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/colors.dart';

class PrescriptionScreen extends StatefulWidget {
  final String patientName;
  final String appointmentId;
  final String patientId;

  const PrescriptionScreen({Key? key, required this.patientName, required this.appointmentId, required this.patientId})
      : super(key: key);

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  String? _selectedMedicineType;
  List<String> _medicineTimes = [];
  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _strengthController = TextEditingController();
  String? _selectedUnit;
  int? _selectedDose;
  int? _selectedDuration;
  String? _selectedDurationUnit;
  SessionManager? sessionManager;
  UserData? userData;
  bool isLoading = false;

  // Dio instance
  final Dio dio = Dio();

  void _savePrescription() async {

    if (userData != null &&
        _selectedMedicineType != null &&
        _medicineNameController.text.isNotEmpty &&
        _strengthController.text.isNotEmpty &&
        _selectedUnit != null &&
        _selectedDose != null &&
        _selectedDuration != null &&
        _selectedDurationUnit != null &&
        _medicineTimes.isNotEmpty) {

      try {
        setState(() {
          isLoading = true;
        });

        // Prepare prescription data
        Map<String, dynamic> prescriptionData = {
          'medicineType': _selectedMedicineType,
          'medicineName': _medicineNameController.text,
          'strength': _strengthController.text,
          'unit': _selectedUnit,
          'dose': _selectedDose,
          'duration': _selectedDuration,
          'durationUnit': _selectedDurationUnit,
          'medicineTimes': _medicineTimes,
          // Add other necessary data here
        };

        AddPrescriptionAPIService dioService = AddPrescriptionAPIService();


        await dioService.addPrescription(
          accessToken: userData!.accessToken,
          userId: userData!.userId,
          userType: userData!.userType,
          patientID: widget.patientId,
          appointmentId: widget.appointmentId,
          prescriptionData: prescriptionData,
        );

        // Prescription saved successfully, navigate back
        Navigator.of(context).pop();
      } catch (e) {
        print('Error saving prescription: $e');
        // Handle error
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('Some required fields are missing');
      // Handle missing fields
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(),
            _buildPrescriptionForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 10),
          Text(
            "Prescription for: ${widget.patientName}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Medicine 1"),
          SizedBox(height: 20),
          _buildMedicineTypeDropdown(),
          SizedBox(height: 20),
          _buildMedicineNameField(),
          SizedBox(height: 20),
          _buildStrengthField(),
          SizedBox(height: 20),
          _buildDoseSelection(),
          SizedBox(height: 20),
          _buildDurationSelection(),
          SizedBox(height: 20),
          _buildMedicineTimeSelection(),
          SizedBox(height: 20),
          _buildFoodToggle(),
          SizedBox(height: 20),
          _buildImportantNoteField(),
          SizedBox(height: 20),
          _buildSaveButton(),
          SizedBox(height: 20),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildMedicineTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedMedicineType,
      decoration: InputDecoration(
        labelText: 'Select Medicine Type',
        border: OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedMedicineType = newValue;
        });
      },
      items: <String>[
        'Liquid',
        'Tablet',
        'Injections',
        'Drops'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildMedicineNameField() {
    return TextFormField(
      controller: _medicineNameController,
      decoration: InputDecoration(
        labelText: 'Medicine Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildStrengthField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _strengthController,
            decoration: InputDecoration(
              labelText: 'Strength',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedUnit,
          onChanged: (String? newValue) {
            setState(() {
              _selectedUnit = newValue;
            });
          },
          items: <String>[
            'mg',
            'ml',
            'g',
            'IU'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDoseSelection() {
    return Row(
      children: [
        Text(
          'Select Medicine Dose:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),

        DropdownButton<int>(
          value: _selectedDose,
          onChanged: (int? newValue) {
            setState(() {
              _selectedDose = newValue;
            });
          },
          items: List.generate(10, (index) => index + 1)
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedUnit,
          onChanged: (String? newValue) {
            setState(() {
              _selectedUnit = newValue;
            });
          },
          items: <String>[
            'mg',
            'ml',
            'g',
            'IU'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationSelection() {
    return Row(
      children: [
        Text(
          'Select Intake Duration:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        DropdownButton<int>(
          value: _selectedDuration,
          onChanged: (int? newValue) {
            setState(() {
              _selectedDuration = newValue;
            });
          },
          items: List.generate(10, (index) => index + 1)
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedDurationUnit,
          onChanged: (String? newValue) {
            setState(() {
              _selectedDurationUnit = newValue;
            });
          },
          items: <String>['Days', 'Weeks', 'Months']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMedicineTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Medicine Time:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCheckbox('Morning', 'morning'),
            _buildCheckbox('Noon', 'noon'),
            _buildCheckbox('Evening', 'evening'),
            _buildCheckbox('Night', 'night'),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, String time) {
    return Row(
      children: [
        Checkbox(
          value: _medicineTimes.contains(time),
          onChanged: (bool? value) {
            setState(() {
              if (value != null && value) {
                _medicineTimes.add(time);
              } else {
                _medicineTimes.remove(time);
              }
            });
          },
        ),
        Text(title),
      ],
    );
  }

  Widget _buildFoodToggle() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      child: ToggleSwitch(
        cornerRadius: 10.0,
        minWidth: double.infinity,
        inactiveBgColor: Colors.white,
        initialLabelIndex: 0,
        totalSwitches: 2,
        labels: ['Before Food', 'After Food'],
      ),
    );
  }

  Widget _buildImportantNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Important Note:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter your important note here...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {

      },
      child: Text('Save Prescription'),
    );
  }



  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () {

      },
      child: Text('Add'),
    );
  }
}
