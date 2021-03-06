import 'package:firebase_authentication/config/size_config.dart';
import 'package:firebase_authentication/constants/app_colors.dart';
import 'package:firebase_authentication/constants/app_fonts.dart';
import 'package:firebase_authentication/constants/widgets/custom_button.dart';
import 'package:firebase_authentication/constants/widgets/custom_error_dialog.dart';
import 'package:firebase_authentication/constants/widgets/custom_input.dart';
import 'package:firebase_authentication/constants/widgets/loader.dart';
import 'package:firebase_authentication/services/firebase_auth_services.dart';
import 'package:firebase_authentication/views/home.dart';
import 'package:firebase_authentication/views/register.dart';
import 'package:firebase_authentication/views/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  bool obsecurePassword = true;

  Map<String, dynamic> userData = {
    'email': '',
    'password': '',
  };

  String? _emailValidator(value) {
    if (value.isEmpty) {
      return 'Please enter email';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Invalid Email';
    }
    return null;
  }

  String? _passwordValidator(value) {
    if (value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => GestureDetector(
        child: ErrorView(message),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showloader() {
    showDialog(
      context: context,
      builder: (ctx) => Loader(),
    );
  }

  Future<void>? _login() {
    if (!_loginFormKey.currentState!.validate()) {
      return null;
    }
     _loginFormKey.currentState!.save();
    _showloader();
    AuthServices().login(userData['email'], userData['password']).then((value) {
    if(value) {
      Navigator.pop(context, true);
      Navigator.of(context).pushReplacementNamed(Home.routeName);
    } else {
        Navigator.pop(context);
        _showErrorDialog('Something went wrong. Please try again!');
    }
    });
    return null;

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/shape.png',
                  fit: BoxFit.cover, width: size.width * 0.4),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier! * 3,
                      fontFamily: 'Ubuntu'),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier! * 8,
              ),
              SizedBox(
                height: size.height * 0.8,
                child: Form(
                  key: _loginFormKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier! * 4),
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.heightMultiplier! * 3,
                          ),
                          CustomInput(
                            hint: 'celine@gmail.com',
                            label: 'Email',
                            validator: _emailValidator,
                            onSaved: (value) {
                              userData['email'] = value!;
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.textMultiplier! * 3,
                          ),
                        
                          CustomInput(
                            obsecure: obsecurePassword,
                            hint: '*********',
                            label: 'Password',
                            onSaved: (value) {
                              userData['password'] = value!;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                obsecurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  obsecurePassword = !obsecurePassword;
                                });
                              },
                            ),
                            validator: _passwordValidator,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pushReplacementNamed(ResetPassword.routeName), 
                              child: Text('Forget Password?', style: AppFonts.link))),
                          SizedBox(
                            height: SizeConfig.heightMultiplier! * 5,
                          ),
                          CustomButton(
                              text: 'Login',
                              onpressed: _login,
                              width: size.width * 0.9),
                               SizedBox(
                            height: SizeConfig.heightMultiplier!,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text('Don\'t have an acount?', style: AppFonts.body1),
                            TextButton(onPressed: () => Navigator.of(context).pushReplacementNamed(Register.routeName), child: Text('Register', style: AppFonts.link)),
                          ],),
                         
                        ],
                      ),
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