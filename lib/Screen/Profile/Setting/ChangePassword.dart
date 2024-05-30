import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/SessionManager.dart';
import 'package:v_doctor/utils/String.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  SessionManager sessionManager = SessionManager();
  UserData? userData;
  Dio dio = Dio();
  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    getInfo();
  }

  void getInfo() async {
    await sessionManager.getUserInfo().then((value) {
      if (value != null) {
        setState(() {
          userData = value;
        });
      }
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void UpdatePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      showSnackBar('New password and confirm password do not match');
      return;
    }

    Map<String, dynamic> feesStructure = {
      'currentPassword': oldPasswordController.text,
      'newPassword': newPasswordController.text,
      'confirmPassword': confirmPasswordController.text,
    };

    try {
      String accessToken = userData!.accessToken;
      String userId = userData!.userId;
      String userType = userData!.userType;

      await dio.patch(
        API + 'user/update-password/$userId',
        data: feesStructure,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'user-id': userId,
          'user-type': userType,
        }),
      );

      // Show success message
      showSnackBar('Successfully change password');
    } catch (e) {
      // Handle errors
      print(e);
      showSnackBar('Failed Not Change Password');
    }
  }

  void togglePasswordVisibility(int field) {
    setState(() {
      if (field == 1)
        obscureOldPassword = !obscureOldPassword;
      else if (field == 2)
        obscureNewPassword = !obscureNewPassword;
      else if (field == 3) obscureConfirmPassword = !obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            buildPasswordField(
              controller: oldPasswordController,
              labelText: 'Old Password',
              obscureText: obscureOldPassword,
              field: 1,
            ),
            SizedBox(height: 16),
            buildPasswordField(
              controller: newPasswordController,
              labelText: 'New Password',
              obscureText: obscureNewPassword,
              field: 2,
            ),
            SizedBox(height: 16),
            buildPasswordField(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
              obscureText: obscureConfirmPassword,
              field: 3,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                UpdatePassword();
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required int field,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              togglePasswordVisibility(field);
            },
          ),
        ),
      ),
    );
  }
}
