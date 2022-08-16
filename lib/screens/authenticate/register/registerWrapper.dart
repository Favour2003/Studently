import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:studently/screens/authenticate/register/registerTutor.dart';
import 'package:studently/screens/authenticate/start_page.dart';
import 'package:studently/screens/studentScreens/profileStudent.dart';
import 'package:studently/services/auth.dart';
import 'package:studently/shared/loading.dart';
import 'package:studently/shared/registerTextInput.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterWrapper extends StatefulWidget {
  final toggleView;
  RegisterWrapper({this.toggleView});

  @override
  State<RegisterWrapper> createState() => _RegisterWrapperState();
}

class _RegisterWrapperState extends State<RegisterWrapper> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  bool loading = false;

  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String publicUsername = '';
  String password = '';
  String type = 'tutor';
  String error = '';
  bool checkedValue = false;

  void customLaunch(command) async {
    if (await launchUrl(command)) {
    } else {
      print("Could not launch $command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          maxLines: 1,
                          decoration: registerTextInput.copyWith(
                            fillColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.mail,
                              color: Colors.green,
                            ),
                            hintText: "Enter your email",
                          ),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a valid username' : null,
                          maxLines: 1,
                          decoration: registerTextInput.copyWith(
                            fillColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            hintText: "Enter a public username",
                            helperText:
                                "your username will be public and cannot be changed.",
                          ),
                          onChanged: (val) {
                            setState(() {
                              publicUsername = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          maxLines: 1,
                          obscureText: true,
                          decoration: registerTextInput.copyWith(
                            fillColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.green,
                            ),
                            hintText: "Enter your password",
                          ),
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ToggleSwitch(
                          minWidth: 90.0,
                          initialLabelIndex: 1,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: const ['Student', 'Tutor'],
                          activeBgColors: const [
                            [Colors.lime],
                            [Colors.green]
                          ],
                          onToggle: (index) {
                            if (index == 1) {
                              type = 'tutor';
                            } else {
                              type = 'student';
                            }
                            print(type);
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: checkedValue,
                              onChanged: (value) {
                                setState(() {
                                  checkedValue = value!;
                                });
                              },
                            ),
                            const Text("I agree to the"),
                            TextButton(
                              onPressed: () {
                                customLaunch(Uri.parse(
                                    "https://www.termsandcondiitionssample.com/live.php?token=ZjLnbrqKrtZCvKpbnPwroUdmHWOrZ5e7"));
                              },
                              child: const Text(
                                "terms and conditions.",
                                style: TextStyle(color: Colors.green),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (checkedValue == false) {
                                setState(() {
                                  error =
                                      "You need to accept the terms and conditions";
                                });
                                return;
                              }
                              setState(() {
                                loading = true;
                              });

                              dynamic result = await _auth
                                  .registerWithEmailAndPassword(
                                      email,
                                      password,
                                      publicUsername.toLowerCase(),
                                      "",
                                      type,
                                      "",
                                      "", [], []);

                              if (result == null) {
                                setState(() {
                                  error =
                                      '   please supply a valid email\n(email may already be in use)';
                                  loading = false;
                                });
                              }
                            }
                          },
                          style: registerElevatedButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(150, 20, 150, 20)),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          error,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(color: Colors.green),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
