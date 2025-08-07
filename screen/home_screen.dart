import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:convert';
import '../widgets/product_card.dart';
import '../widgets/animated_payload_overlay.dart';
import '../widgets/vertical_step_card.dart';
import '../widgets/animated_step_card.dart';
import '../widgets/shared_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _appBarFadeController;
  late Animation<double> _appBarFadeAnimation;

  @override
  void initState() {
    super.initState();
    // Fade animation for hero section and disclaimer
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCirc,
    );
    // Fade animation for app bar
    _appBarFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _appBarFadeAnimation = CurvedAnimation(
      parent: _appBarFadeController,
      curve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _appBarFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic sizing based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;
    final titleFontSize = isLargeScreen ? 30.0 : 24.0;
    final subtitleFontSize = isLargeScreen ? 18.0 : 16.0;
    final overlayPadding = isLargeScreen ? 12.0 : 8.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Mimics bg-gray-100
      appBar: SharedAppBar(
        title: 'PayGlocal Showcase',
        fadeAnimation: _appBarFadeAnimation,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                
                  Center(child: Text('Click "Visualize the Flow" to see the payment process')),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: EdgeInsets.all(overlayPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF3B82F6).withOpacity(0.05),
                                      const Color(0xFFE5E7EB).withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: CustomPaint(
                                  painter: WavePainter(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.payment,
                                        size: 24,
                                        color: Color(0xFF1E3A8A),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Seamless Payment Solutions for Merchants',
                                        style: GoogleFonts.poppins(
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1E3A8A),
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Fostering global commerce with PayGlocal',
                                  style: GoogleFonts.poppins(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF4B5563),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withOpacity(0.2),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Product Cards Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.count(
                        crossAxisCount: constraints.maxWidth > 800 ? 2 : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.4,
                        children: [
                          ProductCard(
                            title: 'PayCollect',
                            description: 'Ideal for non-PCI DSS certified merchants. Collect payments securely without handling card data.',
                            details: '''
**PayCollect Flow**  
Perfect for merchants who want to avoid PCI DSS compliance. Send basic transaction details to PayGlocal, and we handle payment data collection (including non-card methods) on our secure page.  

**Key Features:**  
- No PCI DSS certification required.  
- Supports one-time payments (standing instructions for cards not supported).  
- Provide customer details (e.g., shipping, profile) for risk assessment.  

**Sample API Request:**  
```json
{
  "merchantTxnId": "23AEE8CB6B62EE2AF07",
  "paymentData": {
    "totalAmount": "89",
    "txnCurrency": "INR"
  },
  "merchantCallbackURL": "https://api.prod.payglocal.in/gl/v1/payments/merchantCallback"
}
```  

**Endpoint:** `/gl/v1/payments/initiate/paycollect`  
**Benefits:** Simplifies payment collection, reduces compliance burden, supports multiple payment methods.
''',
                            route: '/paycollect',
                            icon: Icons.payment,
                            badge: 'Non-PCI DSS',
                            badgeColor: const Color(0xFF10B981),
                            benefits: [
                              'No PCI DSS compliance needed',
                              'Supports non-card payments',
                              'Simplified integration',
                            ],
                            largeText: 'Pay',
                            isPayCollect: true,
                          ),
                          ProductCard(
                            title: 'PayDirect',
                            description: 'For PCI DSS certified merchants. Securely process card payments directly on your platform.',
                            details: '''
**PayDirect Flow**  
Designed for PCI DSS certified merchants who handle card data on their platform. Send complete payment details, including card data, to PayGlocal for secure processing.  

**Key Features:**  
- Requires PCI DSS compliance for card data handling.  
- Collects billing address and device info on PayGlocal's page for risk assessment.  
- Supports streamlined checkout flows.  

**Sample API Request:**  
```json
{
  "merchantTxnId": "23AEE8CB6B62EE2AF07",
  "paymentData": {
    "totalAmount": "89",
    "txnCurrency": "INR",
    "cardData": {
      "number": "5132552222223470",
      "expiryMonth": "12",
      "expiryYear": "2030",
      "securityCode": "123"
    }
  },
  "merchantCallbackURL": "https://api.prod.payglocal.in/gl/v1/payments/merchantCallback"
}
```  

**Endpoint:** `/gl/v1/payments/initiate`  
**Benefits:** Enhanced security for card transactions, full control over checkout experience, PCI DSS compliant.  
*PCI DSS compliance ensures cardholder data security, as defined by the Payment Card Industry Security Standards Council.*
''',
                            route: '/paydirect',
                            icon: Icons.credit_card,
                            badge: 'PCI DSS Compliant',
                            badgeColor: const Color(0xFF3B82F6),
                            benefits: [
                              'PCI DSS compliant',
                              'Secure card processing',
                              'Streamlined checkout',
                            ],
                            largeText: 'Glocal',
                            isPayCollect: false,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  // Disclaimer with fade-in animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Explore additional services for advanced payment features like status tracking, refunds, captures, and more.',
                      style: GoogleFonts.notoSans(
                        fontSize: isLargeScreen ? 16.0 : 14.0,
                        color: const Color(0xFF4B5563),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Explore Additional Services Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          try {
                            Navigator.pushNamed(context, '/services');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Services route not found')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 2,
                        ),
                        child: Text(
                          'Explore Additional Services',
                          style: GoogleFonts.notoSans(
                            fontSize: isLargeScreen ? 14.0 : 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.9,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VerticalStep {
  final String title;
  final String description;
  final String pseudocode;
  final String? dataTitle;
  final String? dataContent;
  final IconData icon;
  final String? function;
  final String? endpoint;
  final String payloadLabel;
  final Color payloadColor;
  const _VerticalStep({
    required this.title,
    required this.description,
    required this.pseudocode,
    this.dataTitle,
    this.dataContent,
    required this.icon,
    this.function,
    this.endpoint,
    required this.payloadLabel,
    required this.payloadColor,
  });
}

class FlowVisualizerPage extends StatefulWidget {
  const FlowVisualizerPage({super.key});

  @override
  State<FlowVisualizerPage> createState() => _VerticalFlowVisualizerPageState();
}

class _VerticalFlowVisualizerPageState extends State<FlowVisualizerPage> with TickerProviderStateMixin {
  static const _primaryColor = Color(0xFF1E3A8A);
  static const _accentColor = Color(0xFF3B82F6);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _textColor = Color(0xFF4B5563);

  final List<_VerticalStep> _steps = [
    _VerticalStep(
      title: 'User Clicks Pay Button',
      description: 'The user initiates the payment by clicking the payment button.',
      pseudocode: 'onPayButtonClick() {\n    initiatePayment(payload)\n}',
      dataTitle: 'Payload',
      dataContent: '{\n  merchantTxnId: "23AEE8CB6B62EE2AF07",\n  paymentData: {\n    totalAmount: "89",\n    txnCurrency: "INR"\n  },\n  merchantCallbackURL: "https://api.prod.payglocal.in/gl/v1/payments/merchantCallback"\n}',
      icon: Icons.touch_app,
      function: 'onPayButtonClick()',
      payloadLabel: 'Payload',
      payloadColor: Colors.blueAccent,
    ),
    _VerticalStep(
      title: 'Payload Passed to SDK Function',
      description: 'The app passes the payload to the PayGlocal SDK function.',
      pseudocode: 'payment = initiateJwtPayment(payload)',
      dataTitle: 'Payload',
      dataContent: '{\n  merchantTxnId: "23AEE8CB6B62EE2AF07",\n  paymentData: { ... },\n  merchantCallbackURL: "..."\n}',
      icon: Icons.code,
      function: 'initiateJwtPayment(payload)',
      payloadLabel: 'Payload',
      payloadColor: Colors.blueAccent,
    ),
    _VerticalStep(
      title: 'SDK Receives and Forwards Payload',
      description: 'The SDK receives the payload and forwards it for processing.',
      pseudocode: 'async initiateJwtPayment(params) {\n  return initiateJwtPayment(params, this.config);\n}',
      dataTitle: 'Payload',
      dataContent: '{\n  merchantTxnId: "23AEE8CB6B62EE2AF07", ... }',
      icon: Icons.extension,
      function: 'initiateJwtPayment(params, config)',
      payloadLabel: 'Payload',
      payloadColor: Colors.blueAccent,
    ),
    _VerticalStep(
      title: 'SDK Validates Payload',
      description: 'SDK checks required fields and validates the schema.',
      pseudocode: 'validatePayload(payload, config) {\n  if (!payload.merchantTxnId || !payload.paymentData) throw Error;\n  // ...other checks\n}',
      dataTitle: 'Validation',
      dataContent: 'All required fields present and valid',
      icon: Icons.verified_user,
      function: 'validatePayload(payload, config)',
      payloadLabel: 'Payload',
      payloadColor: Colors.blueAccent,
    ),
    _VerticalStep(
      title: 'JWE Token Creation',
      description: 'SDK encrypts the payload using JWE (JSON Web Encryption).',
      pseudocode: 'jweToken = encryptWithJWE(payload, publicKey)\n// Uses RSA-OAEP-256, A128CBC-HS256',
      dataTitle: 'JWE Token',
      dataContent: 'eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiaWF0IjoiMTc1MzExMjg4MjUxMiIsImV4cCI6MzAwMDAwLCJraWQiOiJrSWQteUx0Umt5NDhYMkhxVzMwayIsImlzc3VlZC1ieSI6InRlc3RuZXdnY2MyNiJ9.N8cZ7FyWD6eDdkdimbxrPwiSYLQ4PjZOr_VFzhiijp2TPHja2zO2bda_WkxEqFb_kw0JZBkSJsnybmEvufbIIQea9CueIuz14TrY91dbPKHYy37iLbHmDp6N5migOaaC_65OKXetxBKF9y8ekLXPM0VWCAcoef5NaRM0pdJ4Fr_14Y2oITFr2186n1fYI2acDB9EzwCjc8M9h3NR-T7PbSpqEoqWfy3nu9PLK3qPSUdQlPMp2pQ5b2T4R5G4AZjZQ8kq104oYeaeHKrslUz3i-32axYUpWa733Q_mqApUmuA77vGSRAgPdJpjobIALHw3EYstMeXK8ed_tSkefLFWg.8HEU9vehR4yW3Gefh345xA.icKkmhqkoZuDqv5RmqU2gIHHy80feqtSUOa4OZMzunH_HIsf3Fww_odXsabwKF3JyxYq8__IggFIuEewDkm2rp3YjpgWvC_49qn-lxrfmUNZPOwgLcDiINuATYvnxun2VK9V9nkfqZHV-NUGJ1gmXgJfq1KmlTKHDGdS8ItqO6AEZ8Ypk5KJJEcHuE0BeqOEIQcmmkk0Pl0LsZ3vXeEWZyv5vmhKjXFVnH7zdTR-zjcAngFizk-lFvfeizEcRjEi.jxwSuAGR_fjyQ4_vDRhyRw',
      icon: Icons.lock,
      function: 'encryptWithJWE(payload, publicKey)',
      payloadLabel: 'JWE Token',
      payloadColor: Colors.orangeAccent,
    ),
    _VerticalStep(
      title: 'JWS Token Creation',
      description: 'SDK signs the JWE token using JWS (JSON Web Signature).',
      pseudocode: 'jwsToken = signWithJWS(jweToken, privateKey)\n// Uses RS256 (RSA-SHA256)',
      dataTitle: 'JWS Token',
      dataContent: 'eyJpc3N1ZWQtYnkiOiJ0ZXN0bmV3Z2NjMjYiLCJhbGciOiJSUzI1NiIsImtpZCI6ImtJZC12VTZlOGw2Yld0WEs4b09LIiwieC1nbC1tZXJjaGFudElkIjoidGVzdG5ld2djYzI2IiwieC1nbC1lbmMiOiJ0cnVlIiwiaXMtZGlnZXN0ZWQiOiJ0cnVlIn0.eyJkaWdlc3QiOiI5aXZtbzFFSDdBZ2ZBdUtzNWYvQ1BDMkdFbG01UjhxbkJsYjhnUWxGV3BNPSIsImRpZ2VzdEFsZ29yaXRobSI6IlNIQS0yNTYiLCJleHAiOjE3NTMxMTMxODI1MjksImlhdCI6IjE3NTMxMTI4ODI1MjkifQ.qF58y_ZfrL3GAppzAgS6H9c75DdNvfhgr9uS8GQUQ55fN8mkeY1FJ61GTBgIcCKeph8QPTKThPJWBCr53qYfadSx0pcHhcnAjudzBj_uldPdA1tVfxk3Zf-g4ZGqw9j9E5Jj1PPIQ3K3lLyvTZxgvY1J8IqlXUGyxOqOlwgFDbkNbOn4isGevi5CaR5w2cqBOfeIof_EMooBFpt_bZdKj1F9j34UZJ1ghgf1VVriZceT0cEgu0CdXuTFIwLTsjsldqm5zD6S6ZZ33ehbfK3UoRbCXusJ_YZT7cu4BGDYU9V6MrAuFERmpvbUfoCVLvOVMvhxAnrG6bv2Raox-V_p8w',
      icon: Icons.verified,
      function: 'signWithJWS(jweToken, privateKey)',
      payloadLabel: 'JWS Token',
      payloadColor: Colors.green,
    ),
    _VerticalStep(
      title: 'API Call to PayGlocal',
      description: 'SDK sends both JWE and JWS tokens to the PayGlocal API endpoint.',
      pseudocode: 'POST /gl/v1/payments/initiate/paycollect\nHeaders: {\n  x-gl-token-external: jwsToken,\n  Content-Type: text/plain\n}\nBody: jweToken',
      dataTitle: 'Headers & Body',
      dataContent: '{\n  x-gl-token-external: jwsToken,\n  Content-Type: text/plain\n}\nBody: jweToken',
      icon: Icons.cloud_upload,
      endpoint: '/gl/v1/payments/initiate/paycollect',
      payloadLabel: 'JWE + JWS',
      payloadColor: Colors.purple,
    ),
    _VerticalStep(
      title: 'PayGlocal Responds',
      description: 'PayGlocal processes the request and returns transaction details and redirect URL.',
      pseudocode: 'response = {\n  gid: "gl_o-962bd721e763755cdfss0I1X2",\n  status: "INPROGRESS",\n  message: "Transaction Created Successfully",\n  ...\n}',
      dataTitle: 'Response',
      dataContent: '{\n  gid: "gl_o-962bd721e763755cdfss0I1X2",\n  status: "INPROGRESS",\n  message: "Transaction Created Successfully",\n  data: {\n    redirectUrl: "https://api.uat.payglocal.in/gl/payflow-ui/...",\n    statusUrl: "https://api.uat.payglocal.in/gl/v1/payments/...",\n    merchantTxnId: "1753112882385976608"\n  },\n  errors: null\n}',
      icon: Icons.cloud_download,
      payloadLabel: 'Response',
      payloadColor: Colors.teal,
    ),
  ];

  int _currentStep = 0;
  late AnimationController _mainController;
  late Animation<double> _mainAnimation;
  final List<String> _buttonLabels = [
    'Click Pay Now and Send Payload',
    'Send Payload to SDK',
    'Send Payload for Validation',
    'Send Payload for JWE Creation',
    'Send JWE for JWS Creation',
    'Send JWE and JWS to Final API Call',
    'Send Request to PayGlocal API',
    '', // No button for response step
  ];

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _mainAnimation = CurvedAnimation(parent: _mainController, curve: Curves.easeInOut);
    _mainController.value = 1.0;
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep < _steps.length - 1) {
      _mainController.value = 0.0;
      setState(() {});
      await _mainController.forward();
      setState(() {
        _currentStep++;
      });
      _mainController.value = 1.0;
      // Auto-scroll to the new step
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollToCurrentStep();
    }
  }

  void _prevStep() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _mainController.value = 1.0;
      // Auto-scroll to the new step
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollToCurrentStep();
    }
  }

  void _scrollToCurrentStep() {
    final keyContext = _stepKeys[_currentStep].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  final List<GlobalKey> _stepKeys = List.generate(8, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;
    return Theme(
      data: ThemeData(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        appBar: SharedAppBar(
          title: 'PayGlocal Payment Flow',
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.asset(
                      'assets/images/code_flow.png',
                      fit: BoxFit.contain,
                      width: 600,
                      errorBuilder: (context, error, stackTrace) => const Text('Code flow image not found.'),
                    ),
                  ),
                  Text(
                    'How PayGlocal Payment Works',
                    style: GoogleFonts.poppins(
                      fontSize: isLargeScreen ? 32 : 22,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A dynamic, step-by-step visual journey from user action to secure payment.',
                    style: GoogleFonts.poppins(
                      fontSize: isLargeScreen ? 16 : 13,
                      color: _textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildStepByStepFlow(isLargeScreen),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepByStepFlow(bool isLargeScreen) {
    return Column(
      children: [
        ...List.generate(_currentStep + 1, (i) => Column(
          key: _stepKeys[i],
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: AnimatedStepCard(
                key: ValueKey('step-$i'),
                step: _steps[i],
                isActive: i == _currentStep,
                isLargeScreen: isLargeScreen,
                showNext: i == _currentStep && i < _steps.length - 1 && _buttonLabels[i].isNotEmpty,
                showBack: i == _currentStep && i > 0,
                onNext: _nextStep,
                onBack: _prevStep,
                buttonLabel: _buttonLabels[i],
                showPayloadAnim: i == _currentStep,
                payloadLabel: _steps[i].payloadLabel,
                payloadColor: _steps[i].payloadColor,
              ),
            ),
            if (i < _currentStep) const SizedBox(height: 32),
          ],
        )),
      ],
    );
  }
}





class _VerticalFlowArrowPainter extends CustomPainter {
  final int step;
  final double t;
  final int totalSteps;
  final double cardHeight;
  final double verticalSpacing;
  _VerticalFlowArrowPainter(this.step, this.t, this.totalSteps, this.cardHeight, this.verticalSpacing);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    for (int i = 0; i < totalSteps - 1; i++) {
      final y1 = 40.0 + i * (cardHeight + verticalSpacing) + cardHeight / 2;
      final y2 = 40.0 + (i + 1) * (cardHeight + verticalSpacing) + cardHeight / 2;
      if (step == i + 1) {
        final p1 = Offset(size.width / 2, y1);
        final p2 = Offset(size.width / 2, y1 + (y2 - y1) * t);
        canvas.drawLine(p1, p2, paint);
        if (t > 0.95) {
          final arrowSize = 12.0;
          final arrowP = Offset(size.width / 2, y2);
          final path = Path();
          path.moveTo(arrowP.dx, arrowP.dy);
          path.lineTo(arrowP.dx - arrowSize, arrowP.dy - arrowSize);
          path.moveTo(arrowP.dx, arrowP.dy);
          path.lineTo(arrowP.dx + arrowSize, arrowP.dy - arrowSize);
          canvas.drawPath(path, paint);
        }
      } else if (step > i + 1) {
        canvas.drawLine(
          Offset(size.width / 2, y1),
          Offset(size.width / 2, y2),
          paint,
        );
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



class _PayloadStructureModal extends StatefulWidget {
  @override
  State<_PayloadStructureModal> createState() => _PayloadStructureModalState();
}

class _PayloadStructureModalState extends State<_PayloadStructureModal> {
  final List<_MerchantPayload> _payloads = [
  _MerchantPayload(
    name: 'E-commerce / Retail Merchant',
    icon: Icons.shopping_cart,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "1753423017399291277",
      "merchantId": "MERCH456",
      "merchantCallbackURL": "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
      "paymentData": {
        "totalAmount": "2499.00",
        "txnCurrency": "INR",
        "cardData": {
          "number": "4242424242424242",
          "expiryMonth": "12",
          "expiryYear": "2030",
          "securityCode": "123",
          "type": "visa"
        }
      },
      "riskData": {
        "orderData": [
          {
            "productDescription": "Laptop",
            "productSKU": "LAP123",
            "productType": "Electronics",
            "itemUnitPrice": "2499.00",
            "itemQuantity": "1"
          }
        ],
        "shippingData": {
          "firstName": "Mock",
          "lastName": "Trader",
          "addressStreet1": "Rowley street 1",
          "addressStreet2": "Punctuality lane",
          "addressCity": "Bangalore",
          "addressState": "Karnataka",
          "addressStateCode": "KA",
          "addressPostalCode": "560094",
          "addressCountry": "IN",
          "emailId": "mocktrader@myemail.com",
          "phoneNumber": "+919191919191"
        }
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'Hotel / Lodging Merchant',
    icon: Icons.hotel,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "TXN-LODGING-789",
      "merchantId": "MERCH789",
      "merchantUniqueId": "HOTEL456",
      "merchantCallbackURL": "https://merchant.com/hotel-callback",
      "paymentData": {
        "totalAmount": "8000.00",
        "txnCurrency": "INR",
        "cardData": {
          "number": "4111111111111111",
          "expiryMonth": "12",
          "expiryYear": "2026",
          "securityCode": "789",
          "type": "visa"
        }
      },
      "riskData": {
        "lodgingData": [
          {
            "checkInDate": "20250801",
            "checkOutDate": "20250803",
            "lodgingType": "Hotel",
            "lodgingName": "Sunset Resort",
            "city": "Goa",
            "country": "IN",
            "bookingPersonFirstName": "John",
            "bookingPersonLastName": "Doe",
            "bookingPersonEmailId": "john.doe@example.com",
            "bookingPersonCallingCode": "+91",
            "bookingPersonPhoneNumber": "9876543210",
            "rooms": [
              {
                "numberOfGuests": "2",
                "roomType": "Deluxe",
                "roomPrice": "4000",
                "numberOfNights": "2",
                "guestFirstName": "John",
                "guestLastName": "Doe",
                "guestEmail": "john.doe@example.com"
              }
            ]
          }
        ]
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'Airline / Airways Merchant',
    icon: Icons.airplanemode_active,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "1753422960093968920",
      "merchantId": "MERCH101",
      "merchantCallbackURL": "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
      "paymentData": {
        "totalAmount": "1499.00",
        "txnCurrency": "INR",
        "cardData": {
          "number": "4242424242424242",
          "expiryMonth": "12",
          "expiryYear": "2030",
          "securityCode": "123",
          "type": "visa"
        }
      },
      "riskData": {
        "flightData": [
          {
            "ticketNumber": "FL123456",
            "reservationDate": "20250810",
            "journeyType": "ONEWAY",
            "legData": [
              {
                "routeId": "1",
                "legId": "1",
                "flightNumber": "AI101",
                "departureDate": "20250815T10:00:00Z",
                "departureAirportCode": "BLR",
                "departureCity": "Bangalore",
                "departureCountry": "IN",
                "arrivalDate": "20250815T12:00:00Z",
                "arrivalAirportCode": "DEL",
                "arrivalCity": "Delhi",
                "arrivalCountry": "IN",
                "carrierCode": "AI",
                "carrierName": "Air India",
                "serviceClass": "Economy"
              }
            ],
            "passengerData": [
              {
                "firstName": "Mock",
                "lastName": "Trader",
                "dateOfBirth": "19900101",
                "email": "mocktrader@myemail.com",
                "passportCountry": "IN",
                "referenceNumber": "PASS123"
              }
            ]
          }
        ]
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'Train Booking Merchant',
    icon: Icons.train,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "TXN-TRAIN-321",
      "merchantId": "MERCH202",
      "merchantUniqueId": "TRAIN789",
      "merchantCallbackURL": "https://merchant.com/train-callback",
      "paymentData": {
        "totalAmount": "1500.00",
        "txnCurrency": "INR",
        "cardData": {
          "number": "4111111111111111",
          "expiryMonth": "09",
          "expiryYear": "2025",
          "securityCode": "456",
          "type": "visa"
        }
      },
      "riskData": {
        "trainData": [
          {
            "ticketNumber": "IRCTC12345",
            "reservationDate": "20250810",
            "legData": [
              {
                "routeId": "1",
                "legId": "1",
                "trainNumber": "12951",
                "departureCity": "Mumbai",
                "departureCountry": "IN",
                "arrivalCity": "Delhi",
                "arrivalCountry": "IN",
                "departureDate": "20250815T20:00:00Z",
                "arrivalDate": "20250816T06:00:00Z"
              }
            ],
            "passengerData": [
              {
                "firstName": "Amit",
                "lastName": "Sharma",
                "dateOfBirth": "19900101",
                "email": "amit.sharma@example.com",
                "passportCountry": "IN",
                "referenceNumber": "PASS456"
              }
            ]
          }
        ]
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'Bus Booking Merchant',
    icon: Icons.directions_bus,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "TXN-BUS-111",
      "merchantId": "MERCH303",
      "merchantUniqueId": "BUS123",
      "merchantCallbackURL": "https://merchant.com/bus-callback",
      "paymentData": {
        "totalAmount": "600.00",
        "txnCurrency": "INR",
        "cardData": {
          "number": "4111111111111111",
          "expiryMonth": "11",
          "expiryYear": "2026",
          "securityCode": "654",
          "type": "visa"
        }
      },
      "riskData": {
        "busData": [
          {
            "ticketNumber": "BUS78901",
            "reservationDate": "20250818",
            "legData": [
              {
                "routeId": "1",
                "legId": "1",
                "busNumber": "KA01AB1234",
                "departureCity": "Bangalore",
                "departureCountry": "IN",
                "arrivalCity": "Chennai",
                "arrivalCountry": "IN",
                "departureDate": "20250820T08:00:00Z",
                "arrivalDate": "20250820T14:00:00Z"
              }
            ],
            "passengerData": [
              {
                "firstName": "Priya",
                "lastName": "Iyer",
                "dateOfBirth": "19950610",
                "email": "priya.iyer@example.com",
                "passportCountry": "IN",
                "referenceNumber": "PASS789"
              }
            ]
          }
        ]
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'Ship / Cruise Merchant',
    icon: Icons.directions_boat,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "TXN-SHIP-222",
      "merchantId": "MERCH606",
      "merchantUniqueId": "SHIP123",
      "merchantCallbackURL": "https://merchant.com/ship-callback",
      "paymentData": {
        "totalAmount": "5000.00",
        "txnCurrency": "USD",
        "cardData": {
          "number": "4111111111111111",
          "expiryMonth": "06",
          "expiryYear": "2028",
          "securityCode": "321",
          "type": "visa"
        }
      },
      "riskData": {
        "shipData": [
          {
            "ticketNumber": "SHIP12345",
            "reservationDate": "20250805",
            "legData": [
              {
                "routeId": "1",
                "legId": "1",
                "shipNumber": "CRZ789",
                "departureCity": "Miami",
                "departureCountry": "US",
                "arrivalCity": "Nassau",
                "arrivalCountry": "BS",
                "departureDate": "20250806T09:00:00Z",
                "arrivalDate": "20250807T09:00:00Z"
              }
            ],
            "passengerData": [
              {
                "firstName": "Suresh",
                "lastName": "Nair",
                "dateOfBirth": "19850815",
                "email": "suresh.nair@example.com",
                "passportCountry": "US",
                "referenceNumber": "PASS234"
              }
            ]
          }
        ]
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'Cab Aggregator Merchant',
    icon: Icons.local_taxi,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "TXN-CAB-456",
      "merchantId": "MERCH404",
      "merchantUniqueId": "CABMER456",
      "merchantCallbackURL": "https://merchant.com/cab-callback",
      "paymentData": {
        "totalAmount": "350.00",
        "txnCurrency": "INR",
        "cardData": {
          "number": "4111111111111111",
          "expiryMonth": "10",
          "expiryYear": "2027",
          "securityCode": "112",
          "type": "visa"
        }
      },
      "riskData": {
        "cabData": [
          {
            "reservationDate": "20250825",
            "legData": [
              {
                "routeId": "1",
                "legId": "1",
                "pickupDate": "20250825T09:30:00Z",
                "departureCity": "Bangalore",
                "departureCountry": "IN",
                "arrivalCity": "Mumbai",
                "arrivalCountry": "IN"
              }
            ],
            "passengerData": [
              {
                "firstName": "Ravi",
                "lastName": "Verma",
                "dateOfBirth": "19901111",
                "email": "ravi.verma@example.com",
                "passportCountry": "IN",
                "referenceNumber": "PASS101"
              }
            ]
          }
        ]
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'Customer-Focused Merchant',
    icon: Icons.person,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "1753423174528",
      "merchantId": "MERCH505",
      "merchantCallbackURL": "https://api.uat.payglocal.in/gl/v1/payments/merchantCallback",
      "paymentData": {
        "totalAmount": "649.00",
        "txnCurrency": "INR",
        "cardData": {
          "number": "4242424242424242",
          "expiryMonth": "12",
          "expiryYear": "2030",
          "securityCode": "123",
          "type": "visa"
        }
      },
      "riskData": {
        "customerData": {
          "customerAccountType": "SUBSCRIPTION",
          "customerSuccessOrderCount": "5",
          "customerAccountCreationDate": "20240101",
          "merchantAssignedCustomerId": "CUST123"
        }
      }
    }''')),
  ),
  _MerchantPayload(
    name: 'General Merchant',
    icon: Icons.store,
    pretty: _prettyJson(jsonDecode(r'''{
      "merchantTxnId": "23AEE8CB6B62EE2AF07",
      "merchantId": "MERCH123",
      "merchantUniqueId": "IFNN939494NJFJ",
      "merchantCallbackURL": "https://www.merchanturl.com/callback",
      "paymentData": {
        "totalAmount": "1000.00",
        "txnCurrency": "INR",
        "tokenData": {
          "number": "TOKEN123",
          "expiryMonth": "12",
          "expiryYear": "2030",
          "cryptogram": "CRYPT456",
          "firstSix": "424242",
          "lastFour": "4242",
          "cardBrand": "VISA",
          "cardCountryCode": "IN",
          "cardIssuerName": "HDFC Bank",
          "cardType": "CREDIT",
          "cardCategory": "PLATINUM"
        }
      }
    }''')),
  ),
];

  String _search = '';
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    final filtered = _payloads
        .where((p) => p.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search merchant type...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: filtered.isNotEmpty
                  ? filtered.indexWhere((p) => p.name == _payloads[_selected].name)
                  : 0,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              decoration: InputDecoration(
                labelText: 'Merchant Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              items: filtered.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value;
                return DropdownMenuItem<int>(
                  value: idx,
                  child: Row(
                    children: [
                      Icon(p.icon, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(p.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (idx) {
                if (idx != null) {
                  final selectedPayload = filtered[idx];
                  final realIdx = _payloads.indexWhere((p) => p.name == selectedPayload.name);
                  setState(() => _selected = realIdx);
                }
              },
            ),
            const SizedBox(height: 16),
            Text('Payload', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SelectableText(
                    _payloads[_selected].pretty,
                    style: GoogleFonts.robotoMono(fontSize: 15, color: Colors.teal.shade900),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _payloads[_selected].pretty));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payload copied!')));
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _MerchantPayload {
  final String name;
  final IconData icon;
  final String pretty;
  _MerchantPayload({required this.name, required this.icon, required this.pretty});
}

// Pretty JSON helpers and payloads
String _prettyJson(Map<String, dynamic> json) => const JsonEncoder.withIndent('  ').convert(json);
