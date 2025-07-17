// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PayCollectScreen extends StatefulWidget {
//   const PayCollectScreen({Key? key}) : super(key: key);

//   @override
//   _PayCollectScreenState createState() => _PayCollectScreenState();
// }

// class _PayCollectScreenState extends State<PayCollectScreen> with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..forward();
//     _fadeAnimation = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeIn,
//     );
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth > 800;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6), // Mimics bg-gray-100
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70),
//         child: AppBar(
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
//             ),
//           ),
//           elevation: 4,
//           shadowColor: Colors.black.withOpacity(0.2),
//           title: FadeTransition(
//             opacity: _fadeAnimation,
//             child: Text(
//               'PayCollect Payment Methods',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     try {
//                       Navigator.pushNamed(context, '/services');
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Services route not found')),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color(0xFF3B82F6),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     elevation: 2,
//                   ),
//                   child: Text(
//                     'Services',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF3B82F6),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//           child: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 1200),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Text(
//                       'Choose a Payment Method for PayCollect',
//                       style: GoogleFonts.poppins(
//                         fontSize: isLargeScreen ? 28 : 24,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF111827),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   LayoutBuilder(
//                     builder: (context, constraints) {
//                       return GridView.count(
//                         crossAxisCount: constraints.maxWidth > 800 ? 3 : 1,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         childAspectRatio: 1.4,
//                         children: [
//                           _PaymentMethodCard(
//                             title: 'API Key Payment',
//                             description: 'Secure payment initiation using an API key, ideal for non-PCI DSS merchants.',
//                             details: '''
// **API Key Payment Overview**  
// Initiate payments securely using an API key without handling card data. Perfect for merchants avoiding PCI DSS compliance.  

// **Key Features:**  
// - Uses API key authentication (`x-gl-auth` header).  
// - Sends JSON payload to `/gl/v1/payments/initiate/paycollect`.  
// - Returns a payment link and status link for transaction tracking.  

// **When to Use:**  
// Use for simple, secure payment initiation without complex encryption needs. Ideal for small to medium-sized businesses.  

// **Benefits:**  
// - No PCI DSS compliance required.  
// - Easy integration with minimal setup.  
// - Supports multiple payment methods.  
// - Reliable transaction status tracking.
// ''',
//                             route: '/paycollect/apikey',
//                             icon: Icons.vpn_key,
//                             badge: 'API Key',
//                             badgeColor: const Color(0xFF10B981),
//                             benefits: [
//                               'No PCI DSS compliance needed',
//                               'Simple API key authentication',
//                               'Supports multiple payment methods',
//                               'Easy integration',
//                             ],
//                             largeText: 'API',
//                           ),
//                           _PaymentMethodCard(
//                             title: 'JWT Payment',
//                             description: 'Secure payment initiation using JWT for enhanced security and advanced integrations.',
//                             details: '''
// **JWT Payment Overview**  
// Initiate payments with JWT-based authentication for enhanced security. Suitable for advanced integrations requiring robust encryption.  

// **Key Features:**  
// - Uses JWE/JWS encryption with `x-gl-token-external` header.  
// - Validates `captureTxn` as true for secure processing.  
// - Sends payload to `/gl/v1/payments/initiate/paycollect`.  

// **When to Use:**  
// Use for high-security payment scenarios or integrations requiring JWT-based authentication.  

// **Benefits:**  
// - Enhanced security with JWT.  
// - Ideal for high-security integrations.  
// - Supports one-time payments.  
// - Robust payload validation.
// ''',
//                             route: '/paycollect/jwt',
//                             icon: Icons.lock,
//                             badge: 'JWT Secure',
//                             badgeColor: const Color(0xFF3B82F6),
//                             benefits: [
//                               'Enhanced security with JWT',
//                               'Ideal for advanced integrations',
//                               'Supports one-time payments',
//                               'Robust validation',
//                             ],
//                             largeText: 'JWT',
//                           ),
//                           _PaymentMethodCard(
//                             title: 'SI Payment',
//                             description: 'Enables recurring payments with standing instructions for automated transactions.',
//                             details: '''
// **SI Payment Overview**  
// Set up recurring payments with standing instructions for automated, scheduled transactions. Supports FIXED or VARIABLE payment types.  

// **Key Features:**  
// - Requires `standingInstruction` with type, frequency, and number of payments.  
// - Sends JWE/JWS payload to `/gl/v1/payments/initiate`.  
// - Supports FIXED (with start date) or VARIABLE (no start date) schedules.  

// **When to Use:**  
// Use for subscription-based services or recurring payment scenarios requiring automation.  

// **Benefits:**  
// - Supports recurring payments.  
// - Flexible FIXED or VARIABLE options.  
// - Secure with JWE/JWS encryption.  
// - Customizable payment schedules.
// ''',
//                             route: '/paycollect/si',
//                             icon: Icons.repeat,
//                             badge: 'Recurring',
//                             badgeColor: const Color(0xFFFFA500),
//                             benefits: [
//                               'Supports recurring payments',
//                               'Flexible FIXED/VARIABLE options',
//                               'Secure JWE/JWS encryption',
//                               'Customizable schedules',
//                             ],
//                             largeText: 'SI',
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 48),
//                   FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Text(
//                       'Explore additional services for advanced payment features.',
//                       style: GoogleFonts.notoSans(
//                         fontSize: isLargeScreen ? 16.0 : 14.0,
//                         color: const Color(0xFF4B5563),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           try {
//                             Navigator.pushNamed(context, '/services');
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Services route not found')),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF3B82F6),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                           elevation: 2,
//                         ),
//                         child: Text(
//                           'Explore All Services',
//                           style: GoogleFonts.notoSans(
//                             fontSize: isLargeScreen ? 14.0 : 12.0,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PaymentMethodCard extends StatefulWidget {
//   final String title;
//   final String description;
//   final String details;
//   final String route;
//   final IconData icon;
//   final String badge;
//   final Color badgeColor;
//   final List<String> benefits;
//   final String largeText;

//   const _PaymentMethodCard({
//     required this.title,
//     required this.description,
//     required this.details,
//     required this.route,
//     required this.icon,
//     required this.badge,
//     required this.badgeColor,
//     required this.benefits,
//     required this.largeText,
//   });

//   @override
//   _PaymentMethodCardState createState() => _PaymentMethodCardState();
// }

// class _PaymentMethodCardState extends State<_PaymentMethodCard> with TickerProviderStateMixin {
//   bool _isHovered = false;
//   late AnimationController _dialogAnimationController;
//   late Animation<double> _dialogFadeAnimation;
//   late Animation<double> _dialogScaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _dialogAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     )..forward();
//     _dialogFadeAnimation = CurvedAnimation(
//       parent: _dialogAnimationController,
//       curve: Curves.easeInOut,
//     );
//     _dialogScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _dialogAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _dialogAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth > 800;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
//       child: Card(
//         color: const Color(0xFFF9FAFB),
//         elevation: _isHovered ? 6 : 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: const BorderSide(color: Color(0xFFD1D5DB)),
//         ),
//         child: InkWell(
//           onTap: () {
//             try {
//               Navigator.pushNamed(context, widget.route);
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('${widget.route} route not found')),
//               );
//             }
//           },
//           borderRadius: BorderRadius.circular(12),
//           hoverColor: const Color(0xFFF3F4F6),
//           onHover: (hovered) {
//             setState(() {
//               _isHovered = hovered;
//             });
//           },
//           child: Stack(
//             children: [
//               Positioned(
//                 left: 16,
//                 bottom: 80,
//                 child: Opacity(
//                   opacity: 0.15,
//                   child: Text(
//                     widget.largeText,
//                     style: GoogleFonts.notoSans(
//                       fontSize: isLargeScreen ? 72 : 54,
//                       fontWeight: FontWeight.bold,
//                       color: widget.badgeColor,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.left,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 200),
//                           transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
//                           child: Icon(
//                             widget.icon,
//                             size: isLargeScreen ? 32 : 28,
//                             color: widget.badgeColor,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: widget.badgeColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             widget.badge,
//                             style: GoogleFonts.notoSans(
//                               fontSize: isLargeScreen ? 12 : 11,
//                               fontWeight: FontWeight.w600,
//                               color: widget.badgeColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.title,
//                       style: GoogleFonts.notoSans(
//                         fontSize: isLargeScreen ? 18 : 16,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF111827),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.description,
//                       style: GoogleFonts.notoSans(
//                         fontSize: isLargeScreen ? 14 : 13,
//                         color: const Color(0xFF4B5563),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: widget.benefits.map((benefit) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2.0),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.check_circle,
//                               size: isLargeScreen ? 16 : 14,
//                               color: widget.badgeColor,
//                             ),
//                             const SizedBox(width: 4),
//                             Expanded(
//                               child: Text(
//                                 benefit,
//                                 style: GoogleFonts.notoSans(
//                                   fontSize: isLargeScreen ? 13 : 12,
//                                   color: const Color(0xFF4B5563),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )).toList(),
//                     ),
//                     const Spacer(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Tooltip(
//                           message: 'Learn more about ${widget.title}',
//                           child: ElevatedButton(
//                             onPressed: () => _showDetailsDialog(context),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               foregroundColor: const Color(0xFF3B82F6),
//                               side: const BorderSide(color: Color(0xFF3B82F6)),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                               elevation: _isHovered ? 2 : 0,
//                             ),
//                             child: Text(
//                               'View Details',
//                               style: GoogleFonts.notoSans(
//                                 fontSize: isLargeScreen ? 14 : 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Tooltip(
//                           message: 'Try ${widget.title} now',
//                           child: ElevatedButton(
//                             onPressed: () {
//                               try {
//                                 Navigator.pushNamed(context, widget.route);
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('${widget.route} route not found')),
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF3B82F6),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                               elevation: _isHovered ? 2 : 0,
//                             ),
//                             child: Text(
//                               'Try Now',
//                               style: GoogleFonts.notoSans(
//                                 fontSize: isLargeScreen ? 14 : 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDetailsDialog(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth > 800;
//     final titleFontSize = isLargeScreen ? 18.0 : 16.0;
//     final bodyFontSize = isLargeScreen ? 14.0 : 13.0;
//     final iconSize = isLargeScreen ? 28.0 : 24.0;
//     final padding = isLargeScreen ? 16.0 : 12.0;

//     List<Widget> contentWidgets = [];
//     final lines = widget.details.split('\n');

//     for (var line in lines) {
//       line = line.trim();
//       if (line.isEmpty) {
//         contentWidgets.add(const SizedBox(height: 8));
//         continue;
//       }

//       if (line.startsWith('**') && line.endsWith('**')) {
//         contentWidgets.add(
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Text(
//               line.substring(2, line.length - 2),
//               style: GoogleFonts.poppins(
//                 fontSize: titleFontSize,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF111827),
//               ),
//             ),
//           ),
//         );
//       } else if (line.startsWith('- ')) {
//         contentWidgets.add(
//           Padding(
//             padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   Icons.check_circle,
//                   size: isLargeScreen ? 16 : 14,
//                   color: widget.badgeColor,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     line.substring(2),
//                     style: GoogleFonts.poppins(
//                       fontSize: bodyFontSize,
//                       color: const Color(0xFF4B5563),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       } else {
//         contentWidgets.add(
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Text(
//               line,
//               style: GoogleFonts.poppins(
//                 fontSize: bodyFontSize,
//                 color: const Color(0xFF4B5563),
//               ),
//             ),
//           ),
//         );
//       }
//     }

//     showDialog(
//       context: context,
//       builder: (context) {
//         return FadeTransition(
//           opacity: _dialogFadeAnimation,
//           child: ScaleTransition(
//             scale: _dialogScaleAnimation,
//             child: AlertDialog(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               contentPadding: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               content: Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFF9FAFB), Color(0xFFE5E7EB)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.all(padding),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: widget.badgeColor.withOpacity(0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 widget.icon,
//                                 size: iconSize,
//                                 color: widget.badgeColor,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 widget.title,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: isLargeScreen ? 20 : 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: const Color(0xFF111827),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         ...contentWidgets,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     'Close',
//                     style: GoogleFonts.poppins(
//                       fontSize: isLargeScreen ? 14 : 12,
//                       color: const Color(0xFF4B5563),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 AnimatedScale(
//                   scale: _isHovered ? 1.05 : 1.0,
//                   duration: const Duration(milliseconds: 200),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       try {
//                         Navigator.pushNamed(context, widget.route);
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('${widget.route} route not found')),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3B82F6),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       elevation: 2,
//                     ),
//                     child: Text(
//                       'Try Now',
//                       style: GoogleFonts.poppins(
//                         fontSize: isLargeScreen ? 14 : 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }