
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
import 'package:centralproject/screen/visualization_screen.dart';
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
          '/visualization': (context) => const VisualizationScreen(),
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






// now the the thing i tell you 
// in thw cisualization page 
// the cards sound be names asa
// 1) Merchant initiated Payment
// 2) PayGlocal SDK Validates Payload
// 3) PayGlocal SDK generated JWE token
// 4)  PayGlocal SDK generated JWs token
// 5) Final Api Initiation 
// 6) Transection Confimation or     error Response

// now, mate the card shuch the when use haver on it it shoud make user to click in it
// 1) when the user click on card1) Merchant initiated Payment
// it shouble see this data and beautiful explanation of it so that the developer can understant what is happening, when user click in paynow the payload is passed to the fuction of payglocal sdk
//     const payload = {
//       merchantTxnId,
//       paymentData,
//       merchantCallbackURL
//     };
//     initiateJwtPayment(payload);

//     2)when used click on second card
//  async initiateJwtPayment(params) {
//     return initiateJwtPayment(params, this.config);
//   }

// explain that the sdk received the payload
// then it validated the payload

  
// validateRequiredFields(
//   {
//     merchantTxnId,
//     paymentData,
//     merchantCallbackURL,
//     'paymentData.totalAmount': paymentData?.totalAmount,
//     'paymentData.txnCurrency': paymentData?.txnCurrency,
//     'paymentData.cardData': paymentData?.cardData,
//     'paymentData.cardData.number': paymentData?.cardData?.number,
//     'paymentData.cardData.expiryMonth': paymentData?.cardData?.expiryMonth,
//     'paymentData.cardData.expiryYear': paymentData?.cardData?.expiryYear,
//     'paymentData.cardData.securityCode': paymentData?.cardData?.securityCode,
//   },
//   [
//     'merchantTxnId',
//     'paymentData',
//     'merchantCallbackURL',
//     'paymentData.totalAmount',
//     'paymentData.txnCurrency',
//     'paymentData.cardData',
//     'paymentData.cardData.number',
//     'paymentData.cardData.expiryMonth',
//     'paymentData.cardData.expiryYear',
//     'paymentData.cardData.securityCode',
//   ]

// );explain the validation in in some inovative way rather then showing the code,
// 3)when used click on third card then show
// (this function is called )
//   const jwe = await generateJWE(payload, config);

// token creation code

// async function generateJWE(payload, config) {

// async function generateJWE(payload, config) {
//   const iat = Date.now();
//   const publicKey = await pemToKey(config.payglocalPublicKey, false);
//   const payloadStr = JSON.stringify(payload);
// and tell that payload is paased in this function
//   return await new jose.CompactEncrypt(new TextEncoder().encode(payloadStr))
//     .setProtectedHeader({
//       alg: 'RSA-OAEP-256',
//       enc: 'A128CBC-HS256',
//       iat: iat.toString(),
//       exp: 300000,
//       kid: config.publicKeyId,
//       'issued-by': config.merchantId,
//     })
//     .encrypt(publicKey);
// }

// explain this code in a clean and incovative way so that user or merchant or developer can understant all the part , header, also in prover can clean way so that  while use the sdk  do not cause any errors, or doubts.

// 4)when used click on forth card then show
// (this function is called )
// const jws = await generateJWS(jwe, config);

// token creation code

// async function generateJWE(payload, config) {

// async function generateJWE(payload, config) {
//   const iat = Date.now();
//   const publicKey = await pemToKey(config.payglocalPublicKey, false);
//   const payloadStr = JSON.stringify(payload);
// and tell that jwe  is paased after make digest of it in this function
//   return
// * @param {string} toDigest - The input string to hash (can be JWE or payloadPath)
//  * @param {Object} config - Configuration object
//  * @returns {Promise<string>} JWS token
//  */

// async function generateJWS(toDigest, config) {
//   const iat = Date.now();

//   const digest = crypto.createHash('sha256').update(toDigest).digest('base64');
//   const digestObject = {
//     digest,
//     digestAlgorithm: 'SHA-256',
//     exp: iat + 300000,
//     iat: iat.toString(),
//   };

//   const privateKey = await pemToKey(config.merchantPrivateKey, true);

//   return await new jose.SignJWT(digestObject)
//     .setProtectedHeader({
//       'issued-by': config.merchantId,
//       alg: 'RS256',
//       kid: config.privateKeyId,
//       'x-gl-merchantId': config.merchantId,
//       'x-gl-enc': 'true',
//       'is-digested': 'true',
//     })
//     .sign(privateKey);
// }

// explain this code in a clean and incovative way so that user or merchant or developer can understant all the part , header, also in prover can clean way so that  while use the sdk  do not cause any errors, or doubts.


// 5) when used click on 5th card then show
// for paycollect
// response = await post(
//       `${config.baseUrl}/gl/v1/payments/initiate/paycollect`,
//       jwe,
//       {
//         'Content-Type': 'text/plain',
//         'x-gl-token-external': jws,
//       }
//     );
// for pay direct
// response = await post(
//       `${config.baseUrl}/gl/v1/payments/initiate`,
//       jwe,
//       {
//         'Content-Type': 'text/plain',
//         'x-gl-token-external': jws,
//       }
//     );
// and explane all the part in detail what does it mean what to sed in header and body , in a very clean and inovative way so that the user, develop, merchant can undersant it properly.


// 6) when used click on 6th card then show
// so then the response they will get
// in success

