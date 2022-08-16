import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatelessWidget {
  const Contacts({Key? key}) : super(key: key);

  void customLaunch(command) async {
    if (await launchUrl(command)) {
      await launchUrl(command);
    } else {
      print("Could not launch $command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Need Help?",
          style: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Contact us at this email: "),
              TextButton(
                onPressed: () {
                  customLaunch(Uri.parse(
                      "mailto:frozmane@gmail.com?subject=News&body=New%20plugin"));
                },
                child: const Text(
                  "frozmane@gmail.com",
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Or contact us at this sms: "),
              TextButton(
                onPressed: () {
                  customLaunch(Uri.parse("sms:3895340991"));
                },
                child: const Text(
                  "3895340991",
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
