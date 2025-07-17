import 'package:centralproject/models/airlineModels/route.dart';
import 'package:flutter/material.dart';
import '../models/airlineModels/flight.dart';
import '../models/airlineModels/passenger.dart';
import '../widgets/airline/airport_selector.dart'; // Adjusted import path
import '../widgets/airline/date_selector.dart';
 // Updated import

class FlightBookingProvider extends ChangeNotifier {
  String _tripType = 'One-way';
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
  List<FlightRoute> _selectedRoutes = []; // Updated to FlightRoute
  List<Passenger> _passengersData = [];
  String _ticketNumber = '';
  String _reservationDate = '';

  final Map<String, double> currencyRates = {
    'INR': 1.0,
    'USD': 0.012,
    'EUR': 0.011,
  };

  final List<Map<String, String>> departureCities = [
    {'city': 'Mumbai', 'country': 'India', 'airport': 'Chhatrapati Shivaji Airport', 'code': 'BOM'},
    // ... other cities
  ];
  final List<Map<String, String>> destinationCities = [
    {'city': 'New York', 'country': 'USA', 'airport': 'John F. Kennedy Airport', 'code': 'JFK'},
    // ... other cities
  ];

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
  List<FlightRoute> get selectedRoutes => _selectedRoutes; // Updated to FlightRoute
  List<Passenger> get passengersData => _passengersData;
  String get ticketNumber => _ticketNumber;
  String get reservationDate => _reservationDate;

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
    _selectedRoutes.clear();
    _multiCitySegments = [{'from': null, 'to': null, 'date': null}];
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

  void updatePassengersData(List<Passenger> passengers) {
    _passengersData = passengers;
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
      if (_selectedRoutes.length > index) {
        _selectedRoutes.removeAt(index);
      }
      notifyListeners();
    }
  }

  void selectRoute(FlightRoute route) { // Updated to FlightRoute
    _selectedRoutes.add(route);
    notifyListeners();
  }

  void setTicketDetails(String ticketNumber, String reservationDate) {
    _ticketNumber = ticketNumber;
    _reservationDate = reservationDate;
    notifyListeners();
  }

  Map<String, dynamic> toRiskData() {
    final journeyType = _tripType.toUpperCase();
    final flightData = _selectedRoutes.map((route) => {
      'journeyType': journeyType,
      'ticketNumber': _ticketNumber,
      'reservationDate': _reservationDate,
      'legData': route.legs.map((leg) => leg.toJson()).toList(),
      'passengerData': _passengersData.map((p) => p.toJson()).toList(),
    }).toList();

    return {
      'riskData': {
        'billingData': {
          'emailId': _passengersData.isNotEmpty ? _passengersData[0].email : '',
        },
        'flightData': flightData,
      }
    };
  }
}