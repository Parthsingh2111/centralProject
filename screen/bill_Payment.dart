import 'package:centralproject/utils/pc_payment_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> with SingleTickerProviderStateMixin {
  // Hard-coded current bill data
  final double currentUnits = 250.5;
  final double unitRate = 7.5;
  final double totalExpenditure = 1881.25;
  final String fromDate = "2025-06-01";
  final String toDate = "2025-06-30";
  final int daysUsed = 30;

  // Hard-coded past bills data (last 6 months)
  final List<Map<String, String>> pastBills = [
    {'month': 'June 2025', 'units': '250.5', 'amount': '1881.25', 'paidDate': '2025-07-01'},
    {'month': 'May 2025', 'units': '230.0', 'amount': '1725.00', 'paidDate': '2025-06-01'},
    {'month': 'April 2025', 'units': '260.0', 'amount': '1950.00', 'paidDate': '2025-05-01'},
    {'month': 'March 2025', 'units': '220.5', 'amount': '1653.75', 'paidDate': '2025-04-01'},
    {'month': 'February 2025', 'units': '240.0', 'amount': '1800.00', 'paidDate': '2025-03-01'},
    {'month': 'January 2025', 'units': '235.5', 'amount': '1766.25', 'paidDate': '2025-02-01'},
  ];

  String selectedMonth = 'Select Past Bill';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final titleFontSize = isLargeScreen ? 34.0 : 26.0;
    final subtitleFontSize = isLargeScreen ? 20.0 : 18.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Text(
          'BrightSpark',
          style: GoogleFonts.playfairDisplay(
            fontSize: isLargeScreen ? 30 : 26,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2B2B2B),
          ),
        ),
        actions: [
          if (!isLargeScreen)
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF2B2B2B)),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
        ],
      ),
      endDrawer: isLargeScreen
          ? null
          : Drawer(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    title: Text('Home', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: Text('Bills', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: Text('Support', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFEDE7F6),
                  border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'BrightSpark Electricity Co.',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2B2B2B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Powering Your City with Care',
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Past Bills Dropdown
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'View Past Bills',
                                    style: GoogleFonts.poppins(
                                      fontSize: subtitleFontSize,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2B2B2B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButton<String>(
                                    value: selectedMonth,
                                    isExpanded: true,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'Select Past Bill',
                                        child: Text(
                                          'Select Past Bill',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF757575),
                                          ),
                                        ),
                                      ),
                                      ...pastBills.map<DropdownMenuItem<String>>((bill) {
                                        return DropdownMenuItem<String>(
                                          value: bill['month']!,
                                          child: Text(
                                            bill['month']!,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF2B2B2B),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedMonth = value;
                                        });
                                        if (value != 'Select Past Bill') {
                                          final selectedBill = pastBills.firstWhere(
                                              (bill) => bill['month'] == value);
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16.0),
                                              ),
                                              title: Text(
                                                '${selectedBill['month']} Bill',
                                                style: GoogleFonts.poppins(
                                                  fontSize: subtitleFontSize,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF2B2B2B),
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildBillDetailRow(
                                                    'Units Consumed',
                                                    selectedBill['units']!,
                                                    icon: Icons.bolt,
                                                  ),
                                                  _buildBillDetailRow(
                                                    'Amount Paid',
                                                    '₹${selectedBill['amount']}',
                                                    icon: Icons.payment,
                                                  ),
                                                  _buildBillDetailRow(
                                                    'Paid On',
                                                    selectedBill['paidDate']!,
                                                    icon: Icons.calendar_today,
                                                  ),
                                                  _buildBillDetailRow(
                                                    'Payment Method',
                                                    'PayGlocal',
                                                    icon: Icons.credit_card,
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text(                          
                                                    'Close',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF2B2B2B),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF2B2B2B),
                                    ),
                                    underline: const SizedBox(),
                                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2B2B2B)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Current Bill Card
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.bolt,
                                        color: Color(0xFFE57373),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Current Bill',
                                        style: GoogleFonts.poppins(
                                          fontSize: subtitleFontSize,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF2B2B2B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Bill Period: $fromDate to $toDate ($daysUsed days)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF424242),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildBillDetailRow(
                                    'Units Consumed',
                                    '$currentUnits',
                                    icon: Icons.electric_meter,
                                  ),
                                  _buildBillDetailRow(
                                    'Rate per Unit',
                                    '₹$unitRate',
                                    icon: Icons.monetization_on,
                                  ),
                                  const Divider(height: 24, thickness: 1),
                                  _buildBillDetailRow(
                                    'Total Amount',
                                    '₹$totalExpenditure',
                                    icon: Icons.account_balance_wallet,
                                    isBold: true,
                                    textColor: const Color(0xFFE57373),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Pay Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Bill Paid via PayGlocal',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  backgroundColor: const Color(0xFF4CAF50),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            handlePcVariableSIPayment(totalExpenditure.toString(),context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B2B2B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              elevation: 0,
                            ),
                            child: Text(
                              'Pay with PayGlocal',
                              style: GoogleFonts.poppins(
                                fontSize: isLargeScreen ? 18 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Terms and Conditions
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Terms and Conditions',
                                    style: GoogleFonts.poppins(
                                      fontSize: subtitleFontSize,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2B2B2B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '1. Payments must be made by the due date to avoid late fees.\n'
                                    '2. Bills are calculated based on meter readings and applicable tariffs.\n'
                                    '3. PayGlocal transactions are secure and processed instantly.\n'
                                    '4. Contact BrightSpark Electricity Co. at support@brightspark.com for disputes.\n',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF424242),
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Standing Instruction Note
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                color: const Color(0xFF2B2B2B),
                child: Column(
                  children: [
                    Text(
                      'BrightSpark Electricity Co.',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: isLargeScreen ? 26 : 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFooterLink('About Us', () {}),
                        _buildFooterLink('Contact Us', () {}),
                        _buildFooterLink('Privacy Policy', () {}),
                        _buildFooterLink('Terms of Service', () {}),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '© 2025 BrightSpark. All rights reserved.',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
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

  Widget _buildBillDetailRow(String label, String value,
      {IconData? icon, bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFFE57373), size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF424242),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: textColor ?? const Color(0xFF2B2B2B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
      ),
    );
  }
}