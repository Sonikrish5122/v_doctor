import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final List<bool> selectedSpecialties;

  const CustomDialog({Key? key, required this.selectedSpecialties})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List<bool>.from(widget.selectedSpecialties);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10), // Changed height from 20 to 10
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Doctor Speciality',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Perform search operation here
                },
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Neurology'),
                trailing: Checkbox(
                  value: _isSelected[0],
                  onChanged: (bool? value) {
                    setState(() {
                      _isSelected[0] = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Dermatology'),
                trailing: Checkbox(
                  value: _isSelected[1],
                  onChanged: (bool? value) {
                    setState(() {
                      _isSelected[1] = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Cardiology'),
                trailing: Checkbox(
                  value: _isSelected[2],
                  onChanged: (bool? value) {
                    setState(() {
                      _isSelected[2] = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Orthopedics'),
                trailing: Checkbox(
                  value: _isSelected[3],
                  onChanged: (bool? value) {
                    setState(() {
                      _isSelected[3] = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Gynecology'),
                trailing: Checkbox(
                  value: _isSelected[4],
                  onChanged: (bool? value) {
                    setState(() {
                      _isSelected[4] = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Pediatrics'),
                trailing: Checkbox(
                  value: _isSelected[5],
                  onChanged: (bool? value) {
                    setState(() {
                      _isSelected[5] = value ?? false;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement save logic here
                  },
                  child: Text('SAVE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
