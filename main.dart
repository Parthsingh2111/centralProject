import 'package:centralproject/screen/flight_booking_provider.dart';
import 'package:centralproject/screen/airline_interface.dart';
import 'package:centralproject/screen/auth_merchant_product_interface.dart' show AuthCheckoutScreen, AuthMerchantProductInterface;
import 'package:centralproject/screen/bill_Payment.dart';
import 'package:centralproject/screen/home_screen.dart';
import 'package:centralproject/screen/merchant_product_interface.dart';
import 'package:centralproject/screen/pay_direct_merchant_Interface.dart';
import 'package:centralproject/screen/paycollect_screen.dart';
import 'package:centralproject/screen/paydirect_screen.dart';
import 'package:centralproject/screen/payment_provider.dart';
import 'package:centralproject/screen/pd_ott_subscription.dart';
import 'package:centralproject/screen/pd_standing_instruction.dart';
import 'package:centralproject/screen/services_screen.dart';
import 'package:centralproject/screen/ott_subscription_checkout.dart';
import 'package:centralproject/screen/standing_instruction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PayGlocalProdDemoApp());
}

class PayGlocalProdDemoApp extends StatelessWidget {
  const PayGlocalProdDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => FlightBookingProvider()), // Ensure this line is present
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PayGlocal Product Showcase',
        theme: ThemeData(
          primaryColor: const Color(0xFF1A3C34),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A3C34)),
            headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1A3C34)),
            bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF333333)),
            bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3C34),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/paycollect': (context) => const PayCollectScreen(),
          '/paycollect/jwt': (context) => const MerchantProductInterface(),
          '/ott_subscription_checkout': (context) => const OttSubscriptionCheckoutScreen(),
          '/paydirect/pd_merchant_interface' : (context) => PayDirectProductMerchantInterface(),
          '/paydirect': (context) => const PayDirectScreen(),
          '/services': (context) => const ServicesScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/paycollect/airline': (context) =>  AirlineBookingPage(),
          // '/Authcheckout': (context) => const AuthCheckoutScreen(),
          '/standing_instruction': (context) => const StandingInstructionScreen(),
          '/bill_payment': (context) => const BillPaymentScreen(),
          '/paydirect_checkout': (context) => PayDirectCheckoutScreen(),
          '/paydirect/si': (context) => PdStandingInstructionScreen(),
          '/pd_ott_subscription_checkout': (context) => PdOttSubscriptionCheckoutScreen(),
        },
      ),
    );
  }
}

