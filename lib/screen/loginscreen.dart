import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Column(
          children: [
             TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Enter Phone Number"
              ),
              keyboardType: TextInputType.number,
            ),
             TextField(
              keyboardType: TextInputType.number,
              controller: otpController,
              decoration: const InputDecoration(
                labelText: "Enter Otp"
              ),
            ),
            ElevatedButton(
              onPressed: (){
                AuthRepo.verifyPhoneNumber(phoneController.text);
              },
              child: const Text("Send otp"),
            ),
            ElevatedButton(
              onPressed: () {
                AuthRepo.submitOtp(otpController.text);
              },
              child: const Text("Submit otp"),
            ),
          ],
        ),
      ),
    );
  }
}
