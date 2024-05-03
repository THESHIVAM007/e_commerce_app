import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'OTP',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 2),
                    ),
                  ],
                  color: Colors.purple,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: otpController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  labelText: "Enter OTP",
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.purple,
                ),
                onPressed: () {
                  AuthRepo.submitOtp(context, otpController.text);
                },
                child: const Text("Submit OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
