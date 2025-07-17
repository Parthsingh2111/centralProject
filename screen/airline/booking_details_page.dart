import 'package:centralproject/models/airlineModels/route.dart';
import 'package:centralproject/screen/airline_interface.dart';
import 'package:centralproject/services/airlineServices/booking_service.dart';
import 'package:centralproject/utils/pc_payment_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class BookingDetailsPage extends StatelessWidget {
  final List<FlightRoute> routes; // Changed from Route to FlightRoute
  final bool isMultiCity;

  const BookingDetailsPage({required this.routes, this.isMultiCity = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightBookingProvider>(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 800;

    double totalPrice = 0.0;
    for (var route in routes) {
      for (var leg in route.legs) {
        totalPrice += leg.airlineServiceClass == 'Economy'
            ? leg.flight.economyPrice * provider.currencyRates[provider.currency]!
            : leg.flight.businessPrice * provider.currencyRates[provider.currency]!;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isMultiCity ? 'Multi-City Booking' : '${provider.travelClass} Booking',
          style: GoogleFonts.poppins(fontSize: isLargeScreen ? 24 : 20, fontWeight: FontWeight.w600),
        ),
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
          ),
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
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ...routes.asMap().entries.map((entry) {
                  final route = entry.value;
                  return Card(
                    color: Colors.white.withOpacity(0.8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Route ${entry.key + 1}',
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          ...route.legs.asMap().entries.map((legEntry) {
                            final leg = legEntry.value;
                            return ListTile(
                              title: Text(
                                '${leg.flight.departureCity} to ${leg.flight.arrivalCity}',
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Flight: ${leg.flight.flightNumber}, Class: ${leg.airlineServiceClass}, '
                                'Date: ${DateFormat('dd MMM yyyy').format(leg.flight.departureDateTime)}',
                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${provider.getCurrencySymbol(provider.currency)}${totalPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final ticketNumber = BookingService.generateTicketNumber();
                    final reservationDate = BookingService.generateReservationDate();
                    provider.setTicketDetails(ticketNumber, reservationDate);
                    handlePcAuthPayment(provider.toRiskData(), context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        content: Text(
                          'Booking Confirmed!',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                            child: Text('Done', style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 12, 12, 12),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Confirm Booking',
                    style: GoogleFonts.poppins(fontSize: isLargeScreen ? 16 : 14, fontWeight: FontWeight.w600),
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