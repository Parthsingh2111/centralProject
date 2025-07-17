import 'package:centralproject/services/airlineServices/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/flight_booking_provider.dart';


class DateSelector extends StatelessWidget {
  final int? segmentIndex;

  const DateSelector({this.segmentIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightBookingProvider>(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final date = segmentIndex != null
        ? provider.multiCitySegments[segmentIndex!]['date'] as DateTime?
        : provider.departureDate;

    return InkWell(
      onTap: () {
        // Call showDatePicker without expecting a return value
        BookingService.showDatePicker(context, provider, segmentIndex: segmentIndex);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date',
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select date',
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 16 : 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}