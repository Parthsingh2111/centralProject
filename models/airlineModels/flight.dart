class Flight {
  final String flightNumber;
  final String carrierCode;
  final String departureAirportCode;
  final String departureCity;
  final String departureCountry;
  final DateTime departureDateTime;
  final String arrivalAirportCode;
  final String arrivalCity;
  final String arrivalCountry;
  final DateTime arrivalDateTime;
  final String duration;
  final String aircraft;
  final String stop;
  final double economyPrice;
  final double businessPrice;

  Flight({
    required this.flightNumber,
    required this.carrierCode,
    required this.departureAirportCode,
    required this.departureCity,
    required this.departureCountry,
    required this.departureDateTime,
    required this.arrivalAirportCode,
    required this.arrivalCity,
    required this.arrivalCountry,
    required this.arrivalDateTime,
    required this.duration,
    required this.aircraft,
    required this.stop,
    required this.economyPrice,
    required this.businessPrice,
  });

  Map<String, dynamic> toJson() => {
        'flightNumber': flightNumber,
        'carrierCode': carrierCode,
        'departureAirportCode': departureAirportCode,
        'departureCity': departureCity,
        'departureCountry': departureCountry,
        'departureDate': departureDateTime.toIso8601String(),
        'arrivalAirportCode': arrivalAirportCode,
        'arrivalCity': arrivalCity,
        'arrivalCountry': arrivalCountry,
        'arrivalDate': arrivalDateTime.toIso8601String(),
        'duration': duration,
        'aircraft': aircraft,
        'stop': stop,
        'economyPrice': economyPrice,
        'businessPrice': businessPrice,
      };
}