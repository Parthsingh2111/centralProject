import 'package:centralproject/models/airlineModels/leg.dart';
import 'package:centralproject/models/airlineModels/route.dart';
import 'package:centralproject/screen/airline_interface.dart';
import 'package:centralproject/services/airlineServices/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class FlightResultsPage extends StatelessWidget {
  const FlightResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final titleFontSize = isLargeScreen ? 32.0 : 24.0;
    final provider = Provider.of<FlightBookingProvider>(context);
    final flights = BookingService.getFlights(provider.from, provider.to, provider.departureDate!);

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
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2))),
          ),
        ),
        title: Text(
          'Available Flights',
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
                children: [
                  Text(
                    'Flights from ${provider.from} to ${provider.to}',
                    style: GoogleFonts.playfairDisplay(fontSize: titleFontSize, fontWeight: FontWeight.w700, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ...flights.map((flight) => FlightCard(
                        flight: flight,
                        onSelect: (travelClass) {
                          provider.selectRoute(FlightRoute( // Changed to FlightRoute
                            routeId: '1',
                            legs: [Leg(legId: '1', flight: flight, airlineServiceClass: travelClass)],
                          ));
                          if (provider.tripType == 'Round-trip' && provider.returnDate != null) {
                            final returnFlights = BookingService.getFlights(provider.to, provider.from, provider.returnDate!);
                            if (returnFlights.isNotEmpty) {
                              provider.selectRoute(FlightRoute( // Changed to FlightRoute
                                routeId: '2',
                                legs: [Leg(legId: '1', flight: returnFlights[0], airlineServiceClass: travelClass)],
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No return flights available')),
                              );
                              return;
                            }
                          }
                          Navigator.pushNamed(context, '/passenger_input');
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}