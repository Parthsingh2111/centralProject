import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  final TextEditingController gidController = TextEditingController();
  final TextEditingController merchantTxnIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController mandateIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? _selectedService = 'Capture';
  String? _captureType = 'Full';
  String? _refundType = 'Full';
  String? _siAction = 'Pause';
  bool _isLoading = false;
  String? _serviceResult;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _appBarFadeController;
  late Animation<double> _appBarFadeAnimation;

  @override
  void initState() {
    super.initState();
    // Fade animation for main content
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    // Fade animation for app bar
    _appBarFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _appBarFadeAnimation = CurvedAnimation(
      parent: _appBarFadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    gidController.dispose();
    merchantTxnIdController.dispose();
    amountController.dispose();
    mandateIdController.dispose();
    dateController.dispose();
    _fadeController.dispose();
    _appBarFadeController.dispose();
    super.dispose();
  }

  Future<void> _handleServiceRequest() async {
    final gid = gidController.text.trim();
    final merchantTxnId = merchantTxnIdController.text.trim();
    final amount = amountController.text.trim();
    final mandateId = mandateIdController.text.trim();
    final date = dateController.text.trim();

    if (_selectedService == 'Status Check' && gid.isEmpty) {
      _showSnackBar('Please enter a GID.', Colors.redAccent);
      return;
    }
    if (_selectedService != 'Status Check' && (gid.isEmpty || merchantTxnId.isEmpty)) {
      _showSnackBar('Please enter both GID and Merchant Transaction ID.', Colors.redAccent);
      return;
    }
    if (_selectedService == 'Capture' && _captureType == 'Partial' && amount.isEmpty) {
      _showSnackBar('Please enter a capture amount.', Colors.redAccent);
      return;
    }
    if (_selectedService == 'Refund' && _refundType == 'Partial' && amount.isEmpty) {
      _showSnackBar('Please enter a refund amount.', Colors.redAccent);
      return;
    }
    if ((_selectedService == 'SI Pause' || _selectedService == 'SI Activate') && mandateId.isEmpty) {
      _showSnackBar('Please enter a Mandate ID.', Colors.redAccent);
      return;
    }
    if (_selectedService == 'SI Pause' && _siAction == 'PauseByDate' && date.isEmpty) {
      _showSnackBar('Please enter a date for Pause by Date.', Colors.redAccent);
      return;
    }
    if (_selectedService == 'SI Pause' && _siAction == 'PauseByDate') {
      final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!datePattern.hasMatch(date)) {
        _showSnackBar('Invalid date format (use YYYY-MM-DD).', Colors.redAccent);
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      if (_selectedService == 'Capture') {
        await _requestCapture(gid, merchantTxnId);
      } else if (_selectedService == 'Refund') {
        await _requestRefund(gid);
      } else if (_selectedService == 'Reversal') {
        await _requestReversal(gid, merchantTxnId);
      } else if (_selectedService == 'SI Pause' || _selectedService == 'SI Activate') {
        await _requestSIPauseActivate(merchantTxnId, mandateId);
      } else if (_selectedService == 'Status Check') {
        await _checkStatus(gid);
      }
    } catch (e) {
      setState(() {
        _serviceResult = 'Error: $e';
        _isLoading = false;
      });
      _showSnackBar('Error: $e', Colors.redAccent);
    }
  }
Future<void> _requestCapture(String gid, String merchantTxnId) async {
  print('Requesting capture for GID: $gid, MerchantTxnId: $merchantTxnId, Type: $_captureType');

  final totalAmount = amountController.text.trim().isEmpty ? '0' : amountController.text.trim();

  final body = _captureType == 'Full'
      ? {
          'captureType': 'F',
          'merchantTxnId': merchantTxnId,
          'paymentData': {
            'totalAmount': totalAmount,
          },
        }
      : {
          'captureType': 'P',
          'merchantTxnId': merchantTxnId,
          'paymentData': {
            'totalAmount': totalAmount,
          },
        };

  final url = Uri.parse('$captureUrl?gid=$gid');

  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 20), onTimeout: () {
      throw Exception('Request timed out');
    });

    print('Capture response code: ${response.statusCode}');
    print('Capture response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final captureData = jsonDecode(response.body);
        final captureStatus = captureData['status'] ?? 'unknown';
        print('Parsed capture status: $captureStatus');

        if (mounted) {
          setState(() {
            _serviceResult = 'Capture Status: $captureStatus';
            _isLoading = false;
          });
          _showSnackBar('Capture Status: $captureStatus', Colors.green);
        }
      } catch (e) {
        print('JSON parse error: $e');
        if (mounted) {
          setState(() {
            _serviceResult = 'Error: Failed to parse response - $e';
            _isLoading = false;
          });
          _showSnackBar('Error: Failed to parse response - $e', Colors.redAccent);
        }
      }
    } else {
      print('Capture request failed: ${response.statusCode}');
      if (mounted) {
        setState(() {
          _serviceResult = 'Error: Failed to process capture (${response.statusCode})';
          _isLoading = false;
        });
        _showSnackBar('Error: Failed to process capture (${response.statusCode})', Colors.redAccent);
      }
    }
  } catch (e) {
    print('Capture request error: $e');
    if (mounted) {
      setState(() {
        _serviceResult = 'Error: $e';
        _isLoading = false;
      });
      _showSnackBar('Error: $e', Colors.redAccent);
    }
  }
}


  Future<void> _requestRefund(String gid) async {
    print('Requesting refund for GID: $gid, Type: $_refundType');
    final body = _refundType == 'Full'
        ? {
            'gid': gid,
            'refundType': 'F',
          }
        : {
            'gid': gid,
            'refundType': 'P',
            'paymentData': {
              'totalAmount': amountController.text.trim(),
            },
          };
    final response = await http
        .post(
          Uri.parse(refundUrl),
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 20), onTimeout: () {
      throw Exception('Request timed out');
    });

    print('Refund response code: ${response.statusCode}');
    print('Refund response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final refundData = jsonDecode(response.body);
        final refundStatus = refundData['status'] ?? 'unknown';
        print('Parsed refund status: $refundStatus');
        if (mounted) {
          setState(() {
            _serviceResult = 'Refund Status: $refundStatus';
            _isLoading = false;
          });
          _showSnackBar('Refund Status: $refundStatus', Colors.green);
        }
      } catch (e) {
        print('JSON parse error: $e');
        print('Raw response: ${response.body}');
        if (mounted) {
          setState(() {
            _serviceResult = 'Error: Failed to parse response - $e';
            _isLoading = false;
          });
          _showSnackBar('Error: Failed to parse response - $e', Colors.redAccent);
        }
      }
    } else {
      print('Refund request failed: ${response.statusCode}');
      print('Raw response: ${response.body}');
      if (mounted) {
        setState(() {
          _serviceResult = 'Error: Failed to process refund (${response.statusCode})';
          _isLoading = false;
        });
        _showSnackBar('Error: Failed to process refund (${response.statusCode})', Colors.redAccent);
      }
    }
  }

  Future<void> _requestReversal(String gid, String merchantTxnId) async {
    print('Sending Auth Reversal for GID: $gid');
    final response = await http
        .post(
          Uri.parse('$authReversalUrl?gid=$gid'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"merchantTxnId": merchantTxnId}),
        )
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw Exception('Request timed out');
    });

    print('Reversal response code: ${response.statusCode}');
    print('Reversal response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _serviceResult = 'Auth Reversal Success:\n${response.body}';
        _isLoading = false;
      });
      _showSnackBar('Auth Reversal Success', Colors.green);
    } else {
      setState(() {
        _serviceResult = 'Auth Reversal Failed:\n${response.body}';
        _isLoading = false;
      });
      _showSnackBar('Auth Reversal Failed: ${response.statusCode}', Colors.redAccent);
    }
  }

  Future<void> _requestSIPauseActivate(String merchantTxnId, String mandateId) async {
    print('Sending SI ${_selectedService}, MandateId: $mandateId');
    final payload = {
      "merchantTxnId": merchantTxnId,
      "standingInstruction": {
        "action": _selectedService == 'SI Pause' ? (_siAction == 'PauseByDate' ? 'PauseByDate' : 'Pause') : 'Activate',
        "mandateId": mandateId,
        if (_siAction == 'PauseByDate' && _selectedService == 'SI Pause') "date": {"startDate": dateController.text.trim()},
      },
    };

    print('Sending payload: ${jsonEncode(payload)}');

    final response = await http
        .post(
          Uri.parse(pauseActivateUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw Exception('Request timed out');
    });

    print('SI response code: ${response.statusCode}');
    print('SI response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        _serviceResult = 'Success: ${response.body}';
        _isLoading = false;
      });
      _showSnackBar('Success: ${_selectedService}', Colors.green);
    } else {
      setState(() {
        _serviceResult = 'Error: ${response.statusCode} - ${response.body}';
        _isLoading = false;
      });
      _showSnackBar('Error: ${response.statusCode}', Colors.redAccent);
    }
  }


  Future<void> _checkStatus(String gid) async {
    print('Checking status for GID: $gid');
    final response = await http
        .get(
          Uri.parse('$statusUrl?gid=$gid'),
          // headers: {'ngrok-skip-browser-warning': 'true'},
        )
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw Exception('Request timed out');
    });

    print('Status response code: ${response.statusCode}');
    print('Status response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final statusData = jsonDecode(response.body);
        final paymentStatus = statusData['status'] ?? 'unknown';
        print('Parsed status: $paymentStatus');
        if (mounted) {
          setState(() {
            _serviceResult = 'Status: $paymentStatus';
            _isLoading = false;
          });
          _showSnackBar('Status: $paymentStatus', Colors.green);
        }
      } catch (e) {
        print('JSON parse error: $e');
        print('Raw response: ${response.body}');
        if (mounted) {
          setState(() {
            _serviceResult = 'Error: Failed to parse response - $e';
            _isLoading = false;
          });
          _showSnackBar('Error: Failed to parse response - $e', Colors.redAccent);
        }
      }
    } else {
      print('Status check failed: ${response.statusCode}');
      print('Raw response: ${response.body}');
      if (mounted) {
        setState(() {
          _serviceResult = 'Error: Failed to fetch status (${response.statusCode})';
          _isLoading = false;
        });
        _showSnackBar('Error: Failed to fetch status (${response.statusCode})', Colors.redAccent);
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {Icon? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: const Color(0xFF4B5563),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;
    final titleFontSize = isLargeScreen ? 30.0 : 24.0;
    final subtitleFontSize = isLargeScreen ? 18.0 : 16.0;
    final bodyFontSize = isLargeScreen ? 16.0 : 14.0;
    final padding = isLargeScreen ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          title: FadeTransition(
            opacity: _appBarFadeAnimation,
            child: Text(
              'Services Portal',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FadeTransition(
                opacity: _appBarFadeAnimation,
                child: DropdownButton<String>(
                  value: 'Services Page',
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != 'Services Page') {
                      switch (newValue) {
                        case 'Home Page':
                          Navigator.pushReplacementNamed(context, '/home');
                          break;
                        case 'Payment Page':
                          Navigator.pushReplacementNamed(context, '/payment');
                          break;
                        case 'Refund Page':
                          Navigator.pushReplacementNamed(context, '/refund');
                          break;
                        case 'Status Page':
                          Navigator.pushReplacementNamed(context, '/status');
                          break;
                        case 'Capture Page':
                          Navigator.pushReplacementNamed(context, '/capture');
                          break;
                        case 'Auth Reversal Page':
                          Navigator.pushReplacementNamed(context, '/authreversal');
                          break;
                        case 'SI Pause/Resume Page':
                          Navigator.pushReplacementNamed(context, '/siPauseResumepage');
                          break;
                      }
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Home Page',
                      child: Text('Home Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                    DropdownMenuItem(
                      value: 'Services Page',
                      child: Text('Services Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                    DropdownMenuItem(
                      value: 'Payment Page',
                      child: Text('Payment Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                    DropdownMenuItem(
                      value: 'Refund Page',
                      child: Text('Refund Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                    DropdownMenuItem(
                      value: 'Status Page',
                      child: Text('Status Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                    DropdownMenuItem(
                      value: 'Capture Page',
                      child: Text('Capture Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                    DropdownMenuItem(
                      value: 'Auth Reversal Page',
                      child: Text('Auth Reversal Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                    DropdownMenuItem(
                      value: 'SI Pause/Resume Page',
                      child: Text('SI Pause/Resume Page', style: TextStyle(color: Color(0xFF3B82F6))),
                    ),
                  ],
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3B82F6)),
                  dropdownColor: Colors.white,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF3B82F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  underline: const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF9FAFB), Color(0xFFE5E7EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Services Portal',
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Manage your payment services with ease.',
                          style: GoogleFonts.poppins(
                            fontSize: subtitleFontSize,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(height: 24),
                        DropdownButton<String>(
                          value: _selectedService,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedService = newValue;
                                _serviceResult = null;
                                gidController.clear();
                                merchantTxnIdController.clear();
                                amountController.clear();
                                mandateIdController.clear();
                                dateController.clear();
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(value: 'Capture', child: Text('Capture')),
                            DropdownMenuItem(value: 'Refund', child: Text('Refund')),
                            DropdownMenuItem(value: 'Reversal', child: Text('Reversal')),
                            DropdownMenuItem(value: 'SI Pause', child: Text('SI Pause')),
                            DropdownMenuItem(value: 'SI Activate', child: Text('SI Activate')),
                            DropdownMenuItem(value: 'Status Check', child: Text('Status Check')),
                          ],
                          isExpanded: true,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF111827),
                            fontSize: bodyFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                          dropdownColor: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8),
                          underline: Container(
                            height: 1,
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: gidController,
                          decoration: _inputDecoration(
                            'GID',
                            prefixIcon: const Icon(Icons.receipt_long, color: Color(0xFF4B5563)),
                          ),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF111827),
                            fontSize: bodyFontSize,
                          ),
                        ),
                        if (_selectedService != 'Status Check') ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: merchantTxnIdController,
                            decoration: _inputDecoration(
                              'Merchant Transaction ID',
                              prefixIcon: const Icon(Icons.tag, color: Color(0xFF4B5563)),
                            ),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF111827),
                              fontSize: bodyFontSize,
                            ),
                          ),
                        ],
                        if (_selectedService == 'Capture') ...[
                          const SizedBox(height: 16),
                          DropdownButton<String>(
                            value: _captureType,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _captureType = newValue);
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'Full', child: Text('Full Capture')),
                              DropdownMenuItem(value: 'Partial', child: Text('Partial Capture')),
                            ],
                            isExpanded: true,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF111827),
                              fontSize: bodyFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            dropdownColor: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(8),
                            underline: Container(
                              height: 1,
                              color: const Color(0xFFE5E7EB),
                            ),
                          ),
                          if (_captureType == 'Partial') ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                'Capture Amount',
                                prefixIcon: const Icon(Icons.currency_rupee, color: Color(0xFF4B5563)),
                              ),
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF111827),
                                fontSize: bodyFontSize,
                              ),
                            ),
                          ],
                        ],
                        if (_selectedService == 'Refund') ...[
                          const SizedBox(height: 16),
                          DropdownButton<String>(
                            value: _refundType,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _refundType = newValue);
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'Full', child: Text('Full Refund')),
                              DropdownMenuItem(value: 'Partial', child: Text('Partial Refund')),
                            ],
                            isExpanded: true,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF111827),
                              fontSize: bodyFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            dropdownColor: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(8),
                            underline: Container(
                              height: 1,
                              color: const Color(0xFFE5E7EB),
                            ),
                          ),
                          if (_refundType == 'Partial') ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                'Refund Amount',
                                prefixIcon: const Icon(Icons.currency_rupee, color: Color(0xFF4B5563)),
                              ),
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF111827),
                                fontSize: bodyFontSize,
                              ),
                            ),
                          ],
                        ],
                        if (_selectedService == 'SI Pause' || _selectedService == 'SI Activate') ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: mandateIdController,
                            decoration: _inputDecoration(
                              'Mandate ID',
                              prefixIcon: const Icon(Icons.vpn_key, color: Color(0xFF4B5563)),
                            ),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF111827),
                              fontSize: bodyFontSize,
                            ),
                          ),
                        ],
                        if (_selectedService == 'SI Pause') ...[
                          const SizedBox(height: 16),
                          DropdownButton<String>(
                            value: _siAction,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _siAction = newValue);
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'Pause', child: Text('Pause')),
                              DropdownMenuItem(value: 'PauseByDate', child: Text('Pause by Date')),
                            ],
                            isExpanded: true,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF111827),
                              fontSize: bodyFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            dropdownColor: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(8),
                            underline: Container(
                              height: 1,
                              color: const Color(0xFFE5E7EB),
                            ),
                          ),
                          if (_siAction == 'PauseByDate') ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: dateController,
                              decoration: _inputDecoration(
                                'Restart Date (YYYY-MM-DD)',
                                prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF4B5563)),
                              ),
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF111827),
                                fontSize: bodyFontSize,
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: 24),
                        if (_serviceResult != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              _serviceResult!,
                              style: GoogleFonts.poppins(
                                fontSize: bodyFontSize,
                                color: const Color(0xFF111827),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleServiceRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Submit Request',
                                    style: GoogleFonts.poppins(
                                      fontSize: bodyFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}