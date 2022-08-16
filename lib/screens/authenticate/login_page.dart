import 'package:flutter/material.dart';
import 'package:studently/screens/authenticate/start_page.dart';
import 'package:studently/screens/studentScreens/profileStudent.dart';
import 'package:studently/services/auth.dart';
import 'package:studently/services/database.dart';
import 'package:studently/shared/loading.dart';
import 'package:studently/shared/registerTextInput.dart';

class LoginPage extends StatefulWidget {
  final toggleView;
  LoginPage({this.toggleView});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

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
                    height: 150,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                              email = val.trim();
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        const SizedBox(
                          height: 15,
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
                              password = val.trim();
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'could not sign in with those credentials.';
                                  loading = false;
                                });
                              }
                            }
                          },
                          style: registerElevatedButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(150, 20, 150, 20)),
                          ),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: const Text(
                                "Sign Up",
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
