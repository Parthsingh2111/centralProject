
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
            IconButton(
              icon: const Icon(Icons.visibility),
              tooltip: 'Visualize the Flow',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlowVisualizerPage()),
                );
              },
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

class FlowVisualizerPage extends StatefulWidget {
  const FlowVisualizerPage({super.key});

  @override
  State<FlowVisualizerPage> createState() => _FlowVisualizerPageState();
}

class _FlowVisualizerPageState extends State<FlowVisualizerPage> with TickerProviderStateMixin {
  static const _animationDuration = Duration(seconds: 2);
  static const _stepAnimationBaseDuration = 500;
  static const _stepAnimationDelay = 200;
  static const _primaryColor = Color(0xFF1E3A8A);
  static const _accentColor = Color(0xFF3B82F6);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _textColor = Color(0xFF4B5563);

  late AnimationController _headerController;
  late Animation<double> _headerOpacity;
  final List<bool> _expandedStates = List.generate(7, (_) => false);
  final List<AnimationController> _stepControllers = [];
  final List<Animation<double>> _stepScales = [];

  final List<Map<String, String>> _steps = [
    {
      'title': 'User Initiates Payment',
      'description': 'Customer clicks the "Pay Now" button on the checkout screen.',
      'details': '''
- **Action**: User triggers the payment process by clicking "Pay Now".
- **Result**: The app invokes the PayGlocal SDK to start the payment flow.
- **Note**: This is a front-end event; no backend processing occurs yet.
''',
      'code': '''
// User clicks the "Pay Now" button
payment = initiateJwtPayment(payload);
'''
    },
    {
      'title': 'Payload Sent to SDK',
      'description': 'The app sends payment details to the PayGlocal SDK.',
      'details': '''
- **Function Called**: `initiateJwtPayment(payload)`
- **Payload Includes**:
  - `merchantTxnId`: Unique transaction identifier
  - `paymentData`: Amount and currency details
  - `merchantCallbackURL`: URL for post-payment redirection
- **Purpose**: Prepares data for secure processing and API interaction.
''',
      'code': '''
async initiateJwtPayment(params) {
  return initiateJwtPayment(params, this.config);
}
'''
    },
    {
      'title': 'SDK Validates Payload',
      'description': 'The SDK checks for required fields and schema validity.',
      'details': '''
- **Validation Checks**:
  - Ensures `merchantTxnId` is not empty
  - Verifies `paymentData` includes amount and currency
  - Confirms `merchantCallbackURL` is valid
- **Error Handling**: Throws descriptive errors for invalid payloads
- **Purpose**: Ensures data integrity before proceeding
''',
      'code': '''
async function initiateJwtPayment(payload, config) {
  const { merchantTxnId, paymentData, merchantCallbackURL } = payload;
  try {
    validatePaycollectPayload(payload);
  } catch (err) {
    // throw new Error(`Schema validation failed: 
  }
  validateRequiredFields(
    {
      merchantTxnId,
      paymentData,
      merchantCallbackURL,
      'paymentData.totalAmount': paymentData?.totalAmount,
      'paymentData.txnCurrency': paymentData?.txnCurrency,
    },
    [
      'merchantTxnId',
      'paymentData',
      'merchantCallbackURL',
      'paymentData.totalAmount',
      'paymentData.txnCurrency',
    ]
  );
}
'''
    },
    {
      'title': 'JWE Token Creation',
      'description': 'The SDK encrypts the payload into a secure JWE token.',
      'details': '''
- **Encryption**:
  - Key: RSA-OAEP-256
  - Content: A128CBC-HS256
- **Token Contents**:
  - Issued time, expiration, key ID, merchant ID
- **Output**: Compact JWE string
- **Purpose**: Secures sensitive data for API transmission
- **Example JWE**: `eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiaWF0IjoiMTc1MzExMjg4MjUxMiIsImV4cCI6MzAwMDAwLCJraWQiOiJrSWQteUx0Umt5NDhYMkhxVzMwayIsImlzc3VlZC1ieSI6InRlc3RuZXdnY2MyNiJ9...`
''',
      'code': '''
const jwe = await generateJWE(payload, config);

async function generateJWE(payload, config) {
  const iat = Date.now();
  const publicKey = await pemToKey(config.payglocalPublicKey, false);
  const payloadStr = JSON.stringify(payload);

  return await new jose.CompactEncrypt(new TextEncoder().encode(payloadStr))
    .setProtectedHeader({
      alg: 'RSA-OAEP-256',
      enc: 'A128CBC-HS256',
      iat: iat.toString(),
      exp: 300000,
      kid: config.publicKeyId,
      'issued-by': config.merchantId,
    })
    .encrypt(publicKey);
}
'''
    },
    {
      'title': 'JWS Token Creation',
      'description': 'The SDK signs the JWE token to ensure authenticity.',
      'details': '''
- **Algorithm**: RS256 (RSA-SHA256)
- **Signed Content**: SHA-256 digest of the JWE token
- **Header Includes**:
  - Merchant ID, key ID, encryption flag
- **Output**: Signed JWS token
- **Purpose**: Verifies the request originates from the merchant
- **Example JWS**: `eyJpc3N1ZWQtYnkiOiJ0ZXN0bmV3Z2NjMjYiLCJhbGciOiJSUzI1NiIsImtpZCI6ImtJZC12VTZlOGw2Yld0WEs4b09LIiwieC1nbC1tZXJjaGFudElkIjoidGVzdG5ld2djYzI2IiwieC1nbC1lbmMiOiJ0cnVlIiwiaXMtZGlnZXN0ZWQiOiJ0cnVlIn0...`
''',
      'code': '''
const jws = await generateJWS(jwe, config);

async function generateJWS(toDigest, config) {
  const iat = Date.now();
  const digest = crypto.createHash('sha256').update(toDigest).digest('base64');
  const digestObject = {
    digest,
    digestAlgorithm: 'SHA-256',
    exp: iat + 300000,
    iat: iat.toString(),
  };
  const privateKey = await pemToKey(config.merchantPrivateKey, true);

  return await new jose.SignJWT(digestObject)
    .setProtectedHeader({
      'issued-by': config.merchantId,
      alg: 'RS256',
      kid: config.privateKeyId,
      'x-gl-merchantId': config.merchantId,
      'x-gl-enc': 'true',
      'is-digested': 'true',
    })
    .sign(privateKey);
}
'''
    },
    {
      'title': 'API Request to PayGlocal',
      'description': 'The SDK sends a secure POST request to the PayGlocal API.',
      'details': '''
- **Endpoint**: `https://api.uat.payglocal.in/gl/v1/payments/initiate/paycollect`
- **Headers**:
  - `x-gl-token-external`: JWS token
  - `Content-Type`: text/plain
- **Body**: JWE token
- **Purpose**: Initiates the payment process on the server
''',
      'code': '''
try {
  // logger.info(`Initiating JWT payment:
  const response = await post(
    `payglocal.in/gl/v1/payments/initiate/paycollect`,
    jwe,
    {
      'Content-Type': 'text/plain',
      'x-gl-token-external': jws,
    }
  );
}
'''
    },
    {
      'title': 'API Response',
      'description': 'PayGlocal returns transaction details and a redirect URL.',
      'details': '''
- **Response Fields**:
  - `gid`: Global transaction ID
  - `status`: Typically "INPROGRESS"
  - `redirectUrl`: URL for user redirection
  - `statusUrl`: URL for transaction status checks
  - `merchantTxnId`: Original transaction ID
- **Purpose**: Provides instructions for the next user action
''',
      'code': '''
{
  gid: 'gl_o-962bd721e763755cdfss0I1X2',
  status: 'INPROGRESS',
  message: 'Transaction Created Successfully',
  timestamp: '21/07/2025 21:18:03',
  reasonCode: 'GL-201-001',
  data: {
    redirectUrl: 'https://api.uat.payglocal.in/gl/payflow-ui/...',
    statusUrl: 'https://api.uat.payglocal.in/gl/v1/payments/...',
    merchantTxnId: '1753112882385976608'
  },
  errors: null
}
'''
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _headerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeInOut),
    );

    for (var i = 0; i < _steps.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: _stepAnimationBaseDuration + i * _stepAnimationDelay),
      );
      _stepControllers.add(controller);
      _stepScales.add(
        Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
        ),
      );
      controller.forward();
    }
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _replayAnimations() {
    _headerController.reset();
    for (var controller in _stepControllers) {
      controller.reset();
      controller.forward();
    }
    _headerController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Theme(
      data: ThemeData(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        appBar: _buildAppBar(isLargeScreen),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isLargeScreen),
                const SizedBox(height: 24),
                CustomPaint(
                  painter: ArrowPainter(_steps.length, screenWidth),
                  child: Column(
                    children: _steps.asMap().entries.map((entry) {
                      return _buildStepCard(entry.key, entry.value, isLargeScreen);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildReplayButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isLargeScreen) {
    return AppBar(
      title: Text(
        'PayGlocal Payment Flow',
        style: GoogleFonts.poppins(
          fontSize: isLargeScreen ? 24 : 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: _primaryColor,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return FadeTransition(
      opacity: _headerOpacity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Flow Visualizer',
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'An interactive guide to the PayGlocal payment process, from user action to server response.',
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 16 : 14,
                color: _textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(int index, Map<String, String> step, bool isLargeScreen) {
    return AnimatedBuilder(
      animation: _stepControllers[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _stepScales[index].value,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  childrenPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: _accentColor.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _accentColor,
                      ),
                    ),
                  ),
                  title: Text(
                    step['title']!,
                    style: GoogleFonts.poppins(
                      fontSize: isLargeScreen ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      step['description']!,
                      style: GoogleFonts.poppins(
                        fontSize: isLargeScreen ? 14 : 12,
                        color: _textColor,
                      ),
                    ),
                  ),
                  children: [
                    SelectableText(
                      step['details']!,
                      style: GoogleFonts.robotoMono(
                        fontSize: isLargeScreen ? 14 : 12,
                        color: _textColor,
                      ),
                    ),
                    if (step['code'] != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          step['code']!,
                          style: GoogleFonts.robotoMono(
                            fontSize: isLargeScreen ? 13 : 11,
                            color: _textColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expandedStates[index] = expanded;
                    });
                  },
                ),
              ),
              if (index < _steps.length - 1) const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReplayButton() {
    return FloatingActionButton.extended(
      onPressed: _replayAnimations,
      label: const Text('Replay Animations'),
      icon: const Icon(Icons.replay),
      backgroundColor: _accentColor,
      tooltip: 'Replay all animations',
    );
  }
}

class ArrowPainter extends CustomPainter {
  final int stepCount;
  final double screenWidth;

  ArrowPainter(this.stepCount, this.screenWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _FlowVisualizerPageState._textColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const stepHeight = 80.0;
    const spacing = 40.0;
    const arrowHeadSize = 8.0;

    for (var i = 0; i < stepCount - 1; i++) {
      final startY = (i + 1) * (stepHeight + spacing) - spacing / 2;
      final endY = (i + 1) * (stepHeight + spacing) + spacing / 2;

      canvas.drawLine(
        Offset(screenWidth / 2, startY),
        Offset(screenWidth / 2, endY),
        paint,
      );

      final path = Path()
        ..moveTo(screenWidth / 2 - arrowHeadSize, endY - arrowHeadSize)
        ..lineTo(screenWidth / 2, endY)
        ..lineTo(screenWidth / 2 + arrowHeadSize, endY - arrowHeadSize)
        ..close();
      canvas.drawPath(path, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
















// class FlowVisualizerPage extends StatefulWidget {
//   const FlowVisualizerPage({super.key});

//   @override
//   State<FlowVisualizerPage> createState() => _FlowVisualizerPageState();
// }

// class _FlowVisualizerPageState extends State<FlowVisualizerPage>
//     with TickerProviderStateMixin {
//   static const _animationDuration = Duration(seconds: 2);
//   static const _stepAnimationBaseDuration = 500;
//   static const _stepAnimationDelay = 200;
//   static const _primaryColor = Color(0xFF1E3A8A);
//   static const _accentColor = Color(0xFF3B82F6);
//   static const _backgroundColor = Color(0xFFF8FAFC);
//   static const _textColor = Color(0xFF4B5563);

//   late AnimationController _headerController;
//   late Animation<double> _headerOpacity;
//   final List<bool> _expandedStates = List.generate(7, (_) => false);
//   final List<AnimationController> _stepControllers = [];
//   final List<Animation<double>> _stepScales = [];
//   late List<Animation<Offset>> _stepOffsets;
//   late List<Animation<double>> _stepOpacities;
//   late AnimationController _arrowController;
//   late Animation<double> _arrowAnimation;

//   final List<Map<String, String>> _steps = [
//  {
//       'title': 'User Initiates Payment',
//       'description': 'Customer clicks the "Pay Now" button on the checkout screen.',
//       'details': '''
// - **Action**: User triggers the payment process by clicking "Pay Now".
// - **Result**: The app invokes the PayGlocal SDK to start the payment flow.
// - **Note**: This is a front-end event; no backend processing occurs yet.
// ''',
//       'code': '''
// // User clicks the "Pay Now" button
// payment = initiateJwtPayment(payload);
// '''
//     },
//     {
//       'title': 'Payload Sent to SDK',
//       'description': 'The app sends payment details to the PayGlocal SDK.',
//       'details': '''
// - **Function Called**: `initiateJwtPayment(payload)`
// - **Payload Includes**:
//   - `merchantTxnId`: Unique transaction identifier
//   - `paymentData`: Amount and currency details
//   - `merchantCallbackURL`: URL for post-payment redirection
// - **Purpose**: Prepares data for secure processing and API interaction.
// ''',
//       'code': '''
// async initiateJwtPayment(params) {
//   return initiateJwtPayment(params, this.config);
// }
// '''
//     },
//     {
//       'title': 'SDK Validates Payload',
//       'description': 'The SDK checks for required fields and schema validity.',
//       'details': '''
// - **Validation Checks**:
//   - Ensures `merchantTxnId` is not empty
//   - Verifies `paymentData` includes amount and currency
//   - Confirms `merchantCallbackURL` is valid
// - **Error Handling**: Throws descriptive errors for invalid payloads
// - **Purpose**: Ensures data integrity before proceeding
// ''',
//       'code': '''
// async function initiateJwtPayment(payload, config) {
//   const { merchantTxnId, paymentData, merchantCallbackURL } = payload;
//   try {
//     validatePaycollectPayload(payload);
//   } catch (err) {
//     throw new Error(`Schema validation failed: error`);
//   }
//   validateRequiredFields(
//     {
//       merchantTxnId,
//       paymentData,
//       merchantCallbackURL,
//       'paymentData.totalAmount': paymentData?.totalAmount,
//       'paymentData.txnCurrency': paymentData?.txnCurrency,
//     },
//     [
//       'merchantTxnId',
//       'paymentData',
//       'merchantCallbackURL',
//       'paymentData.totalAmount',
//       'paymentData.txnCurrency',
//     ]
//   );
// }
// '''
//     },
//     {
//       'title': 'JWE Token Creation',
//       'description': 'The SDK encrypts the payload into a secure JWE token.',
//       'details': '''
// - **Encryption**:
//   - Key: RSA-OAEP-256
//   - Content: A128CBC-HS256
// - **Token Contents**:
//   - Issued time, expiration, key ID, merchant ID
// - **Output**: Compact JWE string
// - **Purpose**: Secures sensitive data for API transmission
// - **Example JWE**: `eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiaWF0IjoiMTc1MzExMjg4MjUxMiIsImV4cCI6MzAwMDAwLCJraWQiOiJrSWQteUx0Umt5NDhYMkhxVzMwayIsImlzc3VlZC1ieSI6InRlc3RuZXdnY2MyNiJ9...`
// ''',
//       'code': '''
// const jwe = await generateJWE(payload, config);

// async function generateJWE(payload, config) {
//   const iat = Date.now();
//   const publicKey = await pemToKey(config.payglocalPublicKey, false);
//   const payloadStr = JSON.stringify(payload);

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
// '''
//     },
//     {
//       'title': 'JWS Token Creation',
//       'description': 'The SDK signs the JWE token to ensure authenticity.',
//       'details': '''
// - **Algorithm**: RS256 (RSA-SHA256)
// - **Signed Content**: SHA-256 digest of the JWE token
// - **Header Includes**:
//   - Merchant ID, key ID, encryption flag
// - **Output**: Signed JWS token
// - **Purpose**: Verifies the request originates from the merchant
// - **Example JWS**: `eyJpc3N1ZWQtYnkiOiJ0ZXN0bmV3Z2NjMjYiLCJhbGciOiJSUzI1NiIsImtpZCI6ImtJZC12VTZlOGw2Yld0WEs4b09LIiwieC1nbC1tZXJjaGFudElkIjoidGVzdG5ld2djYzI2IiwieC1nbC1lbmMiOiJ0cnVlIiwiaXMtZGlnZXN0ZWQiOiJ0cnVlIn0...`
// ''',
//       'code': '''
// const jws = await generateJWS(jwe, config);

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
// '''
//     },
//     {
//       'title': 'API Request to PayGlocal',
//       'description': 'The SDK sends a secure POST request to the PayGlocal API.',
//       'details': '''
// - **Endpoint**: `https://api.uat.payglocal.in/gl/v1/payments/initiate/paycollect`
// - **Headers**:
//   - `x-gl-token-external`: JWS token
//   - `Content-Type`: text/plain
// - **Body**: JWE token
// - **Purpose**: Initiates the payment process on the server
// ''',
//       'code': '''
// try {
//   const response = await post(
//     `payGlocal.in/gl/v1/payments/initiate/paycollect`,
//     jwe,
//     {
//       'Content-Type': 'text/plain',
//       'x-gl-token-external': jws,
//     }
//   );
// }
// '''
//     },
//     {
//       'title': 'API Response',
//       'description': 'PayGlocal returns transaction details and a redirect URL.',
//       'details': '''
// - **Response Fields**:
//   - `gid`: Global transaction ID
//   - `status`: Typically "INPROGRESS"
//   - `redirectUrl`: URL for user redirection
//   - `statusUrl`: URL for transaction status checks
//   - `merchantTxnId`: Original transaction ID
// - **Purpose**: Provides instructions for the next user action
// ''',
//       'code': '''
// {
//   gid: 'gl_o-962bd721e763755cdfss0I1X2',
//   status: 'INPROGRESS',
//   message: 'Transaction Created Successfully',
//   timestamp: '21/07/2025 21:18:03',
//   reasonCode: 'GL-201-001',
//   data: {
//     redirectUrl: 'https://api.uat.payglocal.in/gl/payflow-ui/...',
//     statusUrl: 'https://api.uat.payglocal.in/gl/v1/payments/...',
//     merchantTxnId: '1753112882385976608'
//   },
//   errors: null
// }
// '''
//     },

//   ]; // Use your existing steps

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//   }

//   void _initializeAnimations() {
//     _headerController = AnimationController(
//       vsync: this,
//       duration: _animationDuration,
//     );
//     _headerOpacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _headerController, curve: Curves.easeInOut),
//     );

//     _stepOffsets = [];
//     _stepOpacities = [];

//     for (var i = 0; i < _steps.length; i++) {
//       final controller = AnimationController(
//         vsync: this,
//         duration: Duration(
//             milliseconds: _stepAnimationBaseDuration + i * _stepAnimationDelay),
//       );
//       _stepControllers.add(controller);
//       _stepScales.add(
//         Tween<double>(begin: 0.9, end: 1.0).animate(
//           CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
//         ),
//       );
//       _stepOffsets.add(
//         Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
//           CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
//         ),
//       );
//       _stepOpacities.add(
//         Tween<double>(begin: 0, end: 1).animate(
//           CurvedAnimation(parent: controller, curve: Curves.easeIn),
//         ),
//       );
//       controller.forward();
//     }

//     _arrowController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//     _arrowAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
//     );
//     _headerController.forward();
//     _arrowController.forward();
//   }

//   @override
//   void dispose() {
//     _headerController.dispose();
//     _arrowController.dispose();
//     for (var controller in _stepControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _replayAnimations() {
//     _headerController.reset();
//     _arrowController.reset();
//     for (var controller in _stepControllers) {
//       controller.reset();
//       controller.forward();
//     }
//     _headerController.forward();
//     _arrowController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth > 600;

//     return Theme(
//       data: ThemeData(
//         primaryColor: _primaryColor,
//         colorScheme:
//             ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
//         scaffoldBackgroundColor: _backgroundColor,
//       ),
//       child: Scaffold(
//         appBar: _buildAppBar(isLargeScreen),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(isLargeScreen),
//                 const SizedBox(height: 24),
//                 AnimatedBuilder(
//                   animation: _arrowAnimation,
//                   builder: (context, _) => CustomPaint(
//                     painter:
//                         ArrowPainter(_steps.length, screenWidth, _arrowAnimation.value),
//                     child: Column(
//                       children: _steps.asMap().entries.map((entry) {
//                         return _buildStepCard(
//                             entry.key, entry.value, isLargeScreen);
//                       }).toList(),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: _buildReplayButton(),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(bool isLargeScreen) {
//     return AppBar(
//       title: Text(
//         'PayGlocal Payment Flow',
//         style: GoogleFonts.poppins(
//           fontSize: isLargeScreen ? 24 : 20,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//       backgroundColor: _primaryColor,
//       elevation: 2,
//       shadowColor: Colors.black.withOpacity(0.2),
//     );
//   }

//   Widget _buildHeader(bool isLargeScreen) {
//     return FadeTransition(
//       opacity: _headerOpacity,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Payment Flow Visualizer',
//               style: GoogleFonts.poppins(
//                 fontSize: isLargeScreen ? 28 : 24,
//                 fontWeight: FontWeight.bold,
//                 color: _primaryColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'An interactive guide to the PayGlocal payment process, from user action to server response.',
//               style: GoogleFonts.poppins(
//                 fontSize: isLargeScreen ? 16 : 14,
//                 color: _textColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStepCard(
//       int index, Map<String, String> step, bool isLargeScreen) {
//     return SlideTransition(
//       position: _stepOffsets[index],
//       child: FadeTransition(
//         opacity: _stepOpacities[index],
//         child: Transform.scale(
//           scale: _stepScales[index].value,
//           child: Column(
//             children: [
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ExpansionTile(
//                   tilePadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   childrenPadding: const EdgeInsets.all(16),
//                   leading: CircleAvatar(
//                     backgroundColor: _accentColor.withOpacity(0.1),
//                     child: Text(
//                       '${index + 1}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: _accentColor,
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     step['title']!,
//                     style: GoogleFonts.poppins(
//                       fontSize: isLargeScreen ? 18 : 16,
//                       fontWeight: FontWeight.w600,
//                       color: _primaryColor,
//                     ),
//                   ),
//                   subtitle: Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: Text(
//                       step['description']!,
//                       style: GoogleFonts.poppins(
//                         fontSize: isLargeScreen ? 14 : 12,
//                         color: _textColor,
//                       ),
//                     ),
//                   ),
//                   children: [
//                     SelectableText(
//                       step['details']!,
//                       style: GoogleFonts.robotoMono(
//                         fontSize: isLargeScreen ? 14 : 12,
//                         color: _textColor,
//                       ),
//                     ),
//                     if (step['code'] != null) ...[
//                       const SizedBox(height: 16),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: _backgroundColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: SelectableText(
//                           step['code']!,
//                           style: GoogleFonts.robotoMono(
//                             fontSize: isLargeScreen ? 13 : 11,
//                             color: _textColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                   onExpansionChanged: (expanded) {
//                     setState(() {
//                       _expandedStates[index] = expanded;
//                     });
//                   },
//                 ),
//               ),
//               if (index < _steps.length - 1) const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildReplayButton() {
//     return FloatingActionButton(
//       onPressed: _replayAnimations,
//       backgroundColor: _accentColor,
//       tooltip: 'Replay Animations',
//       child: const Icon(Icons.replay, color: Colors.white),
//     );
//   }
// }

// class ArrowPainter extends CustomPainter {
//   final int stepCount;
//   final double screenWidth;
//   final double progress;

//   ArrowPainter(this.stepCount, this.screenWidth, this.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = _FlowVisualizerPageState._textColor.withOpacity(0.5)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     const stepHeight = 80.0;
//     const spacing = 40.0;
//     const arrowHeadSize = 8.0;

//     for (var i = 0; i < stepCount - 1; i++) {
//       final startY = (i + 1) * (stepHeight + spacing) - spacing / 2;
//       final endY = (i + 1) * (stepHeight + spacing) + spacing / 2;
//       final currentProgress = (i + 1) / stepCount;
//       if (progress >= currentProgress) {
//         canvas.drawLine(
//           Offset(screenWidth / 2, startY),
//           Offset(screenWidth / 2, endY),
//           paint,
//         );
//         final path = Path()
//           ..moveTo(screenWidth / 2 - arrowHeadSize, endY - arrowHeadSize)
//           ..lineTo(screenWidth / 2, endY)
//           ..lineTo(screenWidth / 2 + arrowHeadSize, endY - arrowHeadSize)
//           ..close();
//         canvas.drawPath(path, paint..style = PaintingStyle.fill);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
