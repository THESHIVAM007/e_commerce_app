import 'package:e_commerce_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  bool isgettingOTP = false; // State to manage button enable/disable


  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }



  void getOTP() {
    String phoneNumber = phoneController.text;
    if (RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      setState(() {
        isgettingOTP =true;
      });
      AuthRepo.verifyPhoneNumber(context, phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid phone number"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Accessing theme data
    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Using background color from theme
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary, // Using primary color from theme
        title: Text(
          'Login',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary, // Ensuring text color is readable on primary color
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 2),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Text(
              "Enter your Mobile Number to get OTP",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
                ),
                labelText: "Mobile Number",
                prefix: const Text(
                  "+91  |  ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                counterText: "",
              ),
              maxLength: 10,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: getOTP ,  // Enable the button only if isButtonEnabled is true
                child:  Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: !isgettingOTP?  const Text(
                    "Send OTP",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ) : const Center(child: CircularProgressIndicator(color: Colors.white,),),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("By Clicking, I accept the Terms & Conditions and Privacy Policy"),
            ),
          ],
        ),
      ),
    );
  }
}
