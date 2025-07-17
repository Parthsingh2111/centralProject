import 'package:centralproject/models/airlineModels/flight.dart';

class Leg {
  final String legId;
  final Flight flight;
  final String airlineServiceClass;

  Leg({required this.legId, required this.flight, required this.airlineServiceClass});

  Map<String, dynamic> toJson() => {
        'legId': legId,
        'flightNumber': flight.flightNumber,
        'departureAirportCode': flight.departureAirportCode,
        'departureCity': flight.departureCity,
        'departureCountry': flight.departureCountry,
        'departureDate': flight.departureDateTime.toIso8601String(),
        'arrivalAirportCode': flight.arrivalAirportCode,
        'arrivalCity': flight.arrivalCity,
        'arrivalCountry': flight.arrivalCountry,
        'arrivalDate': flight.arrivalDateTime.toIso8601String(),
        'carrierCode': flight.carrierCode,
        'airlineServiceClass': airlineServiceClass,
      };
}