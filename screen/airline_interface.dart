import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:centralproject/utils/pc_payment_utils.dart';

class FlightBookingProvider extends ChangeNotifier {
  String _tripType = '';
  String _currency = 'INR';
  String _from = '';
  String _to = '';
  DateTime? _departureDate;
  DateTime? _returnDate;
  int _passengers = 1;
  String _travelClass = 'Economy';
  List<Map<String, dynamic>> _multiCitySegments = [
    {'from': null, 'to': null, 'date': null},
  ];
  List<Map<String, dynamic>> _selectedMultiCityFlights = [];
  List<String> _selectedMultiCityClasses = [];

  final Map<String, double> currencyRates = {
    'INR': 1.0,
    'USD': 0.012,
    'EUR': 0.011,
  };

  // Getters
  String get tripType => _tripType;
  String get currency => _currency;
  String get from => _from;
  String get to => _to;
  DateTime? get departureDate => _departureDate;
  DateTime? get returnDate => _returnDate;
  int get passengers => _passengers;
  String get travelClass => _travelClass;
  List<Map<String, dynamic>> get multiCitySegments => _multiCitySegments;
  List<Map<String, dynamic>> get selectedMultiCityFlights =>
      _selectedMultiCityFlights;
  List<String> get selectedMultiCityClasses => _selectedMultiCityClasses;

  // Utility method to get currency symbol
  String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return '₹';
    }
  }

  // Update methods
  void updateTripType(String type) {
    _tripType = type;
    notifyListeners();
  }

  void updateCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void updateFrom(String from) {
    _from = from;
    notifyListeners();
  }

  void updateTo(String to) {
    _to = to;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _departureDate = date;
    notifyListeners();
  }

  void updateReturnDate(DateTime? date) {
    _returnDate = date;
    notifyListeners();
  }

  void updatePassengers(int passengers) {
    _passengers = passengers;
    notifyListeners();
  }

  void updateTravelClass(String travelClass) {
    _travelClass = travelClass;
    notifyListeners();
  }

  void addMultiCitySegment() {
    if (_multiCitySegments.length < 5) {
      _multiCitySegments.add({'from': null, 'to': null, 'date': null});
      notifyListeners();
    }
  }

  void updateMultiCitySegment(int index, String key, dynamic value) {
    if (index >= 0 && index < _multiCitySegments.length) {
      _multiCitySegments[index][key] = value;
      notifyListeners();
    }
  }

  void removeMultiCitySegment(int index) {
    if (index > 0 && index < _multiCitySegments.length) {
      _multiCitySegments.removeAt(index);
      if (_selectedMultiCityFlights.length > index) {
        _selectedMultiCityFlights.removeAt(index);
        _selectedMultiCityClasses.removeAt(index);
      }
      notifyListeners();
    }
  }

  void selectMultiCityFlight(
    int segmentIndex,
    Map<String, dynamic> flight,
    String travelClass,
  ) {
    if (segmentIndex >= 0 && segmentIndex < _multiCitySegments.length) {
      if (_selectedMultiCityFlights.length <= segmentIndex) {
        _selectedMultiCityFlights.add(flight);
        _selectedMultiCityClasses.add(travelClass);
      } else {
        _selectedMultiCityFlights[segmentIndex] = flight;
        _selectedMultiCityClasses[segmentIndex] = travelClass;
      }
      notifyListeners();
    }
  }
}

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
  final List<String> currencies = ['INR', 'USD', 'EUR'];
  final Map<String, double> currencyRates = {
    'INR': 1.0,
    'USD': 0.012,
    'EUR': 0.011,
  };

  final List<Map<String, String>> departureCities = [
    {
      'city': 'Mumbai',
      'country': 'India',
      'airport': 'Chhatrapati Shivaji Airport',
      'code': 'BOM',
    },
    {
      'city': 'Delhi',
      'country': 'India',
      'airport': 'Indira Gandhi Airport',
      'code': 'DEL',
    },
    {
      'city': 'Kolkata',
      'country': 'India',
      'airport': 'Netaji Subhas Chandra Airport',
      'code': 'CCU',
    },
    {
      'city': 'Chennai',
      'country': 'India',
      'airport': 'Chennai Airport',
      'code': 'MAA',
    },
    {
      'city': 'Bengaluru',
      'country': 'India',
      'airport': 'Kempegowda Airport',
      'code': 'BLR',
    },
    {
      'city': 'Hyderabad',
      'country': 'India',
      'airport': 'Rajiv Gandhi Airport',
      'code': 'HYD',
    },
    {
      'city': 'Ahmedabad',
      'country': 'India',
      'airport': 'Sardar Vallabhbhai Patel Airport',
      'code': 'AMD',
    },
    {
      'city': 'Pune',
      'country': 'India',
      'airport': 'Pune Airport',
      'code': 'PNQ',
    },
  ];

  final List<Map<String, String>> destinationCities = [
    {
      'city': 'New York',
      'country': 'USA',
      'airport': 'John F. Kennedy Airport',
      'code': 'JFK',
    },
    {
      'city': 'London',
      'country': 'UK',
      'airport': 'Heathrow Airport',
      'code': 'LHR',
    },
    {
      'city': 'Paris',
      'country': 'France',
      'airport': 'Charles de Gaulle Airport',
      'code': 'CDG',
    },
    {
      'city': 'Amsterdam',
      'country': 'Netherlands',
      'airport': 'Schiphol Airport',
      'code': 'AMS',
    },
    {
      'city': 'Frankfurt',
      'country': 'Germany',
      'airport': 'Frankfurt Airport',
      'code': 'FRA',
    },
    {
      'city': 'Chicago',
      'country': 'USA',
      'airport': 'O\'Hare Airport',
      'code': 'ORD',
    },
    {
      'city': 'Los Angeles',
      'country': 'USA',
      'airport': 'Los Angeles Airport',
      'code': 'LAX',
    },
    {
      'city': 'Rome',
      'country': 'Italy',
      'airport': 'Leonardo da Vinci Airport',
      'code': 'FCO',
    },
  ];

  String getCurrencySymbol(String currency) {
    switch (currency) {
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
    final titleFontSize = isLargeScreen ? 32.0 : 24.0;
    final subtitleFontSize = isLargeScreen ? 18.0 : 16.0;

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
                const Color.fromARGB(255, 11, 9, 9).withOpacity(0.2),
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
      endDrawer:
          isLargeScreen
              ? null
              : Drawer(
                backgroundColor: Colors.black.withOpacity(0.7),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ListTile(
                      title: Text(
                        'Home',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Book',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      title: Text(
                        'About',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      title: Text(
                        'Contact',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
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
                image: AssetImage(
                  'assets/images/landscape-shot-brooklyn-bridge-new-usa-with-gray-gloomy-sky.jpg',
                ),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 16,
                    ),
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
                          style: GoogleFonts.poppins(
                            fontSize: subtitleFontSize,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer<FlightBookingProvider>(
                          builder:
                              (context, provider, child) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: PopupMenuButton<String>(
                                  initialValue: provider.currency,
                                  onSelected: (value) {
                                    provider.updateCurrency(value);
                                  },
                                  itemBuilder:
                                      (context) =>
                                          currencies
                                              .map(
                                                (currency) => PopupMenuItem(
                                                  value: currency,
                                                  child: Text(
                                                    currency,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          provider.currency,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Color.fromARGB(255, 5, 5, 5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      color: Colors.white.withOpacity(0.8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children:
                              tripTypes.map((type) {
                                return ChoiceChip(
                                  label: Text(
                                    type,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: const Color.fromARGB(
                                        255,
                                        249,
                                        248,
                                        248,
                                      ),
                                    ),
                                  ),
                                  selected:
                                      Provider.of<FlightBookingProvider>(
                                        context,
                                      ).tripType ==
                                      type,
                                  onSelected: (selected) {
                                    if (selected) {
                                      Provider.of<FlightBookingProvider>(
                                        context,
                                        listen: false,
                                      ).updateTripType(type);
                                      if (type == 'Multi-city') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    MultiCityBookingPage(),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  selectedColor: Color.fromARGB(
                                    255,
                                    11,
                                    11,
                                    11,
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    102,
                                    100,
                                    100,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  elevation: 2,
                                  checkmarkColor: Colors.white,
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Consumer<FlightBookingProvider>(
                    builder:
                        (context, provider, child) =>
                            (provider.tripType == 'One-way' ||
                                    provider.tripType == 'Round-trip')
                                ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Card(
                                        color: Colors.white.withOpacity(0.8),
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              AirportSelector(
                                                label: 'From',
                                                value:
                                                    provider.from.isEmpty
                                                        ? 'Select your departure'
                                                        : provider.from,
                                                onTap:
                                                    () =>
                                                        _showDestinationDialog(
                                                          context,
                                                          provider,
                                                          true,
                                                          departureCities,
                                                        ),
                                              ),
                                              const Divider(
                                                color: Color(0xFFE0E0E0),
                                                thickness: 1,
                                              ),
                                              AirportSelector(
                                                label: 'To',
                                                value:
                                                    provider.to.isEmpty
                                                        ? 'Select your destination'
                                                        : provider.to,
                                                onTap:
                                                    () =>
                                                        _showDestinationDialog(
                                                          context,
                                                          provider,
                                                          false,
                                                          destinationCities,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Card(
                                        color: Colors.white.withOpacity(0.8),
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 12,
                                              ),
                                          leading: const Icon(
                                            Icons.calendar_today,
                                            color: Color.fromARGB(
                                              255,
                                              15,
                                              15,
                                              15,
                                            ),
                                            size: 28,
                                          ),
                                          title: Text(
                                            provider.departureDate == null
                                                ? 'Select Date'
                                                : provider.tripType == 'One-way'
                                                ? DateFormat(
                                                  'dd MMM yyyy',
                                                ).format(
                                                  provider.departureDate!,
                                                )
                                                : '${DateFormat('dd MMM yyyy').format(provider.departureDate!)} - ${provider.returnDate != null ? DateFormat('dd MMM yyyy').format(provider.returnDate!) : 'Select Return'}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${provider.passengers} Passenger${provider.passengers > 1 ? 's' : ''}, ${provider.travelClass}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color.fromARGB(
                                              255,
                                              10,
                                              10,
                                              10,
                                            ),
                                          ),
                                          onTap:
                                              () => _showDatePicker(
                                                context,
                                                provider,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      child: Center(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 300,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (provider.from.isNotEmpty &&
                                                  provider.to.isNotEmpty &&
                                                  provider.departureDate !=
                                                      null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => FlightResultsPage(
                                                          from: provider.from,
                                                          to: provider.to,
                                                          departureDate:
                                                              provider
                                                                  .departureDate!,
                                                          returnDate:
                                                              provider
                                                                  .returnDate,
                                                        ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Please select departure, destination, and date',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                255,
                                                12,
                                                12,
                                                12,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32,
                                                    vertical: 16,
                                                  ),
                                              elevation: 2,
                                              shadowColor: Colors.black
                                                  .withOpacity(0.3),
                                            ),
                                            child: Text(
                                              'Search Flights',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    isLargeScreen ? 16 : 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : SizedBox.shrink(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 16,
                    ),
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
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.black45, blurRadius: 2, offset: Offset(1, 1)),
          ],
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

  void _showDestinationDialog(
    BuildContext context,
    FlightBookingProvider provider,
    bool isFrom,
    List<Map<String, String>> cities,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 68, 64, 64),
            title: Text(
              isFrom ? 'Select Departure' : 'Select Destination',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 248, 247, 247),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    cities.map((d) {
                      return ListTile(
                        leading: const Icon(
                          Icons.flight,
                          color: Color.fromARGB(255, 245, 244, 244),
                        ),
                        title: Text(
                          '${d['city']}, ${d['country']}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 246, 244, 244),
                          ),
                        ),
                        subtitle: Text(
                          d['airport']!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color.fromARGB(137, 197, 193, 193),
                          ),
                        ),
                        onTap: () {
                          if (isFrom) {
                            provider.updateFrom('${d['code']} — ${d['city']}');
                          } else {
                            provider.updateTo('${d['code']} — ${d['city']}');
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

  void _showDatePicker(BuildContext context, FlightBookingProvider provider) {
    final Map<DateTime, double> economyPrices = {
      for (int i = 0; i < 90; i++)
        DateTime.now().add(Duration(days: i)): 45000 + (i % 3) * 3000.0,
    };

    if (provider.tripType == 'One-way') {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 90)),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 9, 10, 10),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textTheme: TextTheme(
                headlineSmall: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                bodyMedium: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                bodySmall: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            child: child!,
          );
        },
      ).then((date) {
        if (date != null) {
          provider.updateDate(date);
          provider.updateReturnDate(null);
          final price =
              economyPrices[DateTime(date.year, date.month, date.day)] ?? 45000;
          final convertedPrice =
              price * (currencyRates[provider.currency] ?? 1.0);
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.8),
                  content: Card(
                    color: Colors.white.withOpacity(0.8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selected Date',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('dd MMM yyyy').format(date),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Economy Price: ${getCurrencySymbol(provider.currency)}${convertedPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 7, 7, 6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 5, 5, 5),
                        ),
                      ),
                    ),
                  ],
                ),
          );
        }
      });
    } else {
      showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 90)),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 5, 7, 7),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textTheme: TextTheme(
                headlineSmall: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                bodyMedium: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                bodySmall: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            child: child!,
          );
        },
      ).then((range) {
        if (range != null) {
          provider.updateDate(range.start);
          provider.updateReturnDate(range.end);
          final startPrice =
              economyPrices[DateTime(
                range.start.year,
                range.start.month,
                range.start.day,
              )] ??
              45000;
          final endPrice =
              economyPrices[DateTime(
                range.end.year,
                range.end.month,
                range.end.day,
              )] ??
              48000;
          final convertedStartPrice =
              startPrice * (currencyRates[provider.currency] ?? 1.0);
          final convertedEndPrice =
              endPrice * (currencyRates[provider.currency] ?? 1.0);
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.8),
                  content: Card(
                    color: Colors.white.withOpacity(0.8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selected Dates',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Departure: ${DateFormat('dd MMM yyyy').format(range.start)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Return: ${DateFormat('dd MMM yyyy').format(range.end)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Economy Price: ${getCurrencySymbol(provider.currency)}${convertedStartPrice.toStringAsFixed(2)} - ${convertedEndPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 9, 9, 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 11, 11, 11),
                        ),
                      ),
                    ),
                  ],
                ),
          );
        }
      });
    }
  }
}

class AirportSelector extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const AirportSelector({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.flight_takeoff,
              color: Color.fromARGB(255, 5, 6, 6),
              size: 28,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MultiCityBookingPage extends StatefulWidget {
  const MultiCityBookingPage({Key? key}) : super(key: key);

  @override
  _MultiCityBookingPageState createState() => _MultiCityBookingPageState();
}

class _MultiCityBookingPageState extends State<MultiCityBookingPage> {
  final List<Map<String, String>> departureCities = [
    {
      'city': 'Mumbai',
      'country': 'India',
      'airport': 'Chhatrapati Shivaji Airport',
      'code': 'BOM',
    },
    {
      'city': 'Delhi',
      'country': 'India',
      'airport': 'Indira Gandhi Airport',
      'code': 'DEL',
    },
    {
      'city': 'Kolkata',
      'country': 'India',
      'airport': 'Netaji Subhas Chandra Airport',
      'code': 'CCU',
    },
    {
      'city': 'Chennai',
      'country': 'India',
      'airport': 'Chennai Airport',
      'code': 'MAA',
    },
    {
      'city': 'Bengaluru',
      'country': 'India',
      'airport': 'Kempegowda Airport',
      'code': 'BLR',
    },
    {
      'city': 'Hyderabad',
      'country': 'India',
      'airport': 'Rajiv Gandhi Airport',
      'code': 'HYD',
    },
    {
      'city': 'Ahmedabad',
      'country': 'India',
      'airport': 'Sardar Vallabhbhai Patel Airport',
      'code': 'AMD',
    },
    {
      'city': 'Pune',
      'country': 'India',
      'airport': 'Pune Airport',
      'code': 'PNQ',
    },
  ];

  final List<Map<String, String>> destinationCities = [
    {
      'city': 'New York',
      'country': 'USA',
      'airport': 'John F. Kennedy Airport',
      'code': 'JFK',
    },
    {
      'city': 'London',
      'country': 'UK',
      'airport': 'Heathrow Airport',
      'code': 'LHR',
    },
    {
      'city': 'Paris',
      'country': 'France',
      'airport': 'Charles de Gaulle Airport',
      'code': 'CDG',
    },
    {
      'city': 'Amsterdam',
      'country': 'Netherlands',
      'airport': 'Schiphol Airport',
      'code': 'AMS',
    },
    {
      'city': 'Frankfurt',
      'country': 'Germany',
      'airport': 'Frankfurt Airport',
      'code': 'FRA',
    },
    {
      'city': 'Chicago',
      'country': 'USA',
      'airport': 'O\'Hare Airport',
      'code': 'ORD',
    },
    {
      'city': 'Los Angeles',
      'country': 'USA',
      'airport': 'Los Angeles Airport',
      'code': 'LAX',
    },
    {
      'city': 'Rome',
      'country': 'Italy',
      'airport': 'Leonardo da Vinci Airport',
      'code': 'FCO',
    },
  ];

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
                Color.fromARGB(255, 11, 12, 12),
                Color.fromARGB(255, 10, 14, 16),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
        title: Text(
          'Multi-City Booking',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/landscape-shot-brooklyn-bridge-new-usa-with-gray-gloomy-sky.jpg',
                ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Consumer<FlightBookingProvider>(
                builder:
                    (context, provider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan Your Multi-City Journey',
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
                        const SizedBox(height: 8),
                        Text(
                          'Add up to 5 flights',
                          style: GoogleFonts.poppins(
                            fontSize: subtitleFontSize,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...List.generate(provider.multiCitySegments.length, (
                          index,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Card(
                              color: Colors.white.withOpacity(0.8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Flight ${index + 1}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (index >
                                            0) // Show remove button for all segments except the first
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                            onPressed: () {
                                              provider.removeMultiCitySegment(
                                                index,
                                              );
                                            },
                                            tooltip: 'Remove Flight',
                                          ),
                                      ],
                                    ),

                                    // void removeMultiCitySegment(int index) {
                                    //     if (index > 0 && index < _multiCitySegments.length) {
                                    //       _multiCitySegments.removeAt(index);
                                    //       if (_selectedMultiCityFlights.length > index) {
                                    //         _selectedMultiCityFlights.removeAt(index);
                                    //         _selectedMultiCityClasses.removeAt(index);
                                    //       }
                                    //       notifyListeners();
                                    //     }
                                    //   }
                                    // }
                                    const SizedBox(height: 12),
                                    AirportSelector(
                                      label: 'From',
                                      value:
                                          provider
                                              .multiCitySegments[index]['from'] ??
                                          'Select departure',
                                      onTap:
                                          () => _showDestinationDialog(
                                            context,
                                            provider,
                                            true,
                                            departureCities,
                                            index,
                                          ),
                                    ),
                                    const Divider(
                                      color: Color(0xFFE0E0E0),
                                      thickness: 1,
                                    ),
                                    AirportSelector(
                                      label: 'To',
                                      value:
                                          provider
                                              .multiCitySegments[index]['to'] ??
                                          'Select destination',
                                      onTap:
                                          () => _showDestinationDialog(
                                            context,
                                            provider,
                                            false,
                                            destinationCities,
                                            index,
                                          ),
                                    ),
                                    const Divider(
                                      color: Color(0xFFE0E0E0),
                                      thickness: 1,
                                    ),
                                    InkWell(
                                      onTap:
                                          () => _showDatePickerForSegment(
                                            context,
                                            provider,
                                            index,
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              color: Color.fromARGB(
                                                255,
                                                5,
                                                6,
                                                6,
                                              ),
                                              size: 28,
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Departure Date',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  provider.multiCitySegments[index]['date'] !=
                                                          null
                                                      ? DateFormat(
                                                        'dd MMM yyyy',
                                                      ).format(
                                                        provider
                                                            .multiCitySegments[index]['date'],
                                                      )
                                                      : 'Select date',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        if (provider.multiCitySegments.length < 5)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  provider.addMultiCitySegment();
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Add Flight',
                                  style: GoogleFonts.poppins(
                                    fontSize: isLargeScreen ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    12,
                                    12,
                                    12,
                                  ),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Card(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 5, 6, 6),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '1 Adult',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: ElevatedButton(
                                onPressed: () {
                                  bool isValid = provider.multiCitySegments
                                      .every(
                                        (segment) =>
                                            segment['from'] != null &&
                                            segment['to'] != null &&
                                            segment['date'] != null,
                                      );
                                  if (isValid) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MultiCityResultsPage(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please complete all flight details',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    12,
                                    12,
                                    12,
                                  ),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  elevation: 2,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                ),
                                child: Text(
                                  'Search Flights',
                                  style: GoogleFonts.poppins(
                                    fontSize: isLargeScreen ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDestinationDialog(
    BuildContext context,
    FlightBookingProvider provider,
    bool isFrom,
    List<Map<String, String>> cities,
    int segmentIndex,
  ) {
    String? autoFilledFrom;
    if (isFrom && segmentIndex > 0) {
      autoFilledFrom = provider.multiCitySegments[segmentIndex - 1]['to'];
      provider.updateMultiCitySegment(segmentIndex, 'from', autoFilledFrom);
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 68, 64, 64),
            title: Text(
              isFrom ? 'Select Departure' : 'Select Destination',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 248, 247, 247),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    cities.map((d) {
                      final selectedCity = '${d['code']} — ${d['city']}';
                      return ListTile(
                        leading: const Icon(
                          Icons.flight,
                          color: Color.fromARGB(255, 245, 244, 244),
                        ),
                        title: Text(
                          '${d['city']}, ${d['country']}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 246, 244, 244),
                          ),
                        ),
                        subtitle: Text(
                          d['airport']!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color.fromARGB(137, 197, 193, 193),
                          ),
                        ),
                        onTap: () {
                          if (!isFrom &&
                              provider.multiCitySegments[segmentIndex]['from'] ==
                                  selectedCity) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Departure and destination cities cannot be the same',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          provider.updateMultiCitySegment(
                            segmentIndex,
                            isFrom ? 'from' : 'to',
                            selectedCity,
                          );
                          if (!isFrom &&
                              segmentIndex <
                                  provider.multiCitySegments.length - 1) {
                            provider.updateMultiCitySegment(
                              segmentIndex + 1,
                              'from',
                              selectedCity,
                            );
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

  void _showDatePickerForSegment(
    BuildContext context,
    FlightBookingProvider provider,
    int segmentIndex,
  ) {
    DateTime firstDate = DateTime.now();
    if (segmentIndex > 0) {
      final previousDate =
          provider.multiCitySegments[segmentIndex - 1]['date'] as DateTime?;
      if (previousDate != null) {
        firstDate = previousDate.add(Duration(days: 1));
      }
    }

    showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 9, 10, 10),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: TextTheme(
              headlineSmall: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              bodyMedium: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
              bodySmall: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        if (segmentIndex > 0) {
          final previousDate =
              provider.multiCitySegments[segmentIndex - 1]['date'] as DateTime?;
          if (previousDate != null &&
              date.isBefore(previousDate.add(Duration(days: 1)))) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Flight ${segmentIndex + 1} date must be after Flight $segmentIndex date',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }
        provider.updateMultiCitySegment(segmentIndex, 'date', date);
      }
    });
  }
}

class MultiCityResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> flights = [
    {
      'time': '06:00 - 15:30',
      'duration': '12h 30m',
      'stop': 'Connects in Dubai',
      'date': '27 Jul 2025',
      'aircraft': 'A380 EK501 → B777 EK723',
      'economyPrice': 62500.0,
      'businessPrice': 145000.0,
    },
    {
      'time': '09:15 - 18:45',
      'duration': '13h 30m',
      'stop': 'Connects in London',
      'date': '27 Jul 2025',
      'aircraft': 'B777 BA138 → B777 BA112',
      'economyPrice': 58900.0,
      'businessPrice': 138000.0,
    },
    {
      'time': '12:30 - 22:00',
      'duration': '14h 30m',
      'stop': 'Connects in Frankfurt',
      'date': '27 Jul 2025',
      'aircraft': 'A350 LH759 → A320 LH112',
      'economyPrice': 60200.0,
      'businessPrice': 140500.0,
    },
    {
      'time': '15:45 - 02:15',
      'duration': '15h 30m',
      'stop': 'Connects in Paris',
      'date': '27 Jul 2025 - 28 Jul 2025',
      'aircraft': 'A330 AF225 → A320 AF1641',
      'economyPrice': 59800.0,
      'businessPrice': 142000.0,
    },
    {
      'time': '18:00 - 05:30',
      'duration': '16h 30m',
      'stop': 'Connects in Amsterdam',
      'date': '27 Jul 2025 - 28 Jul 2025',
      'aircraft': 'B787 KL872 → B737 KL1349',
      'economyPrice': 61000.0,
      'businessPrice': 143500.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final titleFontSize = isLargeScreen ? 32.0 : 24.0;
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
                Color.fromARGB(255, 10, 11, 11),
                Color.fromARGB(255, 12, 16, 18),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
        title: Text(
          'Multi-City Flights',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/landscape-shot-brooklyn-bridge-new-usa-with-gray-gloomy-sky.jpg',
                ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Flights for Your Journey',
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
                  const SizedBox(height: 16),
                  ...provider.multiCitySegments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final segment = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white.withOpacity(0.9),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Flight ${index + 1}: ${segment['from'] ?? 'Select departure'} to ${segment['to'] ?? 'Select destination'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  segment['date'] != null
                                      ? 'Date: ${DateFormat('dd MMM yyyy').format(segment['date'])}'
                                      : 'Date: Not selected',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...flights.map(
                          (flight) =>
                              FlightCard(flight: flight, segmentIndex: index),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: ElevatedButton(
                          onPressed: () {
                            if (provider.selectedMultiCityFlights.length ==
                                provider.multiCitySegments.length) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BookingDetailsPage(
                                        flight:
                                            provider.selectedMultiCityFlights,
                                        travelClass: '',
                                        isMultiCity: true,
                                      ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please select a flight for each segment',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 12, 12, 12),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            elevation: 2,
                            shadowColor: Colors.black.withOpacity(0.3),
                          ),
                          child: Text(
                            'Confirm Flights',
                            style: GoogleFonts.poppins(
                              fontSize: isLargeScreen ? 16 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
}

class FlightResultsPage extends StatelessWidget {
  final String from;
  final String to;
  final DateTime departureDate;
  final DateTime? returnDate;

  FlightResultsPage({
    required this.from,
    required this.to,
    required this.departureDate,
    this.returnDate,
  });

  final List<Map<String, dynamic>> flights = [
    {
      'time': '06:00 - 15:30',
      'duration': '12h 30m',
      'stop': 'Connects in Dubai',
      'date': '27 Jul 2025',
      'aircraft': 'A380 EK501 → B777 EK723',
      'economyPrice': 62500.0,
      'businessPrice': 145000.0,
    },
    {
      'time': '09:15 - 18:45',
      'duration': '13h 30m',
      'stop': 'Connects in London',
      'date': '27 Jul 2025',
      'aircraft': 'B777 BA138 → B777 BA112',
      'economyPrice': 58900.0,
      'businessPrice': 138000.0,
    },
    {
      'time': '12:30 - 22:00',
      'duration': '14h 30m',
      'stop': 'Connects in Frankfurt',
      'date': '27 Jul 2025',
      'aircraft': 'A350 LH759 → A320 LH112',
      'economyPrice': 60200.0,
      'businessPrice': 140500.0,
    },
    {
      'time': '15:45 - 02:15',
      'duration': '15h 30m',
      'stop': 'Connects in Paris',
      'date': '27 Jul 2025 - 28 Jul 2025',
      'aircraft': 'A330 AF225 → A320 AF1641',
      'economyPrice': 59800.0,
      'businessPrice': 142000.0,
    },
    {
      'time': '18:00 - 05:30',
      'duration': '16h 30m',
      'stop': 'Connects in Amsterdam',
      'date': '27 Jul 2025 - 28 Jul 2025',
      'aircraft': 'B787 KL872 → B737 KL1349',
      'economyPrice': 61000.0,
      'businessPrice': 143500.0,
    },
  ];

  String getCurrencySymbol(String currency) {
    switch (currency) {
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
    final titleFontSize = isLargeScreen ? 32.0 : 24.0;

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
                Color.fromARGB(255, 10, 11, 11),
                Color.fromARGB(255, 12, 16, 18),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
        title: Text(
          'Available Flights',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/landscape-shot-brooklyn-bridge-new-usa-with-gray-gloomy-sky.jpg',
                ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Text(
                    'Flights from $from to $to',
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ...flights.map((f) => FlightCard(flight: f)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlightCard extends StatefulWidget {
  final Map<String, dynamic> flight;
  final int? segmentIndex;

  const FlightCard({required this.flight, this.segmentIndex});

  @override
  _FlightCardState createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final provider = Provider.of<FlightBookingProvider>(context);
    final convertedEconomyPrice =
        widget.flight['economyPrice'] *
        (provider.currencyRates[provider.currency] ?? 1.0);
    final convertedBusinessPrice =
        widget.flight['businessPrice'] *
        (provider.currencyRates[provider.currency] ?? 1.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Card(
          color: Colors.white.withOpacity(0.8),
          elevation: _isHovered ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.flight['date'],
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.flight,
                            color: Color.fromARGB(255, 5, 6, 6),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.flight['time'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.flight['duration'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        widget.flight['stop'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        widget.flight['aircraft'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        'Economy',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.getCurrencySymbol(provider.currency)}${convertedEconomyPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 7, 7, 7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.segmentIndex != null) {
                            provider.selectMultiCityFlight(
                              widget.segmentIndex!,
                              widget.flight,
                              'Economy',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Flight ${widget.segmentIndex! + 1} selected (Economy)',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BookingDetailsPage(
                                      flight: widget.flight,
                                      travelClass: 'Economy',
                                    ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 7, 7, 7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: Text(
                          'Select',
                          style: GoogleFonts.poppins(
                            fontSize: isLargeScreen ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        'Business',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.getCurrencySymbol(provider.currency)}${convertedBusinessPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 8, 8, 8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.segmentIndex != null) {
                            provider.selectMultiCityFlight(
                              widget.segmentIndex!,
                              widget.flight,
                              'Business',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Flight ${widget.segmentIndex! + 1} selected (Business)',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BookingDetailsPage(
                                      flight: widget.flight,
                                      travelClass: 'Business',
                                    ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 7, 7, 7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: Text(
                          'Select',
                          style: GoogleFonts.poppins(
                            fontSize: isLargeScreen ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingDetailsPage extends StatelessWidget {
  final dynamic
  flight; // Can be Map<String, dynamic> or List<Map<String, dynamic>> for multi-city
  final String travelClass;
  final bool isMultiCity;

  const BookingDetailsPage({
    required this.flight,
    required this.travelClass,
    this.isMultiCity = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final titleFontSize = isLargeScreen ? 32.0 : 24.0;
    final subtitleFontSize = isLargeScreen ? 18.0 : 16.0;
    final provider = Provider.of<FlightBookingProvider>(context);

    final List<Map<String, dynamic>> economyBenefits = [
      {'text': 'Standard Seat Selection', 'icon': Icons.event_seat},
      {'text': 'Complimentary Meals and Beverages', 'icon': Icons.restaurant},
      {'text': '20kg Checked Baggage Allowance', 'icon': Icons.luggage},
      {'text': 'In-flight Entertainment', 'icon': Icons.movie},
      {'text': 'Priority Check-in', 'icon': Icons.check_circle},
      {'text': 'Free Wi-Fi (Limited)', 'icon': Icons.wifi},
      {
        'text': 'Comfortable Economy Seating',
        'icon': Icons.airline_seat_recline_normal,
      },
      {'text': 'Online Check-in', 'icon': Icons.phone_iphone},
    ];

    final List<Map<String, dynamic>> businessBenefits = [
      {'text': 'Priority Boarding', 'icon': Icons.flight_takeoff},
      {'text': 'Access to Premium Lounges', 'icon': Icons.local_bar},
      {'text': '30kg Checked Baggage Allowance', 'icon': Icons.luggage},
      {'text': 'Gourmet Dining Experience', 'icon': Icons.restaurant_menu},
      {
        'text': 'Extra Legroom and Reclining Seats',
        'icon': Icons.airline_seat_recline_extra,
      },
      {'text': 'Personal In-flight Entertainment System', 'icon': Icons.tv},
      {'text': 'Dedicated Cabin Crew', 'icon': Icons.person},
      {'text': 'Unlimited Wi-Fi', 'icon': Icons.wifi},
      {'text': 'Complimentary Travel Kit', 'icon': Icons.card_travel},
      {'text': 'Priority Baggage Handling', 'icon': Icons.luggage},
    ];

    double totalPrice = 0.0;
    List<Map<String, dynamic>> flights =
        isMultiCity
            ? flight as List<Map<String, dynamic>>
            : [flight as Map<String, dynamic>];
    List<String> travelClasses =
        isMultiCity ? provider.selectedMultiCityClasses : [travelClass];

    for (int i = 0; i < flights.length; i++) {
      String classType =
          isMultiCity ? provider.selectedMultiCityClasses[i] : travelClass;
      totalPrice +=
          classType == 'Economy'
              ? flights[i]['economyPrice'] *
                  (provider.currencyRates[provider.currency] ?? 1.0)
              : flights[i]['businessPrice'] *
                  (provider.currencyRates[provider.currency] ?? 1.0);
    }

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
                Color.fromARGB(255, 11, 12, 12),
                Color.fromARGB(255, 10, 14, 16),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
        title: Text(
          isMultiCity ? 'Multi-City Booking' : '$travelClass Booking',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/landscape-shot-brooklyn-bridge-new-usa-with-gray-gloomy-sky.jpg',
                ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMultiCity
                            ? 'Multi-City Itinerary'
                            : '$travelClass Benefits',
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
                      const SizedBox(height: 8),
                      Text(
                        isMultiCity
                            ? 'Your selected flights'
                            : 'Experience luxury with SkyWings Airlines',
                        style: GoogleFonts.poppins(
                          fontSize: subtitleFontSize,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!isMultiCity)
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children:
                                  (travelClass == 'Economy'
                                          ? economyBenefits
                                          : businessBenefits)
                                      .map(
                                        (benefit) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                benefit['icon'],
                                                color: Color.fromARGB(
                                                  255,
                                                  3,
                                                  3,
                                                  3,
                                                ),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  benefit['text'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),

                      ...flights.asMap().entries.map((entry) {
                        final index = entry.key;
                        final flight = entry.value;
                        final classType =
                            isMultiCity ? travelClasses[index] : travelClass;
                        final price =
                            classType == 'Economy'
                                ? flight['economyPrice'] *
                                    (provider.currencyRates[provider
                                            .currency] ??
                                        1.0)
                                : flight['businessPrice'] *
                                    (provider.currencyRates[provider
                                            .currency] ??
                                        1.0);
                        final benefits =
                            classType == 'Economy'
                                ? economyBenefits
                                : businessBenefits;

                        return Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Part: Flight Details
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isMultiCity)
                                        Text(
                                          'Flight ${index + 1}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      Text(
                                        isMultiCity
                                            ? '${provider.multiCitySegments[index]['from']} to ${provider.multiCitySegments[index]['to']}'
                                            : '${provider.from} to ${provider.to}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Date: ${flight['date']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Time: ${flight['time']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Duration: ${flight['duration']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Stop: ${flight['stop']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Aircraft: ${flight['aircraft']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '$classType Price: ${provider.getCurrencySymbol(provider.currency)}${price.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Right Part: Benefits
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$classType Benefits',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...benefits.map(
                                        (benefit) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                benefit['icon'],
                                                color: Color.fromARGB(
                                                  255,
                                                  3,
                                                  3,
                                                  3,
                                                ),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  benefit['text'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 24),
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Price:',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),

                              Text(
                                '${provider.getCurrencySymbol(provider.currency)}${totalPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 7, 7, 7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> bookingData = {
                                'tripType': provider.tripType,
                                'currency': provider.currency,
                                'from': provider.from,
                                'to': provider.to,
                                'departureDate':
                                    provider.departureDate?.toIso8601String(),
                                'returnDate':
                                    provider.returnDate?.toIso8601String(),
                                'passengers': provider.passengers,
                                'travelClass': provider.travelClass,
                                'multiCitySegments': provider.multiCitySegments,
                                'selectedMultiCityFlights':
                                    provider.selectedMultiCityFlights,
                                'selectedMultiCityClasses':
                                    provider.selectedMultiCityClasses,
                                'currencyRates': provider.currencyRates,
                              };
                              handlePcAuthPayment(
                                bookingData,
                                context,
                              );
                              // List<Map<String, dynamic>> flight
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: Colors.white.withOpacity(
                                        0.8,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 48,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Booking Confirmed!',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Your flight${isMultiCity ? 's have' : ' has'} been successfully booked.',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Total: ${provider.getCurrencySymbol(provider.currency)}${totalPrice.toStringAsFixed(2)}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.popUntil(
                                              context,
                                              (route) => route.isFirst,
                                            );
                                          },
                                          child: Text(
                                            'Done',
                                            style: GoogleFonts.poppins(
                                              color: Color.fromARGB(
                                                255,
                                                5,
                                                5,
                                                5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 12, 12, 12),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              elevation: 2,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),

                            child: Text(
                              'Confirm Booking',
                              style: GoogleFonts.poppins(
                                fontSize: isLargeScreen ? 16 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
