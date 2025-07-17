import 'package:centralproject/models/airlineModels/flight.dart';
import 'package:centralproject/providers/flight_booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BookingService {
  static List<Flight> getFlights(String from, String to, DateTime date) {
    return [
      Flight(
        flightNumber: 'NY123',
        carrierCode: 'AAL',
        departureAirportCode: from.split(' — ')[0],
        departureCity: from.split(' — ')[1],
        departureCountry: 'US',
        departureDateTime: DateTime(date.year, date.month, date.day, 6, 0),
        arrivalAirportCode: to.split(' — ')[0],
        arrivalCity: to.split(' — ')[1],
        arrivalCountry: 'AE',
        arrivalDateTime: DateTime(date.year, date.month, date.day, 15, 30),
        duration: '12h 30m',
        aircraft: 'A380 EK501 → B777 EK723',
        stop: 'Connects in Dubai',
        economyPrice: 62500.0,
        businessPrice: 145000.0,
      ),
      // Add more flights as needed
    ];
  }

  static void showDatePicker(BuildContext context, FlightBookingProvider provider, {int? segmentIndex}) {
    DateTime firstDate = DateTime.now();
    if (segmentIndex != null && segmentIndex > 0) {
      final previousDate = provider.multiCitySegments[segmentIndex - 1]['date'] as DateTime?;
      if (previousDate != null) firstDate = previousDate.add(Duration(days: 1));
    }

    showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 90)),
    ).then((date) {
      
      if (date != null) {
        if (segmentIndex != null) {
          if (segmentIndex > 0 && provider.multiCitySegments[segmentIndex - 1]['date'] != null) {
            final previousDate = provider.multiCitySegments[segmentIndex - 1]['date'] as DateTime;
            if (date.isBefore(previousDate.add(Duration(days: 1)))) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Flight ${segmentIndex + 1} date must be after Flight $segmentIndex date')),
              );
              return;
            }
          }
          provider.updateMultiCitySegment(segmentIndex, 'date', date);
        } else if (provider.tripType == 'One-way') {
          provider.updateDate(date);
          provider.updateReturnDate(null);
        } else {
          showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 90)),
          ).then((range) {
            if (range != null) {
              provider.updateDate(range.start);
              provider.updateReturnDate(range.end);
            }
          });
        }
      }
    });
  }

  static String generateTicketNumber() {
    return 'TICKET${DateTime.now().millisecondsSinceEpoch}';
  }

  static String generateReservationDate() {
    return DateFormat('yyyyMMdd').format(DateTime.now());
  }
}