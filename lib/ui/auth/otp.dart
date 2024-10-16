// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/db/db.dart';
import 'package:test_app/ui/notes.dart';

import '../../models/user_model.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Enter Your Otp",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: otpController,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(hintText: "1234 for success"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                final instance = await SharedPreferences.getInstance();
                final UserModel user = await AppDatabase.instance.readUser(
                    UserModel(phoneNumber: widget.phoneNumber, otp: "otp"));
                if (otpController.text.contains(user.otp)) {
                  await instance.setBool("isLogin", true);
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return NotesView(
                      user: user,
                    );
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Invalid Otp"),
                  ));
                }
              },
              child: const Text("Submit Otp")),
        ],
      ),
    );
  }
}
