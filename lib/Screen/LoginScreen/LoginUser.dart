import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_doctor/API/PatientAPI/LoginAPI.dart';
import 'package:v_doctor/Common%20Widget/LogoTitle.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/Progressbar.dart';
import 'package:v_doctor/Screen/Doctor/DoctorHomeScreen.dart';
import 'package:v_doctor/Screen/LoginScreen/CreateUser.dart';
import 'package:v_doctor/Screen/Patient/PatientHomeScreen.dart';
import 'package:v_doctor/utils/String.dart';
import 'package:v_doctor/utils/colors.dart';

import '../../utils/SessionManager.dart';

class LoginUser extends StatefulWidget {
  final String selectedCard;
  final String selectedCardId;

  const LoginUser(
      {Key? key, required this.selectedCardId, required this.selectedCard})
      : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  late LoginRequestModel requestModel;
  Timer? _timer;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel(email: '', password: '');

    setState(() {
      emailController?.text = "patient123@gmail.com";
      passwordController?.text = "patient123";
    });
  }

  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer(duration, () {
      setState(() {
        isApiCallProcess = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  LogoTitle(),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 14),
                      children: [
                        TextSpan(
                          text: continue_as,
                          style: TextStyle(
                            color: ColorConstants.secondaryTextColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.selectedCard.toUpperCase()}',
                          style: TextStyle(
                            letterSpacing: 2,
                            color: ColorConstants.primaryColor,
                            decoration: TextDecoration.none,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    emailText,
                    style: TextStyle(
                        wordSpacing: 2,
                        letterSpacing: 1,
                        color: ColorConstants.secondaryTextColor),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.03,
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffeeeeee),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black.withOpacity(0.13)),
                    ),
                    child: Form(
                      key: globalKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => requestModel.email = input!,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return 'Email is required';
                              }
                              // Regular expression for basic email validation
                              final emailRegExp =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegExp.hasMatch(input)) {
                                return 'Please enter a valid email';
                              }
                              return null; // Return null if the input is valid
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              enabledBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => requestModel.password = input!,
                            validator: (input) {
                              if (input!.length < 6) {
                                return "Password should be at least 6 characters long";
                              }
                              return null; // Return null if the input is valid
                            },
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),

                          TextButton(
                            onPressed: () {
                              Get.to(CreateUser(
                                  selectedCardId: widget.selectedCardId,
                                  selectedCard: widget.selectedCard));
                            },
                            child: Text(
                              'Create New Account',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: ColorConstants.secondaryAppColor,
                    ),
                    child: isApiCallProcess
                        ? SizedBox.shrink()
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isApiCallProcess = true;
                              });
                              startTimer();
                              if (validateAndSave()) {
                                loginUser();
                              }
                            },
                            icon: Icon(
                              Icons.arrow_forward_outlined,
                              size: MediaQuery.of(context).size.width * 0.06,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          isApiCallProcess
              ? ProgressBar(
                  key: UniqueKey(),
                  color: Colors.transparent,
                  inAsyncCall: isApiCallProcess,
                  opacity: 0.3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ColorConstants.primaryColor),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void loginUser() {
    LoginAPIService loginApiService = LoginAPIService();
    loginApiService.loginUser(requestModel).then((value) {
      setState(() {
        isApiCallProcess = false;
      });
      if (value.success) {
        SessionManager sessionManager = SessionManager();
        sessionManager.setUserInfo(jsonEncode(value.data[0].toJson()));
        print(value.message);
        showSuccessSnackbar(value.message);
        if (value.data[0].isDoctor) {
          Get.to(DoctorHomeScreen());
        } else {
          Get.to(PatientHomeScreen());
        }
        print(jsonEncode({
          'message': 'You have successfully logged in to account!',
          'data': [
            {
              'id': value.data[0].userId,
              'userType': value.data[0].userType,
              'access_token': value.data[0].accessToken,
              'refresh_token': value.data[0].refreshToken,
              'isDoctor': value.data[0].isDoctor,
              'isPatient': value.data[0].isPatient
            }
          ],
          'success': true,
        }));
      } else {
        final snackbar = SnackBar(content: Text(value.message));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }).catchError((error) {
      print("Error occurred: $error");
    });
  }
}
