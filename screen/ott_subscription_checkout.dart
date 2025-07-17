import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:centralproject/utils/pc_payment_utils.dart';
import 'package:uuid/uuid.dart';

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price; // Base price in INR
  final String quality;
  final String devices;
  final List<String> benefits;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quality,
    required this.devices,
    required this.benefits,
  });
}

class OttSubscriptionCheckoutScreen extends StatefulWidget {
  const OttSubscriptionCheckoutScreen({Key? key}) : super(key: key);

  @override
  _OttSubscriptionCheckoutScreenState createState() => _OttSubscriptionCheckoutScreenState();
}

class _OttSubscriptionCheckoutScreenState extends State<OttSubscriptionCheckoutScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _selectedCurrency = 'INR';
  String? _selectedPlanId;
  bool _isLoading = false;

  final Map<String, double> _currencyRates = {
    'INR': 1.0,
    'USD': 0.012,
    'EUR': 0.011,
  };

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      id: const Uuid().v4(),
      name: 'Basic',
      description: 'Stream in standard definition on one device at a time.',
      price: 199.0,
      quality: 'SD (480p)',
      devices: '1 Device',
      benefits: ['Unlimited Streaming', 'No Ads', 'Mobile App Access'],
    ),
    SubscriptionPlan(
      id: const Uuid().v4(),
      name: 'Standard',
      description: 'Stream in high definition on two devices simultaneously.',
      price: 499.0,
      quality: 'HD (1080p)',
      devices: '2 Devices',
      benefits: ['Unlimited Streaming', 'No Ads', 'HD Quality', 'Multi-Device Support'],
    ),
    SubscriptionPlan(
      id: const Uuid().v4(),
      name: 'Premium',
      description: 'Stream in ultra HD on four devices with offline downloads.',
      price: 649.0,
      quality: '4K + HDR',
      devices: '4 Devices',
      benefits: ['Unlimited Streaming', 'No Ads', '4K + HDR', 'Offline Downloads', '4 Devices'],
    ),
  ];

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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String getCurrencySymbol() {
    switch (_selectedCurrency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return '₹';
    }
  }

  void _handlePayment(SubscriptionPlan plan) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final totalAmount = (plan.price * _currencyRates[_selectedCurrency]!).toStringAsFixed(2);
      await handlePcFixedSIPayment(
        totalAmount,
        _selectedCurrency,
        context,
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFEDE7F6), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Confirm Subscription Now?',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2B2B2B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your ${plan.name} subscription is ready. Enjoy streaming with ${getCurrencySymbol()}$totalAmount/month!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFF616161),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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
                      'Confirm Subscription with PayGlocal',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error setting up subscription: $e',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            backgroundColor: const Color(0xFFE57373),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final titleFontSize = isLargeScreen ? 32.0 : 24.0;
    final subtitleFontSize = isLargeScreen ? 18.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Text(
          'StreamSphere',
          style: GoogleFonts.playfairDisplay(
            fontSize: isLargeScreen ? 28 : 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2B2B2B),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedCurrency,
              items: ['INR', 'USD', 'EUR']
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(
                          currency,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF2B2B2B),
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
              underline: const SizedBox(),
              icon: const Icon(Icons.monetization_on, color: Color(0xFF2B2B2B)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDE7F6),
                        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
                      ),
                      child: Column(
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              'Choose Your Subscription Plan',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2B2B2B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enjoy unlimited streaming with our flexible monthly plans.',
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              color: const Color(0xFF616161),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth > 1200 ? 32 : 16,
                        vertical: 18,
                      ),
                      child: LayoutBuilder(
                        builder: (context, gridConstraints) {
                          final crossAxisCount = gridConstraints.maxWidth > 1200
                              ? 3
                              : gridConstraints.maxWidth > 600
                                  ? 2
                                  : 1;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.97,
                            children: plans.map((plan) {
                              return _PlanCard(
                                plan: plan,
                                isSelected: _selectedPlanId == plan.id,
                                selectedCurrency: _selectedCurrency,
                                currencyRate: _currencyRates[_selectedCurrency]!,
                                onSelect: () {
                                  setState(() {
                                    _selectedPlanId = plan.id;
                                  });
                                },
                                onSubscribe: () => _handlePayment(plan),
                                isLoading: _isLoading && _selectedPlanId == plan.id,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      color: const Color(0xFF2B2B2B),
                      child: Column(
                        children: [
                          Text(
                            'StreamSphere',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: isLargeScreen ? 24 : 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 24,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildFooterLink('About Us', () {}),
                              _buildFooterLink('Privacy Policy', () {}),
                              _buildFooterLink('Terms of Service', () {}),
                              _buildFooterLink('Contact Us', () {}),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '© 2025 StreamSphere. All rights reserved.',
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooterLink(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PlanCard extends StatefulWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final String selectedCurrency;
  final double currencyRate;
  final VoidCallback onSelect;
  final VoidCallback onSubscribe;
  final bool isLoading;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.selectedCurrency,
    required this.currencyRate,
    required this.onSelect,
    required this.onSubscribe,
    required this.isLoading,
  });

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<_PlanCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  String getCurrencySymbol() {
    switch (widget.selectedCurrency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return '₹';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final convertedPrice = widget.plan.price * widget.currencyRate;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              color: Colors.white,
              elevation: _isHovered || widget.isSelected ? 8 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: widget.isSelected ? const Color(0xFFE57373) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: widget.onSelect,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.plan.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: isLargeScreen ? 22 : 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2B2B2B),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE57373),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.plan.name,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${getCurrencySymbol()}${convertedPrice.toStringAsFixed(2)}/month',
                        style: GoogleFonts.poppins(
                          fontSize: isLargeScreen ? 18 : 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE57373),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.plan.description,
                        style: GoogleFonts.poppins(
                          fontSize: isLargeScreen ? 16 : 14,
                          color: const Color(0xFF616161),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Quality: ${widget.plan.quality}',
                        style: GoogleFonts.poppins(
                          fontSize: isLargeScreen ? 16 : 14,
                          color: const Color(0xFF2B2B2B),
                        ),
                      ),
                      Text(
                        'Devices: ${widget.plan.devices}',
                        style: GoogleFonts.poppins(
                          fontSize: isLargeScreen ? 16 : 14,
                          color: const Color(0xFF2B2B2B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Benefits:',
                        style: GoogleFonts.poppins(
                          fontSize: isLargeScreen ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2B2B2B),
                        ),
                      ),
                      ...widget.plan.benefits.map((benefit) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFF4CAF50),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: GoogleFonts.poppins(
                                      fontSize: isLargeScreen ? 14 : 13,
                                      color: const Color(0xFF616161),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const Spacer(),
                      Center(
                        child: ElevatedButton(
                          onPressed: widget.isLoading ? null : widget.onSubscribe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B2B2B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          child: widget.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Subscribe Now',
                                  style: GoogleFonts.poppins(
                                    fontSize: isLargeScreen ? 14 : 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}