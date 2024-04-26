// import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';

class AuthRepo {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static void verifyPhoneNumber(String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91 $number',
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(credential.verificationId!, credential.smsCode!);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        print("verficationId $verId");
        print("code sent");
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
static void submitOtp(String otp){
signInWithPhoneNumber(verId, otp);
}
  static Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
          print(userCredential.user!.phoneNumber);
          print("Login successful");
          // TODO: Navigate to home page
//  Navigator.push(context,Mat)

    } catch (e) {
      print('Error signing in with phone number: $e');
      // return null;
    }
  }
}
