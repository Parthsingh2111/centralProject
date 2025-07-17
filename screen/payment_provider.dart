import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  String _cardNumber = '';
  String _expiryMonth = '';
  String _expiryYear = '';
  String _securityCode = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _zipCode = '';
  String _merchantTxnId = '';
  double _totalAmount = 0.0;
  String _txnCurrency = '';
  String _merchantCallbackURL = '';
  String _selectedPaymentMethod = 'credit-card';
  String? _paymentResult;
  String? _serviceResult;
  bool _autoDebit = false;
  String _serviceTxnId = ''; // For Capture, Refund, Reversal, Status Check
  double _serviceAmount = 0.0; // For Refund
  String _serviceRestartDate = ''; // For SI Pause

  // Getters
  String get selectedPaymentMethod => _selectedPaymentMethod;
  String? get paymentResult => _paymentResult;
  String? get serviceResult => _serviceResult;
  bool get autoDebit => _autoDebit;
  String get serviceTxnId => _serviceTxnId;
  double get serviceAmount => _serviceAmount;
  String get serviceRestartDate => _serviceRestartDate;
  bool get isPayDirectValid =>
      _firstName.isNotEmpty &&
      _lastName.isNotEmpty &&
      _email.isNotEmpty &&
      _address.isNotEmpty &&
      _city.isNotEmpty &&
      _state.isNotEmpty &&
      _zipCode.isNotEmpty &&
      _merchantTxnId.isNotEmpty &&
      _totalAmount > 0 &&
      _txnCurrency.isNotEmpty &&
      _merchantCallbackURL.isNotEmpty &&
      (_selectedPaymentMethod != 'credit-card' ||
          (_cardNumber.isNotEmpty &&
              _expiryMonth.isNotEmpty &&
              _expiryYear.isNotEmpty &&
              _securityCode.isNotEmpty));
  bool get isPayCollectValid => isPayDirectValid && _autoDebit;
  bool get isServiceValid => _serviceTxnId.isNotEmpty && (_serviceAmount > 0 || _serviceRestartDate.isNotEmpty || true); // Adjust based on service

  // Setters
  void setCardNumber(String value) {
    _cardNumber = value;
    notifyListeners();
  }

  void setExpiryMonth(String value) {
    _expiryMonth = value;
    notifyListeners();
  }

  void setExpiryYear(String value) {
    _expiryYear = value;
    notifyListeners();
  }

  void setSecurityCode(String value) {
    _securityCode = value;
    notifyListeners();
  }

  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void setState(String value) {
    _state = value;
    notifyListeners();
  }

  void setZipCode(String value) {
    _zipCode = value;
    notifyListeners();
  }

  void setMerchantTxnId(String value) {
    _merchantTxnId = value;
    notifyListeners();
  }

  void setTotalAmount(double value) {
    _totalAmount = value;
    notifyListeners();
  }

  void setTxnCurrency(String value) {
    _txnCurrency = value;
    notifyListeners();
  }

  void setMerchantCallbackURL(String value) {
    _merchantCallbackURL = value;
    notifyListeners();
  }

  void setPaymentMethod(String value) {
    _selectedPaymentMethod = value;
    notifyListeners();
  }

  void setAutoDebit(bool value) {
    _autoDebit = value;
    notifyListeners();
  }

  void setServiceTxnId(String value) {
    _serviceTxnId = value;
    notifyListeners();
  }

  void setServiceAmount(double value) {
    _serviceAmount = value;
    notifyListeners();
  }

  void setServiceRestartDate(String value) {
    _serviceRestartDate = value;
    notifyListeners();
  }

  void initiatePayDirect() {
    _paymentResult = 'Payment Successful';
    notifyListeners();
  }

  void simulateService(String serviceType) {
    switch (serviceType) {
      case 'Capture':
        _serviceResult = 'Captured funds for transaction ID: $_serviceTxnId';
        break;
      case 'Refund':
        _serviceResult = 'Refunded $_serviceAmount for transaction ID: $_serviceTxnId';
        break;
      case 'Reversal':
        _serviceResult = 'Reversed transaction ID: $_serviceTxnId';
        break;
      case 'SI Activate':
        _serviceResult = 'Activated standing instructions for transaction ID: $_serviceTxnId';
        break;
      case 'SI Pause':
        _serviceResult = 'Paused standing instructions until $_serviceRestartDate';
        break;
      case 'Status Check':
        _serviceResult = 'Status for transaction ID: $_serviceTxnId is Active';
        break;
      default:
        _serviceResult = 'Unknown service simulated';
    }
    notifyListeners();
  }
}