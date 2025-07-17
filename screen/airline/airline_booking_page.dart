// import 'package:centralproject/providers/flight_booking_provider.dart';
import 'package:centralproject/screen/airline_interface.dart';
import 'package:centralproject/widgets/airline/currency_selector.dart';
import 'package:centralproject/widgets/airline/date_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class AirlineBookingPage extends StatefulWidget {
  const AirlineBookingPage({Key? key}) : super(key: key);

  @override
  _AirlineBookingPageState createState() => _AirlineBookingPageState();
}

class _AirlineBookingPageState extends State<AirlineBookingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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

  final List<String> tripTypes = ['One-way', 'Round-trip', 'Multi-city'];

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final titleFontSize = isLargeScreen ? 32.0 : 24.0;
    final subtitleFontSize = isLargeScreen ? 18.0 : 16.0;
    final provider = Provider.of<FlightBookingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 11, 9, 9),
                Color.fromARGB(255, 52, 51, 51),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
        title: Row(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'SkyWings Airlines',
                style: GoogleFonts.playfairDisplay(
                  fontSize: isLargeScreen ? 28 : 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (isLargeScreen)
              Row(
                children: [
                  _buildNavItem('Home', () => Navigator.pop(context)),
                  const SizedBox(width: 24),
                  _buildNavItem('Book', () {}),
                  const SizedBox(width: 24),
                  _buildNavItem('About', () {}),
                  const SizedBox(width: 24),
                  _buildNavItem('Contact', () {}),
                ],
              ),
          ],
        ),
        actions: [
          if (!isLargeScreen)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
        ],
      ),
      endDrawer: isLargeScreen
          ? null
          : Drawer(
              backgroundColor: Colors.black.withOpacity(0.7),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    title: Text('Home', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: Text('Book', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: Text('About', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: Text('Contact', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landscape-shot-brooklyn-bridge-new-usa-with-gray-gloomy-sky.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Book Your Journey',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fly with elegance and comfort',
                          style: GoogleFonts.poppins(fontSize: subtitleFontSize, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CurrencySelector(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      color: Colors.white.withOpacity(0.8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: tripTypes.map((type) {
                            return ChoiceChip(
                              label: Text(type, style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                              selected: provider.tripType == type,
                              onSelected: (selected) {
                                if (selected) {
                                  provider.updateTripType(type);
                                  if (type == 'Multi-city') {
                                    Navigator.pushNamed(context, '/multi_city');
                                  }
                                }
                              },
                              selectedColor: Color.fromARGB(255, 11, 11, 11),
                              backgroundColor: Color.fromARGB(255, 102, 100, 100),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              elevation: 2,
                              checkmarkColor: Colors.white,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  if (provider.tripType == 'One-way' || provider.tripType == 'Round-trip')
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Card(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  AirportSelector(
                                    label: 'From',
                                    value: provider.from.isEmpty ? 'Select your departure' : provider.from,
                                    onTap: () => _showDestinationDialog(context, provider, true, provider.departureCities),
                                  ),
                                  const Divider(color: Color(0xFFE0E0E0), thickness: 1),
                                  AirportSelector(
                                    label: 'To',
                                    value: provider.to.isEmpty ? 'Select your destination' : provider.to,
                                    onTap: () => _showDestinationDialog(context, provider, false, provider.destinationCities),
                                  ),
                                  const Divider(color: Color(0xFFE0E0E0), thickness: 1),
                                  DateSelector(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (provider.from.isNotEmpty && provider.to.isNotEmpty && provider.departureDate != null) {
                                    Navigator.pushNamed(context, '/flight_results');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please select departure, destination, and date')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 12, 12, 12),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Search Flights',
                                  style: GoogleFonts.poppins(fontSize: isLargeScreen ? 16 : 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                    color: Colors.black.withOpacity(0.7),
                    child: Column(
                      children: [
                        Text(
                          'SkyWings Airlines',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: isLargeScreen ? 24 : 20,
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
                            _buildFooterLink('Privacy Policy', () {}),
                            _buildFooterLink('Terms of Service', () {}),
                            _buildFooterLink('Contact Us', () {}),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '© 2025 SkyWings Airlines. All rights reserved.',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  Widget _buildFooterLink(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _showDestinationDialog(
    BuildContext context,
    FlightBookingProvider provider,
    bool isFrom,
    List<Map<String, String>> cities,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 68, 64, 64),
        title: Text(
          isFrom ? 'Select Departure' : 'Select Destination',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: cities.map((d) {
              final selectedCity = '${d['code']} — ${d['city']}';
              return ListTile(
                leading: const Icon(Icons.flight, color: Colors.white),
                title: Text('${d['city']}, ${d['country']}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                subtitle: Text(d['airport']!, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54)),
                onTap: () {
                  if (!isFrom && provider.from == selectedCity) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Departure and destination cities cannot be the same')),
                    );
                    return;
                  }
                  if (isFrom) {
                    provider.updateFrom(selectedCity);
                  } else {
                    provider.updateTo(selectedCity);
                  }
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}