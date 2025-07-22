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

String generateMerchantTxnId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = Random();
  final randomDigits = List.generate(6, (_) => random.nextInt(10)).join();
  return '$timestamp$randomDigits';
}

////////////////////////////JWT Payment Handlers////////////////////////////////

Future<void> handlePcJwtPayment(
  String amount, // Changed to String
  String currency,
  BuildContext context,
  // {Map<String, dynamic>? payload} // Optional payload parameter
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

//*********************************************************************************************//

Future<void> handlePdJwtPayment(BuildContext context, payload) async {
  try {
    final merchantTxnId = generateMerchantTxnId();
    final mergedPayload = {
      "merchantTxnId": merchantTxnId,
      ...payload,
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };

    const encoder = JsonEncoder.withIndent('  ');
    print('handlePdJwtPayment payload:\n${encoder.convert(mergedPayload)}');

    final response = await http
        .post(
          Uri.parse(jwtPaymentUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(mergedPayload),
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
    } else {
      throw Exception('Payment request failed: ${response.statusCode}');
    }
  } catch (error) {
    print('Unexpected error: $error');
    throw Exception('Error: $error');
  }
}

////////////////////////////JWT Payment Handlers////////////////////////////////




///////////// Standing Instruction Payment Handlers//////////////////////////////

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
          "startDate": "20250801" ,
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

Future<void> handlePdFixedSIPayment(payload, BuildContext context) async {
  try {
    final merchantTxnId = generateMerchantTxnId();
    final finalPayload = {
      "merchantTxnId": merchantTxnId,
      ...payload,
      'standingInstruction': {
        'data': {
          'amount': payload['paymentData']['totalAmount'],
          'numberOfPayments': "12",
          'frequency': 'MONTHLY',
          'type': 'FIXED',
          'startDate': "20250801" 
        },
      },
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };
    
    print(finalPayload);
    final response = await http
        .post(
          Uri.parse(siPaymentUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(finalPayload),
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

Future<void> handlePdVariableSIPayment(
  cardNumber,
  String expiry,
  String cvv,
  String bill,
  BuildContext context,

  
) async {
  try {
    final merchantTxnId = generateMerchantTxnId();
    final finalPayload = {
      "merchantTxnId": merchantTxnId,
      "paymentData": {
        "totalAmount": bill,
        "txnCurrency": 'INR',
        'cardData': {
            'number': cardNumber.toString(),
            'expiryMonth': "12",
            'expiryYear': "30",
            'securityCode': cvv,
          },
      },
      'standingInstruction': {
        'data': {
          'maxAmount': bill,
          'numberOfPayments': "12",
          'frequency': 'MONTHLY',
          'type': 'VARIABLE',
        },
      },
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };
    
    print(finalPayload);
    final response = await http
        .post(
          Uri.parse(siPaymentUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(finalPayload),
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


///////////// Standing Instruction Payment Handlers//////////////////////////////

Future<void> handleAuthPayment(
  BuildContext context,
  Map<String, dynamic> paymentData,
) async {
  try {
    final merchantTxnId = generateMerchantTxnId();
    final payload = {
      "merchantTxnId": merchantTxnId,
      "captureTxn": false,
      "paymentData": paymentData['paymentData'],
      "riskData": paymentData['riskData'],
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };

    const encoder = JsonEncoder.withIndent('  ');
    print('handleAuthPayment payload:\n${encoder.convert(payload)}');
    final response = await http
        .post(
          Uri.parse(authUrl),
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
    } else {
      throw Exception('Payment request failed: ${response.statusCode}');
    }
  } catch (error) {
    print('Unexpected error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment failed: $error',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    throw Exception('Error: $error');
  }
}

Future<void> handlePdAuthPayment(
  BuildContext context,
  Map<String, dynamic> paymentData,
) async {
  try {
    final merchantTxnId = generateMerchantTxnId();
    final payload = {
      "merchantTxnId": merchantTxnId,
      "captureTxn": false,
      "paymentData": paymentData['paymentData'],
      "riskData": paymentData['riskData'],
      "merchantCallbackURL":
          "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
    };

    const encoder = JsonEncoder.withIndent('  ');
    print('handlePdAuthPayment payload:\n${encoder.convert(payload)}');

    // Validate payload before sending
    if (payload['paymentData'] == null || payload['riskData'] == null) {
      throw Exception('Invalid payment data: paymentData or riskData is null');
    }

    final response = await http
        .post(
          Uri.parse(authUrl),
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
    } else {
      throw Exception(
        'Payment request failed: ${response.statusCode} - ${response.body}',
      );
    }
  } catch (error) {
    print('Payment error: $error');
    throw Exception('Payment error: $error');
  }
}
