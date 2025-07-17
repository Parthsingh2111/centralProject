import 'package:centralproject/screen/airline_interface.dart';
import 'package:centralproject/widgets/airline/date_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MultiCityBookingPage extends StatefulWidget {
  const MultiCityBookingPage({Key? key}) : super(key: key);

  @override
  _MultiCityBookingPageState createState() => _MultiCityBookingPageState();
}

class _MultiCityBookingPageState extends State<MultiCityBookingPage> {
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
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2))),
          ),
        ),
        title: Text(
          'Multi-City Booking',
          style: GoogleFonts.playfairDisplay(fontSize: isLargeScreen ? 28 : 24, fontWeight: FontWeight.w700, color: Colors.white),
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
                image: AssetImage('assets/images/landscape-shot-brooklyn-bridge-new-usa-with-gray-gloomy-sky.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
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
                    'Plan Your Multi-City Journey',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add up to 5 flights',
                    style: GoogleFonts.poppins(fontSize: subtitleFontSize, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  ...provider.multiCitySegments.asMap().entries.map((entry) {
                    final index = entry.key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Flight ${index + 1}',
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  if (index > 0)
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () => provider.removeMultiCitySegment(index),
                                      tooltip: 'Remove Flight',
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              AirportSelector(
                                label: 'From',
                                value: provider.multiCitySegments[index]['from'] ?? 'Select departure',
                                onTap: () => _showDestinationDialog(context, provider, true, provider.departureCities, index),
                              ),
                              const Divider(color: Color(0xFFE0E0E0), thickness: 1),
                              AirportSelector(
                                label: 'To',
                                value: provider.multiCitySegments[index]['to'] ?? 'Select destination',
                                onTap: () => _showDestinationDialog(context, provider, false, provider.destinationCities, index),
                              ),
                              const Divider(color: Color(0xFFE0E0E0), thickness: 1),
                              DateSelector(segmentIndex: index),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  if (provider.multiCitySegments.length < 5)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: provider.addMultiCitySegment,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text('Add Flight', style: GoogleFonts.poppins(fontSize: isLargeScreen ? 16 : 14, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 12, 12, 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                            bool isValid = provider.multiCitySegments.every((segment) =>
                                segment['from'] != null && segment['to'] != null && segment['date'] != null);
                            if (isValid) {
                              Navigator.pushNamed(context, '/multi_city_results');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please complete all flight details')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 12, 12, 12),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
    if (isFrom && segmentIndex > 0) {
      final autoFilledFrom = provider.multiCitySegments[segmentIndex - 1]['to'];
      provider.updateMultiCitySegment(segmentIndex, 'from', autoFilledFrom);
    }

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
                  if (!isFrom && provider.multiCitySegments[segmentIndex]['from'] == selectedCity) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Departure and destination cities cannot be the same')),
                    );
                    return;
                  }
                  provider.updateMultiCitySegment(segmentIndex, isFrom ? 'from' : 'to', selectedCity);
                  if (!isFrom && segmentIndex < provider.multiCitySegments.length - 1) {
                    provider.updateMultiCitySegment(segmentIndex + 1, 'from', selectedCity);
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

