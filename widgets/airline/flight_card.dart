import 'package:centralproject/models/airlineModels/flight.dart';
import 'package:centralproject/screen/airline_interface.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class FlightCard extends StatefulWidget {
  final Flight flight;
  final int? segmentIndex;
  final Function(String) onSelect;

  const FlightCard({required this.flight, this.segmentIndex, required this.onSelect, Key? key}) : super(key: key);

  @override
  _FlightCardState createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final provider = Provider.of<FlightBookingProvider>(context);
    final convertedEconomyPrice = widget.flight.economyPrice * provider.currencyRates[provider.currency]!;
    final convertedBusinessPrice = widget.flight.businessPrice * provider.currencyRates[provider.currency]!;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        DateFormat('dd MMM yyyy').format(widget.flight.departureDateTime),
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.flight, color: Colors.black, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            '${DateFormat('HH:mm').format(widget.flight.departureDateTime)} - ${DateFormat('HH:mm').format(widget.flight.arrivalDateTime)}',
                            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(widget.flight.duration, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                      Text(widget.flight.stop, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                      Text(widget.flight.aircraft, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text('Economy', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.getCurrencySymbol(provider.currency)}${convertedEconomyPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => widget.onSelect('Economy'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Select', style: GoogleFonts.poppins(fontSize: isLargeScreen ? 14 : 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text('Business', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.getCurrencySymbol(provider.currency)}${convertedBusinessPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => widget.onSelect('Business'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Select', style: GoogleFonts.poppins(fontSize: isLargeScreen ? 14 : 12, fontWeight: FontWeight.w600)),
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