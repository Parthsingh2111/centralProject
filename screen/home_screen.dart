
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      curve: Curves.easeInOutCirc, // Changed from easeIn
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          title: FadeTransition(
            opacity: _appBarFadeAnimation,
            child: Text(
              'PageLocal Showcase',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FadeTransition(
                opacity: _appBarFadeAnimation,
                child: ElevatedButton(
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
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                  ),
                  child: Text(
                    'Services',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                  // Hero Section
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
                          _ProductCard(
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
                          _ProductCard(
                            title: 'PayDirect',
                            description: 'For PCI DSS certified merchants. Securely process card payments directly on your platform.',
                            details: '''
**PayDirect Flow**  
Designed for PCI DSS certified merchants who handle card data on their platform. Send complete payment details, including card data, to PayGlocal for secure processing.  

**Key Features:**  
- Requires PCI DSS compliance for card data handling.  
- Collects billing address and device info on PayGlocal’s page for risk assessment.  
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

class _ProductCard extends StatefulWidget {
  final String title;
  final String description;
  final String details;
  final String route;
  final IconData icon;
  final String badge;
  final Color badgeColor;
  final List<String> benefits;
  final String largeText;
  final bool isPayCollect;

  const _ProductCard({
    required this.title,
    required this.description,
    required this.details,
    required this.route,
    required this.icon,
    required this.badge,
    required this.badgeColor,
    required this.benefits,
    required this.largeText,
    required this.isPayCollect,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _dialogAnimationController;
  late Animation<double> _dialogFadeAnimation;
  late Animation<double> _dialogScaleAnimation;

  @override
  void initState() {
    super.initState();
    _dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _dialogFadeAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeInOut,
    );
    _dialogScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _dialogAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _dialogAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
      child: Card(
        color: const Color(0xFFF9FAFB),
        elevation: _isHovered ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        child: InkWell(
          onTap: () {
            try {
              Navigator.pushNamed(context, widget.route);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.route} route not found')),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          hoverColor: const Color(0xFFF3F4F6),
          onHover: (hovered) {
            setState(() {
              _isHovered = hovered;
            });
          },
          child: Stack(
            children: [
              // Large stylized text
              Positioned(
                left: widget.isPayCollect ? null : 16,
                right: widget.isPayCollect ? 16 : null,
                bottom: 80,
                child: Opacity(
                  opacity: 0.15,
                  child: Text(
                    widget.largeText,
                    style: GoogleFonts.notoSans(
                      fontSize: isLargeScreen ? 72 : 54,
                      fontWeight: FontWeight.bold,
                      color: widget.isPayCollect ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: widget.isPayCollect ? TextAlign.right : TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
                          child: Icon(
                            widget.icon,
                            size: isLargeScreen ? 32 : 28,
                            color: widget.badgeColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.badgeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.badge,
                            style: GoogleFonts.notoSans(
                              fontSize: isLargeScreen ? 12 : 11,
                              fontWeight: FontWeight.w600,
                              color: widget.badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: GoogleFonts.notoSans(
                        fontSize: isLargeScreen ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: GoogleFonts.notoSans(
                        fontSize: isLargeScreen ? 14 : 13,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.benefits.map((benefit) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: isLargeScreen ? 16 : 14,
                              color: widget.badgeColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                benefit,
                                style: GoogleFonts.notoSans(
                                  fontSize: isLargeScreen ? 13 : 12,
                                  color: const Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: 'Learn more about ${widget.title}',
                          child: ElevatedButton(
                            onPressed: () => _showDetailsDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3B82F6),
                              side: const BorderSide(color: Color(0xFF3B82F6)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              elevation: _isHovered ? 2 : 0,
                            ),
                            child: Text(
                              'View Details',
                              style: GoogleFonts.notoSans(
                                fontSize: isLargeScreen ? 14 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Try ${widget.title} now',
                          child: ElevatedButton(
                            onPressed: () {
                              try {
                                Navigator.pushNamed(context, widget.route);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${widget.route} route not found')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              elevation: _isHovered ? 2 : 0,
                            ),
                            child: Text(
                              'Try Now',
                              style: GoogleFonts.notoSans(
                                fontSize: isLargeScreen ? 14 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;
    final titleFontSize = isLargeScreen ? 18.0 : 16.0;
    final bodyFontSize = isLargeScreen ? 14.0 : 13.0;
    final codeFontSize = isLargeScreen ? 12.0 : 11.0;
    final iconSize = isLargeScreen ? 28.0 : 24.0;
    final padding = isLargeScreen ? 16.0 : 12.0;

    String? payload;
    try {
      final startMarker = '```json\n';
      final endMarker = '\n```';
      final startIndex = widget.details.indexOf(startMarker) + startMarker.length;
      final endIndex = widget.details.indexOf(endMarker, startIndex);
      payload = widget.details.substring(startIndex, endIndex).trim();
    } catch (e) {
      payload = null;
    }

    // Parse markdown content
    List<Widget> contentWidgets = [];
    final lines = widget.details.split('\n');
    bool inCodeBlock = false;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        contentWidgets.add(const SizedBox(height: 8));
        continue;
      }

      if (line.startsWith('```json')) {
        inCodeBlock = true;
        continue;
      } else if (line.startsWith('```')) {
        inCodeBlock = false;
        continue;
      } else if (inCodeBlock) {
        continue; // Skip code block content (handled by payload)
      }

      if (line.startsWith('**') && line.endsWith('**')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              line.substring(2, line.length - 2),
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        );
      } else if (line.startsWith('- ')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  size: isLargeScreen ? 16 : 14,
                  color: widget.badgeColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith('*') && line.endsWith('*')) {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              line.substring(1, line.length - 1),
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        );
      } else {
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              line,
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        );
      }
    }

    // Add code block if payload exists
    if (payload != null) {
      contentWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Mimics bg-gray-100
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                payload,
                style: GoogleFonts.robotoMono(
                  fontSize: codeFontSize,
                  color: const Color(0xFF1F2937), // Mimics text-gray-800
                ),
              ),
            ),
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return FadeTransition(
          opacity: _dialogFadeAnimation,
          child: ScaleTransition(
            scale: _dialogScaleAnimation,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF9FAFB), Color(0xFFE5E7EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.badgeColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.icon,
                                size: iconSize,
                                color: widget.badgeColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: GoogleFonts.poppins(
                                  fontSize: isLargeScreen ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Parsed content
                        ...contentWidgets,
                        if (payload != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedScale(
                                scale: _isHovered ? 1.05 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: payload ?? '')).then((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Payload copied to clipboard')),
                                      );
                                    }).catchError((e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to copy payload')),
                                      );
                                    });
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    size: isLargeScreen ? 16 : 14,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Copy Payload',
                                    style: GoogleFonts.poppins(
                                      fontSize: isLargeScreen ? 14 : 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.badgeColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontSize: isLargeScreen ? 14 : 12,
                      color: const Color(0xFF4B5563),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedScale(
                  scale: _isHovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      try {
                        Navigator.pushNamed(context, widget.route);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.route} route not found')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      elevation: 2,
                    ),
                    child: Text(
                      'Try Now',
                      style: GoogleFonts.poppins(
                        fontSize: isLargeScreen ? 14 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
