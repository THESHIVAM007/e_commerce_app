import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String phoneNumber = phoneController.text;
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login / SignUp',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 2),
                    ),
                  ],
                  color: Colors.white,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  labelText: "Enter Phone Number",
                  counterText: "",
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  if (phoneNumber.length == 10 &&
                      RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
                    AuthRepo.verifyPhoneNumber(context, phoneNumber);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter valid Number"),
                      ),
                    );
                  }
                },
                child: const Text("Send OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
