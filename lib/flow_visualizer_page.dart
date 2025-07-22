import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class FlowVisualizerPage extends StatefulWidget {
  const FlowVisualizerPage({super.key});

  @override
  State<FlowVisualizerPage> createState() => _FlowVisualizerPageState();
}

class _FlowVisualizerPageState extends State<FlowVisualizerPage>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _encryptionController;
  late AnimationController _dataFlowController;
  late AnimationController _pulseController;
  
  // Animations
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _encryptionProgress;
  late Animation<double> _dataFlow;
  late Animation<double> _pulse;
  
  // State Management
  int _currentStep = 0;
  bool _isAnimating = false;
  bool _showEncryptionDetail = false;
  
  // Visual Constants
  static const _primaryGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const _successGradient = LinearGradient(
    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const _encryptionGradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final List<FlowStep> _steps = [
    FlowStep(
      id: 'user_action',
      title: '👤 User Interaction',
      subtitle: 'Payment Initiation',
      description: 'User clicks "Pay Now" button to start the payment process',
      details: '''
🎯 **What Happens:**
• User selects payment method and clicks "Pay Now"
• Application captures payment details (amount, currency, etc.)
• User interface triggers payment SDK initialization

💡 **Technical Flow:**
• Frontend event handler captures user action
• Payment data is prepared for processing
• SDK initialization begins
      ''',
      code: '''
// Generic Payment Initiation
function handlePaymentClick() {
  const paymentData = {
    amount: userSelectedAmount,
    currency: userSelectedCurrency,
    transactionId: generateUniqueId(),
    merchantInfo: getMerchantConfig()
  };
  
  // Start payment flow
  initiatePayment(paymentData);
}
      ''',
      icon: Icons.touch_app,
      color: Colors.blue,
    ),
    
    FlowStep(
      id: 'payload_prep',
      title: '📦 Data Preparation',
      subtitle: 'Payload Assembly',
      description: 'Application assembles payment data into a structured payload',
      details: '''
🔧 **Payload Structure:**
• Transaction ID (unique identifier)
• Payment amount and currency
• Merchant configuration details
• Callback URLs for success/failure
• User session information

🛡️ **Security Preparation:**
• Input validation and sanitization
• Required field verification
• Data format standardization
      ''',
      code: '''
// Payload Assembly
function assemblePayload(paymentData) {
  return {
    transactionId: paymentData.transactionId,
    amount: validateAmount(paymentData.amount),
    currency: validateCurrency(paymentData.currency),
    merchantId: config.merchantId,
    callbackUrl: config.callbackUrl,
    metadata: {
      timestamp: Date.now(),
      version: SDK_VERSION
    }
  };
}
      ''',
      icon: Icons.inventory_2,
      color: Colors.orange,
    ),
    
    FlowStep(
      id: 'validation',
      title: '✅ Data Validation',
      subtitle: 'Security Checks',
      description: 'SDK validates payload structure and required fields',
      details: '''
🔍 **Validation Process:**
• Schema validation against predefined structure
• Required field presence verification
• Data type and format checking
• Business rule validation (amount limits, etc.)

⚠️ **Error Handling:**
• Descriptive error messages for developers
• Graceful failure with user-friendly messages
• Logging for debugging purposes
      ''',
      code: '''
// Data Validation
function validatePayload(payload) {
  const requiredFields = [
    'transactionId', 'amount', 'currency', 
    'merchantId', 'callbackUrl'
  ];
  
  // Check required fields
  for (const field of requiredFields) {
    if (!payload[field]) {
      throw new ValidationError(`Missing required field: ${field}`);
    }
  }
  
  // Validate data types and formats
  validateAmount(payload.amount);
  validateCurrency(payload.currency);
  validateUrl(payload.callbackUrl);
  
  return true;
}
      ''',
      icon: Icons.verified_user,
      color: Colors.green,
    ),
    
    FlowStep(
      id: 'encryption',
      title: '🔐 End-to-End Encryption',
      subtitle: 'Data Security Layer',
      description: 'Payload is encrypted using industry-standard algorithms',
      details: '''
🛡️ **Encryption Process:**
• **Step 1:** Generate symmetric encryption key
• **Step 2:** Encrypt payload with AES-256
• **Step 3:** Encrypt symmetric key with RSA public key
• **Step 4:** Create encrypted token (JWE format)

🔑 **Security Features:**
• RSA-OAEP-256 for key encryption
• AES-256-CBC for content encryption
• Timestamp and expiration included
• Tamper-proof digital envelope
      ''',
      code: '''
// Encryption Process
async function encryptPayload(payload, publicKey) {
  // Generate random symmetric key
  const symmetricKey = generateRandomKey(256);
  
  // Encrypt payload with AES
  const encryptedPayload = aesEncrypt(payload, symmetricKey);
  
  // Encrypt symmetric key with RSA public key
  const encryptedKey = rsaEncrypt(symmetricKey, publicKey);
  
  // Create JWE token
  const jweToken = createJWE({
    header: {
      algorithm: 'RSA-OAEP-256',
      encryption: 'A256CBC-HS512',
      timestamp: Date.now(),
      expiration: Date.now() + 300000
    },
    encryptedKey: encryptedKey,
    encryptedPayload: encryptedPayload
  });
  
  return jweToken;
}
      ''',
      icon: Icons.security,
      color: Colors.purple,
    ),
    
    FlowStep(
      id: 'signing',
      title: '✍️ Digital Signature',
      subtitle: 'Authentication Layer',
      description: 'Encrypted token is digitally signed for authenticity',
      details: '''
🖋️ **Digital Signature Process:**
• Create SHA-256 hash of encrypted token
• Sign hash with merchant's private key
• Generate JWS (JSON Web Signature) token
• Include merchant identification headers

🔒 **Authentication Benefits:**
• Proves message origin (non-repudiation)
• Ensures message integrity
• Prevents tampering during transmission
• Enables server-side verification
      ''',
      code: '''
// Digital Signing Process
async function signEncryptedToken(encryptedToken, privateKey) {
  // Create hash of encrypted token
  const tokenHash = sha256Hash(encryptedToken);
  
  // Sign the hash with private key
  const signature = rsaSign(tokenHash, privateKey, 'RS256');
  
  // Create JWS token
  const jwsToken = createJWS({
    header: {
      algorithm: 'RS256',
      keyId: merchant.keyId,
      merchantId: merchant.id,
      isEncrypted: true,
      isDigested: true
    },
    payload: {
      digest: tokenHash,
      digestAlgorithm: 'SHA-256',
      timestamp: Date.now(),
      expiration: Date.now() + 300000
    },
    signature: signature
  });
  
  return jwsToken;
}
      ''',
      icon: Icons.draw,
      color: Colors.indigo,
    ),
    
    FlowStep(
      id: 'api_request',
      title: '🚀 Secure API Call',
      subtitle: 'Server Communication',
      description: 'Signed and encrypted data is sent to payment gateway',
      details: '''
🌐 **API Request Structure:**
• **Method:** POST to payment gateway endpoint
• **Headers:** 
  - Authentication token (JWS)
  - Content-Type: application/json
  - API version and client info
• **Body:** Encrypted payload (JWE token)

🔐 **Security in Transit:**
• HTTPS/TLS encryption for network layer
• Additional payload encryption (defense in depth)
• Request signing for authenticity
• Timeout and retry mechanisms
      ''',
      code: '''
// Secure API Request
async function sendPaymentRequest(encryptedToken, signatureToken) {
  const apiEndpoint = `${config.gatewayUrl}/payments/initiate`;
  
  const requestOptions = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${signatureToken}`,
      'X-API-Version': '2.0',
      'X-Client-SDK': 'PaymentSDK/1.0',
      'X-Request-ID': generateRequestId()
    },
    body: encryptedToken,
    timeout: 30000,  // 30 second timeout
    retries: 3       // Retry on failure
  };
  
  try {
    const response = await fetch(apiEndpoint, requestOptions);
    return await handleApiResponse(response);
  } catch (error) {
    throw new ApiError(`Payment request failed: ${error.message}`);
  }
}
      ''',
      icon: Icons.cloud_upload,
      color: Colors.teal,
    ),
    
    FlowStep(
      id: 'server_response',
      title: '📨 Gateway Response',
      subtitle: 'Transaction Processing',
      description: 'Payment gateway processes request and returns transaction details',
      details: '''
🎯 **Server Processing:**
• Verifies digital signature authenticity
• Decrypts payload using private key
• Validates merchant credentials and permissions
• Creates transaction record in database
• Generates unique transaction ID

📋 **Response Data:**
• Global transaction ID (for tracking)
• Transaction status (PENDING, SUCCESS, FAILED)
• Payment redirect URL (for user completion)
• Status check URL (for polling updates)
• Error details (if any issues occurred)
      ''',
      code: '''
// Gateway Response Handling
function handleGatewayResponse(response) {
  const responseData = {
    transactionId: response.globalTransactionId,
    status: response.transactionStatus,
    message: response.statusMessage,
    timestamp: response.processedAt,
    data: {
      redirectUrl: response.paymentUrl,
      statusCheckUrl: response.statusUrl,
      merchantTransactionId: response.merchantTxnId,
      expiresAt: response.expirationTime
    },
    errors: response.errorDetails || null
  };
  
  // Handle different response scenarios
  switch (responseData.status) {
    case 'PENDING':
      redirectUserToPayment(responseData.data.redirectUrl);
      break;
    case 'SUCCESS':
      handlePaymentSuccess(responseData);
      break;
    case 'FAILED':
      handlePaymentFailure(responseData.errors);
      break;
    default:
      handleUnknownStatus(responseData);
  }
  
  return responseData;
}
      ''',
      icon: Icons.receipt_long,
      color: Colors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startIntroAnimation();
  }

  void _initializeAnimations() {
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Encryption animation controller
    _encryptionController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    // Data flow animation controller
    _dataFlowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create animations
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );
    
    _slideUp = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutCubic),
    );
    
    _encryptionProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _encryptionController, curve: Curves.easeInOut),
    );
    
    _dataFlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dataFlowController, curve: Curves.easeInOut),
    );
    
    _pulse = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );

    // Start continuous animations
    _particleController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _startIntroAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _mainController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _encryptionController.dispose();
    _dataFlowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep < _steps.length - 1 && !_isAnimating) {
      setState(() {
        _isAnimating = true;
      });
      
      // Animate to next step
      await _dataFlowController.forward();
      
      setState(() {
        _currentStep++;
        _isAnimating = false;
      });
      
      _dataFlowController.reset();
      
      // Special animation for encryption step
      if (_steps[_currentStep].id == 'encryption') {
        _encryptionController.forward();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0 && !_isAnimating) {
      setState(() {
        _currentStep--;
      });
      _encryptionController.reset();
    }
  }

  void _resetAnimation() {
    setState(() {
      _currentStep = 0;
      _isAnimating = false;
    });
    _mainController.reset();
    _encryptionController.reset();
    _dataFlowController.reset();
    _startIntroAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMainContent(),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _fadeIn,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideUp.value),
          child: Opacity(
            opacity: _fadeIn.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: _primaryGradient,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      '🔐 End-to-End Encryption Flow',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Interactive Payment Security Visualization',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeIn, _dataFlow, _encryptionProgress]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value,
          child: Stack(
            children: [
              // Background particles
              CustomPaint(
                painter: ParticlePainter(_particleController.value),
                size: Size.infinite,
              ),
              
              // Main content
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProgressIndicator(),
                    const SizedBox(height: 32),
                    _buildCurrentStepCard(),
                    const SizedBox(height: 24),
                    if (_steps[_currentStep].id == 'encryption')
                      _buildEncryptionVisualization(),
                  ],
                ),
              ),
              
              // Data flow overlay
              if (_isAnimating)
                CustomPaint(
                  painter: DataFlowPainter(_dataFlow.value),
                  size: Size.infinite,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 80,
      child: Row(
        children: List.generate(_steps.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: isCompleted || isActive
                          ? _successGradient
                          : LinearGradient(
                              colors: [Colors.grey.shade800, Colors.grey.shade700],
                            ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isActive ? Colors.white : Colors.white54,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepCard() {
    final step = _steps[_currentStep];
    
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Transform.scale(
          scale: _currentStep == 3 ? _pulse.value : 1.0, // Pulse on encryption step
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  step.color.withOpacity(0.1),
                  step.color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: step.color.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: step.color.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [step.color, step.color.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          step.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              step.subtitle,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    step.description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white90,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildExpandableSection('Details', step.details),
                  const SizedBox(height: 16),
                  _buildExpandableSection('Code Example', step.code),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandableSection(String title, String content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white70,
        children: [
          SelectableText(
            content,
            style: GoogleFonts.robotoMono(
              fontSize: 14,
              color: Colors.white90,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptionVisualization() {
    return AnimatedBuilder(
      animation: _encryptionProgress,
      builder: (context, child) {
        return Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: _encryptionGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: CustomPaint(
            painter: EncryptionVisualizationPainter(_encryptionProgress.value),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.skip_previous,
            label: 'Previous',
            onPressed: _currentStep > 0 ? _previousStep : null,
          ),
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            onPressed: _resetAnimation,
          ),
          _buildControlButton(
            icon: Icons.skip_next,
            label: 'Next',
            onPressed: _currentStep < _steps.length - 1 ? _nextStep : null,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return AnimatedBuilder(
      animation: _fadeIn,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: onPressed != null ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Data Models
class FlowStep {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String details;
  final String code;
  final IconData icon;
  final Color color;

  FlowStep({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.details,
    required this.code,
    required this.icon,
    required this.color,
  });
}

// Custom Painters
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x = (i * 37.0 + animationValue * 100) % size.width;
      final y = (i * 23.0 + animationValue * 50) % size.height;
      final radius = (math.sin(animationValue * 2 * math.pi + i) + 1) * 2;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DataFlowPainter extends CustomPainter {
  final double progress;

  DataFlowPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1,
      size.width * 0.9, size.height * 0.3,
    );

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final extractedPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extractedPath, paint);
    }

    // Draw moving particle
    if (progress > 0) {
      final position = metric.getTangentForOffset(metric.length * progress)?.position;
      if (position != null) {
        canvas.drawCircle(
          position,
          8,
          Paint()..color = Colors.blue.withOpacity(0.8),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class EncryptionVisualizationPainter extends CustomPainter {
  final double progress;

  EncryptionVisualizationPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw encryption shield
    final shieldPaint = Paint()
      ..color = Colors.white.withOpacity(0.3 + progress * 0.4)
      ..style = PaintingStyle.fill;
      
    final shieldPath = Path();
    shieldPath.moveTo(centerX, centerY - 40);
    shieldPath.lineTo(centerX - 30, centerY - 20);
    shieldPath.lineTo(centerX - 30, centerY + 20);
    shieldPath.lineTo(centerX, centerY + 40);
    shieldPath.lineTo(centerX + 30, centerY + 20);
    shieldPath.lineTo(centerX + 30, centerY - 20);
    shieldPath.close();
    
    canvas.drawPath(shieldPath, shieldPaint);
    
    // Draw encryption rings
    for (int i = 0; i < 3; i++) {
      final radius = 50.0 + i * 20 + progress * 30;
      final opacity = (1 - progress) * 0.5;
      final ringPaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
        
      canvas.drawCircle(Offset(centerX, centerY), radius, ringPaint);
    }
    
    // Draw lock icon
    if (progress > 0.5) {
      final lockPaint = Paint()
        ..color = Colors.white.withOpacity(progress)
        ..style = PaintingStyle.fill;
        
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(centerX, centerY), width: 20, height: 25),
          const Radius.circular(5),
        ),
        lockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}