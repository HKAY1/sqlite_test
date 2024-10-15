// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:test_app/db/db.dart';

import '../../models/user_model.dart';
import 'otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Enter Your MObile Number to Login",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: phoneNumberController,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: "Mobile No.",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                final UserModel user = UserModel(
                    phoneNumber: phoneNumberController.text, otp: "1234");
                AppDatabase.instance.createUser(user).then((val) {
                  if (val) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return OtpScreen(
                        phoneNumber: phoneNumberController.text,
                      );
                    }));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Failed to create user"),
                    ));
                  }
                });
              },
              child: const Text("Get Otp")),
        ],
      ),
    );
  }
}
