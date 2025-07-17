
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:centralproject/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

String? gid; // Declare gid to avoid compilation error

// String get jwtPaymentUrl => 'http://localhost:3000/api/pay/jwt';

String generateMerchantTxnId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = Random();
  final randomDigits = List.generate(6, (_) => random.nextInt(10)).join();
  return '$timestamp$randomDigits';
}

Future<void> handlePcJwtPayment(
  String amount, // Changed to String
  String currency,
  BuildContext context,
) async {
  try {
    final merchantTxnId = generateMerchantTxnId();
    final payload = {
      "merchantTxnId": merchantTxnId,
      "paymentData": {"totalAmount": amount, "txnCurrency": currency},
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };
    print(payload);
    final response = await http
        .post(
          Uri.parse(jwtPaymentUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Request timed out');
          },
        );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final paymentLink = responseData['payment_link'];
      gid = responseData['gid'];

      if (paymentLink == null || paymentLink.isEmpty) {
        throw Exception('No payment link received');
      }

      final paymentUri = Uri.parse(paymentLink);
      if (await canLaunchUrl(paymentUri)) {
        await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch payment link');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment Initiated! Redirecting...',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF5E35B1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (error) {
    print('Unexpected error: $error');
    throw Exception('Error: $error');
  }
}


final String startDate = DateFormat('yyyyMMdd').format(DateTime.now());

Future<void> handlePcFixedSIPayment(
  String amount, // Changed to String for consistency
  String currency,
  BuildContext context,
) async {
  try {
    final merchantTxnId = generateMerchantTxnId();
    final payload = {
      "merchantTxnId": merchantTxnId,
      "paymentData": {"totalAmount": amount, "txnCurrency": currency},
      "standingInstruction": {
        "data": {
          "amount": amount,
          "numberOfPayments": "12",
          "frequency": "MONTHLY",
          "type": "FIXED",
          "startDate": startDate,
        },
      },
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };
 print(payload);
    final response = await http
        .post(
          Uri.parse(siPaymentUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Request timed out');
          },
        );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final paymentLink = responseData['payment_link'];
      gid = responseData['gid'];

      if (paymentLink == null || paymentLink.isEmpty) {
        throw Exception('No payment link received');
      }

      final paymentUri = Uri.parse(paymentLink);
      if (await canLaunchUrl(paymentUri)) {
        await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch payment link');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment Initiated! Redirecting...',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF5E35B1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (error) {
    print('Unexpected error: $error');
    throw Exception('Error: $error');
  }
}



Future<void> handlePcVariableSIPayment(
  String amount, 
  BuildContext context,
) async {
  try {
    
    final merchantTxnId = generateMerchantTxnId();
    final payload = {
      "merchantTxnId": merchantTxnId,
      "paymentData": {"totalAmount": amount, "txnCurrency": 'INR'},
      "standingInstruction": {
        "data": {
          "maxAmount": amount,
          "numberOfPayments": "12",
          "frequency": "MONTHLY",
          "type": "VARIABLE",
        },
      },
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };
    print(payload);
    final response = await http
        .post(
          Uri.parse(siPaymentUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Request timed out');
          },
        );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final paymentLink = responseData['payment_link'];
      gid = responseData['gid'];

      if (paymentLink == null || paymentLink.isEmpty) {
        throw Exception('No payment link received');
      }

      final paymentUri = Uri.parse(paymentLink);
      if (await canLaunchUrl(paymentUri)) {
        await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch payment link');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment Initiated! Redirecting...',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF5E35B1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (error) {
    print('Unexpected error: $error');
    throw Exception('Error: $error');
  }
}

// Future<void> handlePcSIPayment()async{

// }


// Future<void> handlePcAuthPayment(
//   String amount, // Changed to String for consistency
//   String currency,
//   BuildContext context,
// ) async {
//   try {
//     final merchantTxnId = generateMerchantTxnId();
//     final payload = {
//       "merchantTxnId": merchantTxnId,
//       "captureTxn": false,
//       "paymentData": {"totalAmount": amount, "txnCurrency": currency},
//       "merchantCallbackURL":
//           "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
//     };
//     print(payload);
//     final response = await http
//         .post(
//           Uri.parse(authUrl),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(payload),
//         )
//         .timeout(
//           const Duration(seconds: 10),
//           onTimeout: () {
//             throw Exception('Request timed out');
//           },
//         );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       final paymentLink = responseData['payment_link'];
//       gid = responseData['gid'];

//       if (paymentLink == null || paymentLink.isEmpty) {
//         throw Exception('No payment link received');
//       }

//       final paymentUri = Uri.parse(paymentLink);
//       if (await canLaunchUrl(paymentUri)) {
//         await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
//       } else {
//         throw Exception('Could not launch payment link');
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Payment Initiated! Redirecting...',
//             style: GoogleFonts.inter(color: Colors.white),
//           ),
//           backgroundColor: const Color(0xFF5E35B1),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   } catch (error) {
//     print('Unexpected error: $error');
//     throw Exception('Error: $error');
//   }
// }

//  Future<void> handlePcAuthPayment(
//   Map<String, dynamic>flighData, 
//    BuildContext context,
// ) async {
//   try {


// for (int i = 0; i < flighData.length; i++) {
//   print('Flight ${i + 1}:');
//   flighData[i].forEach((key, value) {
//     print('  $key: $value');
//   });
// }
//        final payload = {
//       "merchantTxnId": 123454323456,
//       "captureTxn": false,
//       "paymentData": {"totalAmount": 1232, "txnCurrency": 'INR'},
//       // "riskData": riskData,
//       "merchantCallbackURL":
//           "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
//     };

//     // print(payload);
//     final response = await http
//         .post(
//           Uri.parse(authUrl),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode(payload),
//         )
//         .timeout(
//           const Duration(seconds: 10),
//           onTimeout: () {
//             throw Exception('Request timed out');
//           },
//         );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       final paymentLink = responseData['payment_link'];
//       gid = responseData['gid'];

//       if (paymentLink == null || paymentLink.isEmpty) {
//         throw Exception('No payment link received');
//       }

//       final paymentUri = Uri.parse(paymentLink);
//       if (await canLaunchUrl(paymentUri)) {
//         await launchUrl(paymentUri, mode: LaunchMode.externalApplication);
//         // return {'success': true};
//       } else {
//         throw Exception('Could not launch payment link');
//       }
//     } else {
//       throw Exception('Payment request failed: ${response.statusCode}');
//     }
//   } catch (error) {
//     print('Unexpected error: $error');
//     // return {'success': false, 'message': 'Error: $error'};
//   }
// }

void handlePcAuthPayment(Map<String, dynamic> riskData, BuildContext context) {
  // Implement payment logic here
  print('Processing payment with riskData: $riskData');
  // Example: Send riskData to a payment gateway API
}