
import 'package:centralproject/screen/airline_interface.dart';
// import 'package:centralproject/screen/auth_merchant_product_interface.dart';
import 'package:centralproject/screen/bill_payment.dart';
import 'package:centralproject/screen/home_screen.dart';
import 'package:centralproject/screen/merchant_product_interface.dart';
import 'package:centralproject/screen/paycollect_screen.dart';
import 'package:centralproject/screen/paydirect_screen.dart';
import 'package:centralproject/screen/payment_provider.dart';
import 'package:centralproject/screen/pd_standing_instruction.dart';
import 'package:centralproject/screen/services_screen.dart';
import 'package:centralproject/screen/ott_subscription_checkout.dart';
import 'package:centralproject/screen/standing_instruction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for theme consistency
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
        ChangeNotifierProvider(create: (_) => AirlineBookingProvider()),
      ],
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'PayGlocal Product Showcase',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Color.fromARGB(255, 241, 244, 243)),
          ),
          primaryColor: const Color(0xFF1A3C34),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          textTheme: TextTheme(
            headlineLarge: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A3C34),
              
            ),
            
            headlineMedium: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A3C34),
            ),
            bodyLarge: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF333333),
            ),
            bodyMedium: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF666666),
            ),
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
          '/paycollect/jwt': (context) => const clothingMerchantInterface(isPayDirect: false),
           '/paydirect/jwt': (context) => const clothingMerchantInterface(isPayDirect: true),
          'paycollect/ott_subscription_checkout': (context) => const OttSubscriptionCheckoutScreen(isPayDirect: false),
          'paydirect/ott_subscription_checkout': (context) => const OttSubscriptionCheckoutScreen(isPayDirect: true),
          '/paydirect': (context) => const PayDirectScreen(),
          '/services': (context) => const ServicesScreen(),
          '/paydirect/airline': (context) => const AirlineBookingPage(isPayDirect: true),
          '/paycollect/airline': (context) => const AirlineBookingPage(),
          '/standing_instruction': (context) => const StandingInstructionScreen(),
          'paycollect/bill_payment': (context) => const BillPaymentScreen(isPayDirect: false),
          'paydirect/bill_payment': (context) => const BillPaymentScreen(isPayDirect: true),
          '/paydirect/si': (context) => PdStandingInstructionScreen(),
          // '/pd_ott_subscription_checkout': (context) => const PdOttSubscriptionCheckoutScreen(),
          '/checkout': (context) => const CheckoutScreen(),
        },
      ),
    );
  }
}
