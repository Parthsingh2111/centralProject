import 'package:centralproject/screen/paycollect_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/shared_app_bar.dart';

class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen({Key? key}) : super(key: key);

  @override
  _VisualizationScreenState createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _flowController;
  late Animation<double> _flowAnimation;
  
  int? _selectedStep;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _flowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _flowAnimation = CurvedAnimation(
      parent: _flowController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  void _onStepTapped(int step) {
    setState(() {
      _selectedStep = step;
      _showDetails = true;
    });
  }

  void _goBack() {
    setState(() {
      _showDetails = false;
      _selectedStep = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: SharedAppBar(
        title: _showDetails ? 'Payment Flow Details' : 'Payment Flow Visualization',
        fadeAnimation: _fadeAnimation,
        leading: _showDetails 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
            )
          : null,
      ),
      body: SafeArea(
        child: _showDetails 
          ? _buildDetailView(isLargeScreen)
          : _buildMainView(isLargeScreen),
      ),
    );
  }

  Widget _buildMainView(bool isLargeScreen) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'PayGlocal Payment Flow',
                  style: GoogleFonts.poppins(
                    fontSize: isLargeScreen ? 32 : 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Interactive visualization of the payment processing flow - Click on any step to learn more',
                style: GoogleFonts.poppins(
                  fontSize: isLargeScreen ? 18 : 16,
                  color: const Color(0xFF4B5563),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Flow Diagram
              Container(
                padding: const EdgeInsets.all(32),
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
                ),
                child: Column(
                  children: [
                    _buildFlowStep(
                      'Merchant Initiated Payment',
                      'Merchant sends payment request with transaction details',
                      Icons.store,
                      const Color(0xFF3B82F6),
                      0,
                    ),
                    _buildFlowArrow(),
                    _buildFlowStep(
                      'PayGlocal SDK Validates Payload',
                      'SDK validates merchant credentials and request format',
                      Icons.verified,
                      const Color(0xFF10B981),
                      1,
                    ),
                    _buildFlowArrow(),
                    _buildFlowStep(
                      'PayGlocal SDK Generated JWE Token',
                      'Creates encrypted JWE token with payment data',
                      Icons.security,
                      const Color(0xFFF59E0B),
                      2,
                    ),
                    _buildFlowArrow(),
                    _buildFlowStep(
                      'PayGlocal SDK Generated JWS Token',
                      'Creates signed JWS token for authentication',
                      Icons.verified_user,
                      const Color(0xFF8B5CF6),
                      3,
                    ),
                    _buildFlowArrow(),
                    _buildFlowStep(
                      'Final API Initiation',
                      'Sends encrypted tokens to PayGlocal API endpoint',
                      Icons.api,
                      const Color(0xFFEF4444),
                      4,
                    ),
                    _buildFlowArrow(),
                    _buildFlowStep(
                      'Transaction Confirmation or Error Response',
                      'Receives payment status and transaction details',
                      Icons.check_circle,
                      const Color(0xFF059669),
                      5,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Additional Information
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'PayCollect',
                      'For non-PCI DSS merchants',
                      Icons.shield,
                      const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      'PayDirect',
                      'For PCI DSS certified merchants',
                      Icons.credit_card,
                      const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailView(bool isLargeScreen) {
    if (_selectedStep == null) return Container();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _getDetailContent(_selectedStep!, isLargeScreen),
        ),
      ),
    );
  }

  Widget _buildFlowStep(String title, String description, IconData icon, Color color, int step) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onStepTapped(step),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
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
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowArrow() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedBuilder(
        animation: _flowAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 4 * _flowAnimation.value),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 32,
              color: const Color(0xFF3B82F6).withOpacity(0.6),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF4B5563),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _getDetailContent(int step, bool isLargeScreen) {
    switch (step) {
      case 0:
        return _buildMerchantInitiatedPaymentDetails(isLargeScreen);
      case 1:
        return _buildPayloadValidationDetails(isLargeScreen);
      case 2:
        return _buildJWETokenDetails(isLargeScreen);
      case 3:
        return _buildJWSTokenDetails(isLargeScreen);
      case 4:
        return _buildAPIInitiationDetails(isLargeScreen);
      case 5:
        return _buildResponseDetails(isLargeScreen);
      default:
        return Container();
    }
  }

  Widget _buildMerchantInitiatedPaymentDetails(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailHeader(
          'Step 1: Merchant Initiated Payment',
          'Understanding how merchants initiate payments through PayGlocal SDK',
          Icons.store,
          const Color(0xFF3B82F6),
          isLargeScreen,
        ),
        const SizedBox(height: 32),
        
        _buildSectionCard(
          'Payment Initiation Process',
          'When a customer clicks "Pay Now" on your merchant application, the payment process begins by creating a structured payload containing all necessary transaction details.',
          Icons.play_arrow,
          const Color(0xFF3B82F6),
        ),
        
        const SizedBox(height: 24),
        
        _buildCodeSection(
          'Payload Structure',
          '''const payload = {
  merchantTxnId,        // Unique transaction ID from merchant
  paymentData,          // Complete payment information
  merchantCallbackURL   // URL for payment status updates
};

// Initiate payment with PayGlocal SDK
initiateJwtPayment(payload);''',
        ),
        
        const SizedBox(height: 24),
        
        _buildPayloadFieldsExplanation(),
      ],
    );
  }

  Widget _buildPayloadValidationDetails(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailHeader(
          'Step 2: PayGlocal SDK Validates Payload',
          'Comprehensive validation ensures secure and accurate payment processing',
          Icons.verified,
          const Color(0xFF10B981),
          isLargeScreen,
        ),
        const SizedBox(height: 32),
        
        _buildSectionCard(
          'Validation Process',
          'The PayGlocal SDK performs thorough validation of all required fields to ensure data integrity and prevent processing errors.',
          Icons.security,
          const Color(0xFF10B981),
        ),
        
        const SizedBox(height: 24),
        
        _buildValidationSteps(),
        
        const SizedBox(height: 24),
        
        _buildCodeSection(
          'SDK Function Call',
          '''async initiateJwtPayment(params) {
  return initiateJwtPayment(params, this.config);
}''',
        ),
      ],
    );
  }

  Widget _buildJWETokenDetails(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailHeader(
          'Step 3: PayGlocal SDK Generated JWE Token',
          'Creating encrypted tokens for secure data transmission',
          Icons.security,
          const Color(0xFFF59E0B),
          isLargeScreen,
        ),
        const SizedBox(height: 32),
        
        _buildSectionCard(
          'JWE Token Generation',
          'JSON Web Encryption (JWE) ensures that sensitive payment data remains encrypted during transmission, providing maximum security.',
          Icons.lock,
          const Color(0xFFF59E0B),
        ),
        
        const SizedBox(height: 24),
        
        _buildJWEProcess(),
        
        const SizedBox(height: 24),
        
        _buildCodeSection(
          'Token Generation Call',
          '''const jwe = await generateJWE(payload, config);''',
        ),
      ],
    );
  }

  Widget _buildJWSTokenDetails(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailHeader(
          'Step 4: PayGlocal SDK Generated JWS Token',
          'Digital signature for authentication and integrity verification',
          Icons.verified_user,
          const Color(0xFF8B5CF6),
          isLargeScreen,
        ),
        const SizedBox(height: 32),
        
        _buildSectionCard(
          'JWS Token Generation',
          'JSON Web Signature (JWS) provides digital signature capabilities, ensuring the authenticity and integrity of the encrypted payload.',
          Icons.verified_user,
          const Color(0xFF8B5CF6),
        ),
        
        const SizedBox(height: 24),
        
        _buildJWSProcess(),
        
        const SizedBox(height: 24),
        
        _buildCodeSection(
          'Token Generation Call',
          '''const jws = await generateJWS(jwe, config);''',
        ),
      ],
    );
  }

  Widget _buildAPIInitiationDetails(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailHeader(
          'Step 5: Final API Initiation',
          'Secure transmission of encrypted tokens to PayGlocal servers',
          Icons.api,
          const Color(0xFFEF4444),
          isLargeScreen,
        ),
        const SizedBox(height: 32),
        
        _buildSectionCard(
          'API Endpoint Selection',
          'PayGlocal provides different endpoints based on your merchant type and PCI DSS compliance status.',
          Icons.cloud_upload,
          const Color(0xFFEF4444),
        ),
        
        const SizedBox(height: 24),
        
        _buildAPIEndpoints(),
      ],
    );
  }

  Widget _buildResponseDetails(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailHeader(
          'Step 6: Transaction Confirmation or Error Response',
          'Understanding PayGlocal response structure and handling',
          Icons.check_circle,
          const Color(0xFF059669),
          isLargeScreen,
        ),
        const SizedBox(height: 32),
        
        _buildSectionCard(
          'Response Structure',
          'PayGlocal returns a standardized response format for both successful transactions and error scenarios.',
          Icons.data_object,
          const Color(0xFF059669),
        ),
        
        const SizedBox(height: 24),
        
        _buildResponseStructure(),
        
        const SizedBox(height: 24),
        
        _buildErrorCodes(),
      ],
    );
  }

  Widget _buildDetailHeader(String title, String description, IconData icon, Color color, bool isLargeScreen) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: isLargeScreen ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: isLargeScreen ? 16 : 14,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSection(String title, String code) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            code,
            style: GoogleFonts.firaCode(
              fontSize: 14,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayloadFieldsExplanation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payload Fields Explanation',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildFieldExplanation('merchantTxnId', 'Unique identifier for the transaction from merchant side'),
          _buildFieldExplanation('paymentData', 'Contains all payment details including amount, currency, and card data'),
          _buildFieldExplanation('merchantCallbackURL', 'URL where PayGlocal will send payment status updates'),
        ],
      ),
    );
  }

  Widget _buildFieldExplanation(String field, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              field,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationSteps() {
    final validationSteps = [
      'Merchant Transaction ID validation',
      'Payment data structure verification',
      'Callback URL format checking',
      'Amount and currency validation',
      'Card data security verification',
      'Required fields presence check',
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Validation Steps',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          ...validationSteps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildJWEProcess() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JWE Token Creation Process',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildProcessStep('1', 'Payload Conversion', 'Convert payment data to JSON string format'),
          _buildProcessStep('2', 'Timestamp Generation', 'Create issued-at-time (iat) timestamp'),
          _buildProcessStep('3', 'Public Key Loading', 'Load PayGlocal public key for encryption'),
          _buildProcessStep('4', 'Header Configuration', 'Set encryption algorithm (RSA-OAEP-256) and encoding (A128CBC-HS256)'),
          _buildProcessStep('5', 'Token Encryption', 'Encrypt payload using PayGlocal public key'),
          const SizedBox(height: 16),
          _buildJWEHeaderExplanation(),
        ],
      ),
    );
  }

  Widget _buildJWSProcess() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JWS Token Creation Process',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildProcessStep('1', 'JWE Digest Creation', 'Create SHA-256 hash of the JWE token'),
          _buildProcessStep('2', 'Digest Object Formation', 'Create object with digest, algorithm, and timestamps'),
          _buildProcessStep('3', 'Private Key Loading', 'Load merchant private key for signing'),
          _buildProcessStep('4', 'Header Configuration', 'Set signing algorithm (RS256) and merchant identification'),
          _buildProcessStep('5', 'Token Signing', 'Sign the digest using merchant private key'),
          const SizedBox(height: 16),
          _buildJWSHeaderExplanation(),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJWEHeaderExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JWE Header Fields',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(height: 12),
          _buildHeaderField('alg', 'RSA-OAEP-256', 'Encryption algorithm'),
          _buildHeaderField('enc', 'A128CBC-HS256', 'Content encryption algorithm'),
          _buildHeaderField('kid', 'config.publicKeyId', 'Key identifier'),
          _buildHeaderField('issued-by', 'config.merchantId', 'Token issuer identification'),
          _buildHeaderField('exp', '300000', 'Token expiration time'),
        ],
      ),
    );
  }

  Widget _buildJWSHeaderExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JWS Header Fields',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 12),
          _buildHeaderField('alg', 'RS256', 'Signing algorithm'),
          _buildHeaderField('kid', 'config.privateKeyId', 'Private key identifier'),
          _buildHeaderField('issued-by', 'config.merchantId', 'Token issuer'),
          _buildHeaderField('x-gl-merchantId', 'config.merchantId', 'PayGlocal merchant ID'),
          _buildHeaderField('x-gl-enc', 'true', 'Encryption flag'),
          _buildHeaderField('is-digested', 'true', 'Digest indicator'),
        ],
      ),
    );
  }

  Widget _buildHeaderField(String field, String value, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              field,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              value,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                color: const Color(0xFF059669),
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAPIEndpoints() {
    return Column(
      children: [
        _buildEndpointCard(
          'PayCollect Endpoint',
          'For non-PCI DSS merchants',
          '/gl/v1/payments/initiate/paycollect',
          const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 16),
        _buildEndpointCard(
          'PayDirect Endpoint',
          'For PCI DSS certified merchants',
          '/gl/v1/payments/initiate',
          const Color(0xFF10B981),
        ),
        const SizedBox(height: 24),
        _buildRequestDetails(),
      ],
    );
  }

  Widget _buildEndpointCard(String title, String description, String endpoint, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.api, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              endpoint,
              style: GoogleFonts.firaCode(
                fontSize: 14,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestDetails() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request Structure',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildRequestComponent('Body', 'JWE Token', 'Encrypted payment data'),
          _buildRequestComponent('Header: Content-Type', 'text/plain', 'Content type specification'),
          _buildRequestComponent('Header: x-gl-token-external', 'JWS Token', 'Authentication signature'),
        ],
      ),
    );
  }

  Widget _buildRequestComponent(String component, String value, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              component,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              value,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                color: const Color(0xFF059669),
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseStructure() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Response Structure',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildCodeSection(
            'Standard Response Format',
            '''{
  "gid": "",
  "status": "",
  "message": "",
  "timestamp": "",
  "reasonCode": "",
  "data": {},
  "errors": {}
}''',
          ),
          const SizedBox(height: 16),
          _buildResponseFieldsTable(),
        ],
      ),
    );
  }

  Widget _buildResponseFieldsTable() {
    final fields = [
      {'field': 'gid', 'description': 'PayGlocal ID to track each HTTP API request'},
      {'field': 'status', 'description': 'PayGlocal status of the API response'},
      {'field': 'message', 'description': 'Description of the response in a few words'},
      {'field': 'timestamp', 'description': 'Timestamp when HTTP response is created'},
      {'field': 'reasonCode', 'description': 'PayGlocal reason code indicating response status'},
      {'field': 'data', 'description': 'Success response data (varies by API)'},
      {'field': 'errors', 'description': 'Error details if request fails'},
    ];

    return Column(
      children: fields.map((field) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  field['field']!,
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  field['description']!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorCodes() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Common Error Codes',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          _buildErrorCode('GL-201-000', 'Declined by System', 'Transaction declined by payment system'),
          // Add more error codes as needed
        ],
      ),
    );
  }

  Widget _buildErrorCode(String code, String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: GoogleFonts.firaCode(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}