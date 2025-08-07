import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../widgets/shared_app_bar.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  final TextEditingController gidController = TextEditingController();
  // final TextEditingController merchantTxnIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController mandateIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? _selectedService = 'Status Check';
  String? _captureType = 'Full';
  String? _refundType = 'Full';
  String? _siAction = 'Pause';
  bool _isLoading = false;
  String? _serviceResult;
  
  // Enhanced error handling
  String? _errorMessage;
  String? _errorDetails;
  bool _hasError = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _appBarFadeController;
  late Animation<double> _appBarFadeAnimation;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  // Service definitions with icons and colors
  final List<Map<String, dynamic>> _services = [
    {
      'id': 'Status Check',
      'title': 'Status Check',
      'subtitle': 'Check transaction status',
      'icon': Icons.visibility,
      'color': const Color(0xFF3B82F6),
      'gradient': const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'id': 'Refund',
      'title': 'Initiate Refund',
      'subtitle': 'Process refund transactions',
      'icon': Icons.money_off,
      'color': const Color(0xFFEF4444),
      'gradient': const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'id': 'Capture',
      'title': 'Capture Payment',
      'subtitle': 'Capture authorized payments',
      'icon': Icons.payment,
      'color': const Color(0xFF10B981),
      'gradient': const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'id': 'Reversal',
      'title': 'Auth Reversal',
      'subtitle': 'Reverse authorization',
      'icon': Icons.undo,
      'color': const Color(0xFFF59E0B),
      'gradient': const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'id': 'SI Pause',
      'title': 'SI Pause',
      'subtitle': 'Pause standing instructions',
      'icon': Icons.pause_circle,
      'color': const Color(0xFF8B5CF6),
      'gradient': const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'id': 'SI Activate',
      'title': 'SI Activate',
      'subtitle': 'Activate standing instructions',
      'icon': Icons.play_circle,
      'color': const Color(0xFF06B6D4),
      'gradient': const LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

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
    // Button animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    gidController.dispose();
    // merchantTxnIdController.dispose();
    amountController.dispose();
    mandateIdController.dispose();
    dateController.dispose();
    _fadeController.dispose();
    _appBarFadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _selectService(String serviceId) {
    setState(() {
      _selectedService = serviceId;
    });
    _buttonController.forward().then((_) => _buttonController.reverse());
  }

  Future<void> _handleServiceRequest() async {
    final gid = gidController.text.trim();
    // final merchantTxnId = merchantTxnIdController.text.trim();
    final amount = amountController.text.trim();
    final mandateId = mandateIdController.text.trim();
    final date = dateController.text.trim();

    // Clear any previous errors
    _clearError();

    if (_selectedService == 'Status Check' && gid.isEmpty) {
      _setError('Validation Error', details: 'Please enter a GID for status check.');
      _showSnackBar('Please enter a GID.', Colors.redAccent);
      return;
    }
    if (_selectedService != 'Status Check' && _selectedService != 'SI Pause' && _selectedService != 'SI Activate' && gid.isEmpty) {
      _setError('Validation Error', details: 'Please enter GID for this operation.');
      _showSnackBar('Please enter GID.', Colors.redAccent);
      return;
    }
    if (_selectedService == 'Capture' && _captureType == 'Partial') {
      if (amount.isEmpty) {
        _setError('Validation Error', details: 'Please enter a capture amount for partial capture.');
        _showSnackBar('Please enter a capture amount.', Colors.redAccent);
        return;
      }
      if (double.tryParse(amount) == null || double.parse(amount) <= 0) {
        _setError('Validation Error', details: 'Please enter a valid numeric capture amount greater than 0.');
        _showSnackBar('Please enter a valid numeric capture amount.', Colors.redAccent);
        return;
      }
    }
    if (_selectedService == 'Refund' && _refundType == 'Partial') {
      if (amount.isEmpty) {
        _setError('Validation Error', details: 'Please enter a refund amount for partial refund.');
        _showSnackBar('Please enter a refund amount.', Colors.redAccent);
        return;
      }
      if (double.tryParse(amount) == null || double.parse(amount) <= 0) {
        _setError('Validation Error', details: 'Please enter a valid numeric refund amount greater than 0.');
        _showSnackBar('Please enter a valid numeric refund amount.', Colors.redAccent);
        return;
      }
    }
    if ((_selectedService == 'SI Pause' || _selectedService == 'SI Activate') && mandateId.isEmpty) {
      _setError('Validation Error', details: 'Please enter a Mandate ID for SI operations.');
      _showSnackBar('Please enter a Mandate ID.', Colors.redAccent);
      return;
    }
    if (_selectedService == 'SI Pause' && _siAction == 'PauseByDate') {
      if (date.isEmpty) {
        _setError('Validation Error', details: 'Please enter a date for Pause by Date operation.');
        _showSnackBar('Please enter a date for Pause by Date.', Colors.redAccent);
        return;
      }
      final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!datePattern.hasMatch(date)) {
        _setError('Validation Error', details: 'Invalid date format. Please use YYYY-MM-DD format (e.g., 2024-01-15).');
        _showSnackBar('Invalid date format (use YYYY-MM-DD).', Colors.redAccent);
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      if (_selectedService == 'Capture') {
        await _requestCapture(gid);
      } else if (_selectedService == 'Refund') {
        await _requestRefund(gid);
      } else if (_selectedService == 'Reversal') {
        await _requestReversal(gid);
      } else if (_selectedService == 'SI Pause' || _selectedService == 'SI Activate') {
        await _requestSIPauseActivate(mandateId);
      } else if (_selectedService == 'Status Check') {
        await _checkStatus(gid);
      }
    } catch (e) {
      _setError('Request Failed', details: 'An unexpected error occurred: $e');
      _showSnackBar('Error: $e', Colors.redAccent);
    }
  }
Future<void> _requestCapture(String gid) async {
  print('Requesting capture for GID: $gid,Type: $_captureType');

  final totalAmount = amountController.text.trim().isEmpty ? '0' : amountController.text.trim();

  final body = _captureType == 'Full'
      ? {
          'captureType': 'F',
          'paymentData': {
            'totalAmount': totalAmount,
          },
        }
      : {
          'captureType': 'P',
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
      throw Exception('Request timed out after 20 seconds');
    });

    print('Capture response code: ${response.statusCode}');
    print('Capture response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final captureData = jsonDecode(response.body);
        final captureStatus = captureData['transactionStatus'] ?? captureData['status'] ?? 'unknown';
        final message = captureData['message'] ?? 'Capture completed';
        print('Parsed capture status: $captureStatus');

        if (mounted) {
          _setSuccess('$message\nTransaction Status: $captureStatus');
          _showSnackBar('$message - $captureStatus', Colors.green);
        }
      } catch (e) {
        print('JSON parse error: $e');
        if (mounted) {
          _setError('Response Parse Error', 
            details: 'Failed to parse server response. Raw response: ${response.body}');
          _showSnackBar('Error: Failed to parse response - $e', Colors.redAccent);
        }
      }
    } else {
      print('Capture request failed: ${response.statusCode}');
      print('Capture response headers: ${response.headers}');
      print('Capture response body length: ${response.body.length}');
      print('Capture response body: "${response.body}"');
      if (mounted) {
        _setBackendError(response.body, response.statusCode);
        // Error snackbar is now handled in _setBackendError
      }
    }
  } catch (e) {
    print('Capture request error: $e');
    if (mounted) {
      if (e.toString().contains('timed out')) {
        _setError('Request Timeout', 
          details: 'The capture request took too long to complete. Please check your connection and try again.');
      } else if (e.toString().contains('SocketException')) {
        // Check if backend is running
        final isBackendAvailable = await _checkBackendConnectivity();
        if (!isBackendAvailable) {
          _setError('Backend Server Unavailable', 
            details: '''Unable to connect to the backend server at http://localhost:3000

Please ensure:
1. The backend server is running on port 3000
2. The server is accessible from this application
3. No firewall is blocking the connection

Error details: $e''');
        } else {
          _setError('Connection Error', 
            details: 'Unable to connect to the server. Please check your internet connection.');
        }
      } else {
        _setError('Capture Request Failed', 
          details: 'An error occurred while processing the capture request: $e');
      }
      _showSnackBar('Capture Error: $e', Colors.redAccent);
    }
  }
}


  Future<void> _requestRefund(String gid) async {
    print('Requesting refund for GID: $gid, Type: $_refundType');
    final body = _refundType == 'Full'
        ? {
            'gid': gid,
            'refundType': 'F',
            'paymentData': {
            'totalAmount':0,
            },
          }
        : {
            'gid': gid,
            'refundType': 'P',
            'paymentData': {
              'totalAmount': amountController.text.trim(),
            },
          };
    try {
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
        throw Exception('Request timed out after 20 seconds');
      });

      // print('Refund response code: ${response.statusCode}');
      // print('Refund response body: ${response.body}');

        //  print('response', response)

      if (response.statusCode == 200) {
        try {
          final refundData = jsonDecode(response.body);
          final refundStatus = refundData['transactionStatus'] ?? refundData['status'] ?? 'unknown';
          final message = refundData['message'] ?? 'Refund completed';
          print('Parsed refund status: $refundStatus');
          if (mounted) {
            _setSuccess('$message\nTransaction Status: $refundStatus');
            _showSnackBar('$message - $refundStatus', Colors.green);
          }
        } catch (e) {
          print('JSON parse error: $e');
          print('Raw response: ${response.body}');
          if (mounted) {
            _setError('Response Parse Error', 
              details: 'Failed to parse server response. Raw response: ${response.body}');
            _showSnackBar('Error: Failed to parse response - $e', Colors.redAccent);
          }
        }
      } else {
        print('Refund request failed: ${response.statusCode}');
        print('Refund response headers: ${response.headers}');
        print('Refund response body length: ${response.body.length}');
        print('Refund response body: "${response.body}"');
        if (mounted) {
          _setBackendError(response.body, response.statusCode);
          // Error snackbar is now handled in _setBackendError
        }
      }
    } catch (e) {
      print('Refund request error: $e');
      if (mounted) {
        if (e.toString().contains('timed out')) {
          _setError('Request Timeout', 
            details: 'The refund request took too long to complete. Please check your connection and try again.');
        } else if (e.toString().contains('SocketException')) {
          _setError('Connection Error', 
            details: 'Unable to connect to the server. Please check your internet connection.');
        } else {
          _setError('Refund Request Failed', 
            details: 'An error occurred while processing the refund request: $e');
        }
        _showSnackBar('Error: $e', Colors.redAccent);
      }
    }
  }

  Future<void> _requestReversal(String gid) async {
    print('Sending Auth Reversal for GID: $gid');
    try {
      final response = await http
          .post(
            Uri.parse('$authReversalUrl?gid=$gid'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({}),
          )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out after 10 seconds');
      });

      print('Reversal response code: ${response.statusCode}');
      print('Reversal response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final reversalData = jsonDecode(response.body);
          final reversalStatus = reversalData['transactionStatus'] ?? reversalData['status'] ?? 'Success';
          final message = reversalData['message'] ?? 'Auth Reversal completed';
          _setSuccess('$message\nTransaction Status: $reversalStatus');
          _showSnackBar('$message - $reversalStatus', Colors.green);
        } catch (e) {
          _setSuccess('Auth Reversal Success:\n${response.body}');
          _showSnackBar('Auth Reversal Success', Colors.green);
        }
      } else {
        _setBackendError(response.body, response.statusCode);
        _showSnackBar('Auth Reversal Failed: ${response.statusCode}', Colors.redAccent);
      }
    } catch (e) {
      print('Reversal request error: $e');
      if (e.toString().contains('timed out')) {
        _setError('Request Timeout', 
          details: 'The reversal request took too long to complete. Please check your connection and try again.');
      } else if (e.toString().contains('SocketException')) {
        _setError('Connection Error', 
          details: 'Unable to connect to the server. Please check your internet connection.');
      } else {
        _setError('Reversal Request Failed', 
          details: 'An error occurred while processing the reversal request: $e');
      }
      _showSnackBar('Error: $e', Colors.redAccent);
    }
  }

  Future<void> _requestSIPauseActivate(String mandateId) async {
    print('Sending SI ${_selectedService}, MandateId: $mandateId');
    final payload = {
      "standingInstruction": {
        "action": _selectedService == 'SI Pause' ? (_siAction == 'PauseByDate' ? 'PAUSE' : 'PAUSE') : 'ACTIVATE',
        "mandateId": mandateId,
        if (_siAction == 'PauseByDate' && _selectedService == 'SI Pause') "date": {"startDate": dateController.text.trim()},
      },
    };

    print('Sending payload: ${jsonEncode(payload)}');

    try {
      final response = await http
          .post(
            Uri.parse(pauseActivateUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out after 10 seconds');
      });

      print('SI response code: ${response.statusCode}');
      print('SI response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final siData = jsonDecode(response.body);
          final siStatus = siData['transactionStatus'] ?? siData['status'] ?? 'Success';
          final message = siData['message'] ?? '${_selectedService} completed';
          _setSuccess('$message\nTransaction Status: $siStatus');
          _showSnackBar('$message - $siStatus', Colors.green);
        } catch (e) {
          _setSuccess('${_selectedService} Success:\n${response.body}');
          _showSnackBar('Success: ${_selectedService}', Colors.green);
        }
      } else {
        _setBackendError(response.body, response.statusCode);
        // Error snackbar is now handled in _setBackendError
      }
    } catch (e) {
      print('SI request error: $e');
      if (e.toString().contains('timed out')) {
        _setError('Request Timeout', 
          details: 'The ${_selectedService} request took too long to complete. Please check your connection and try again.');
      } else if (e.toString().contains('SocketException')) {
        _setError('Connection Error', 
          details: 'Unable to connect to the server. Please check your internet connection.');
      } else {
        _setError('${_selectedService} Request Failed', 
          details: 'An error occurred while processing the ${_selectedService} request: $e');
      }
      _showSnackBar('Error: $e', Colors.redAccent);
    }
  }


  Future<void> _checkStatus(String gid) async {
    print('Checking status for GID: $gid');
    try {
      final response = await http
          .get(
            Uri.parse('$statusUrl?gid=$gid'),
            // headers: {'ngrok-skip-browser-warning': 'true'},
          )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out after 10 seconds');
      });

      print('Status response code: ${response.statusCode}');
      print('Status response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final statusData = jsonDecode(response.body);
          final paymentStatus = statusData['transactionStatus'] ?? statusData['status'] ?? 'unknown';
          final message = statusData['message'] ?? 'Status check completed';
          print('Parsed status: $paymentStatus');
          if (mounted) {
            _setSuccess('$message\nTransaction Status: $paymentStatus');
            _showSnackBar('$message - $paymentStatus', Colors.green);
          }
        } catch (e) {
          print('JSON parse error: $e');
          print('Raw response: ${response.body}');
          if (mounted) {
            _setError('Response Parse Error', 
              details: 'Failed to parse server response. Raw response: ${response.body}');
            _showSnackBar('Error: Failed to parse response - $e', Colors.redAccent);
          }
        }
      } else {
        print('Status check failed: ${response.statusCode}');
        print('Raw response: ${response.body}');
        if (mounted) {
          _setBackendError(response.body, response.statusCode);
          // Error snackbar is now handled in _setBackendError
        }
      }
    } catch (e) {
      print('Status check error: $e');
      if (mounted) {
        if (e.toString().contains('timed out')) {
          _setError('Request Timeout', 
            details: 'The status check request took too long to complete. Please check your connection and try again.');
        } else if (e.toString().contains('SocketException')) {
          _setError('Connection Error', 
            details: 'Unable to connect to the server. Please check your internet connection.');
        } else {
          _setError('Status Check Failed', 
            details: 'An error occurred while checking the status: $e');
        }
        _showSnackBar('Error: $e', Colors.redAccent);
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

  // Check if backend is accessible
  Future<bool> _checkBackendConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:3000/api/status'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('Backend connectivity check failed: $e');
      return false;
    }
  }

  // Enhanced error handling methods
  void _setError(String message, {String? details}) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _errorDetails = details;
      _serviceResult = null;
      _isLoading = false;
    });
  }

  void _setBackendError(String responseBody, int statusCode) {
    print('Setting backend error with status: $statusCode');
    print('Raw response body: $responseBody');
    
    // Check if response body is empty or just whitespace
    if (responseBody.trim().isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Backend Error (HTTP $statusCode)';
        _errorDetails = '''No response body received from server.

This could mean:
- The backend server is not running
- The API endpoint is not available
- Network connectivity issues
- Server returned empty response''';
        _serviceResult = null;
        _isLoading = false;
      });
      return;
    }
    
    final errorDetails = _parseErrorResponse(responseBody);
    print('Parsed error details: $errorDetails');
    
    // Extract short error message for snackbar
    String snackbarMessage = 'Error: HTTP $statusCode';
    try {
      final data = jsonDecode(responseBody);
      if (data is Map<String, dynamic>) {
        final payglocalStatus = data['payglocalStatus'];
        final details = data['details'];
        
        if (payglocalStatus == 'REQUEST_ERROR' && details != null) {
          final reasonCode = details['reasonCode'];
          final displayMessage = details['displayMessage'];
          snackbarMessage = 'PayGlocal Error: $reasonCode - $displayMessage';
        } else {
          final message = data['message'];
          final code = data['code'];
          snackbarMessage = 'Error: $code - $message';
        }
      }
    } catch (e) {
      snackbarMessage = 'Error: HTTP $statusCode';
    }
    
    setState(() {
      _hasError = true;
      _errorMessage = 'Backend Error (HTTP $statusCode)';
      _errorDetails = errorDetails;
      _serviceResult = null;
      _isLoading = false;
    });
    
    // Show snackbar with error details
    _showSnackBar(snackbarMessage, Colors.redAccent);
  }

  void _clearError() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _errorDetails = null;
    });
  }

  void _setSuccess(String message) {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _errorDetails = null;
      _serviceResult = message;
      _isLoading = false;
    });
  }

  // Parse error response from API
  String _parseErrorResponse(String responseBody) {
    print('Parsing error response: $responseBody');
    
    try {
      final data = jsonDecode(responseBody);
      print('Parsed JSON data: $data');
      
      if (data is Map<String, dynamic>) {
        // Extract PayGlocal specific error information
        final status = data['status'] ?? 'UNKNOWN_STATUS';
        final message = data['message'] ?? 'No message provided';
        final code = data['code'] ?? 'NO_CODE';
        final payglocalStatus = data['payglocalStatus'];
        final details = data['details'];
        
        // Build comprehensive error message
        String errorMessage = '';
        
        // Add PayGlocal specific details if available
        if (payglocalStatus == 'REQUEST_ERROR' && details != null) {
          final reasonCode = details['reasonCode'];
          final displayMessage = details['displayMessage'];
          final detailedMessage = details['detailedMessage'];
          final timestamp = details['timestamp'];
          final gid = details['gid'];
          
          errorMessage = '''
PayGlocal Error Details:
• Status: $payglocalStatus
• Reason Code: $reasonCode
• Message: $message
• Display Message: $displayMessage
• Detailed Message: $detailedMessage
• Timestamp: $timestamp
• GID: $gid
''';
        } else {
          // Fallback to general error format
          errorMessage = '''
Error Details:
• Status: $status
• Code: $code
• Message: $message
''';
          
          // Add details if available
          if (details != null) {
            if (details is Map<String, dynamic>) {
              details.forEach((key, value) {
                if (value != null && value.toString().isNotEmpty) {
                  errorMessage += '• ${key.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim()}: $value\n';
                }
              });
            } else {
              errorMessage += '• Details: $details\n';
            }
          }
        }
        
        return errorMessage.trim();
      } else {
        return 'Unexpected response format: $data';
      }
    } catch (e) {
      print('JSON parsing failed: $e');
      return 'Failed to parse error response: $responseBody';
    }
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      appBar: SharedAppBar(
        title: 'Services Portal',
        fadeAnimation: _appBarFadeAnimation,
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
                        
                        // Main Content Layout
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Side - Service Buttons
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Services',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Service Buttons Column
                                  ..._services.map((service) {
                                    final isSelected = _selectedService == service['id'];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          _selectService(service['id']);
                                          setState(() {
                                            _serviceResult = null;
                                            _hasError = false;
                                            _errorMessage = null;
                                            _errorDetails = null;
                                            gidController.clear();
                                            amountController.clear();
                                            mandateIdController.clear();
                                            dateController.clear();
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: isSelected 
                                              ? service['gradient'] 
                                              : LinearGradient(
                                                  colors: [
                                                    Colors.grey.shade50,
                                                    Colors.grey.shade100,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                            borderRadius: BorderRadius.circular(12),
                                            border: isSelected
                                              ? Border.all(
                                                  color: service['color'],
                                                  width: 2,
                                                )
                                              : Border.all(
                                                  color: Colors.grey.shade200,
                                                  width: 1,
                                                ),
                                            boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: service['color'].withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: isSelected 
                                                    ? Colors.white.withOpacity(0.2)
                                                    : service['color'].withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  service['icon'],
                                                  size: 24,
                                                  color: isSelected 
                                                    ? Colors.white 
                                                    : service['color'],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      service['title'],
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                        color: isSelected 
                                                          ? Colors.white 
                                                          : const Color(0xFF111827),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      service['subtitle'],
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                        color: isSelected 
                                                          ? Colors.white.withOpacity(0.8)
                                                          : Colors.grey.shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            
                            const SizedBox(width: 24),
                            
                            // Right Side - Form
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Service Form',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Form Content
                                  if (_selectedService != 'SI Pause' && _selectedService != 'SI Activate') ...[
                                    Semantics(
                                      label: 'Enter Global Transaction ID (GID)',
                                      child: TextField(
                                        controller: gidController,
                                        decoration: _inputDecoration('GID', prefixIcon: const Icon(Icons.tag)),
                                        style: GoogleFonts.poppins(fontSize: bodyFontSize),
                                      ),
                                    ),
                                  ],
                                  if (_selectedService != 'Status Check') ...[
                                    const SizedBox(height: 16),
                                    // Semantics(
                                    //   label: 'Enter Merchant Transaction ID',
                                    //   child: TextField(
                                    //     // controller: merchantTxnIdController,
                                    //     decoration: _inputDecoration('Merchant Transaction ID', prefixIcon: const Icon(Icons.receipt)),
                                    //     style: GoogleFonts.poppins(fontSize: bodyFontSize),
                                    //   ),
                                    // ),
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
                                      Semantics(
                                        label: 'Enter amount for partial capture or refund',
                                        child: TextField(
                                          controller: amountController,
                                          decoration: _inputDecoration('Amount', prefixIcon: const Icon(Icons.attach_money)),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          style: GoogleFonts.poppins(fontSize: bodyFontSize),
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
                                      Semantics(
                                        label: 'Enter amount for partial capture or refund',
                                        child: TextField(
                                          controller: amountController,
                                          decoration: _inputDecoration('Amount', prefixIcon: const Icon(Icons.attach_money)),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          style: GoogleFonts.poppins(fontSize: bodyFontSize),
                                        ),
                                      ),
                                    ],
                                  ],
                                  if (_selectedService == 'SI Pause' || _selectedService == 'SI Activate') ...[
                                    const SizedBox(height: 16),
                                    Semantics(
                                      label: 'Enter Mandate ID for SI operations',
                                      child: TextField(
                                        controller: mandateIdController,
                                        decoration: _inputDecoration('Mandate ID', prefixIcon: const Icon(Icons.credit_card)),
                                        style: GoogleFonts.poppins(fontSize: bodyFontSize),
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
                                      Semantics(
                                        label: 'Enter date for SI pause (YYYY-MM-DD format)',
                                        child: TextField(
                                          controller: dateController,
                                          decoration: _inputDecoration('Date (YYYY-MM-DD)', prefixIcon: const Icon(Icons.calendar_today)),
                                          style: GoogleFonts.poppins(fontSize: bodyFontSize),
                                        ),
                                      ),
                                    ],
                                  ],
                                  const SizedBox(height: 24),
                                  Semantics(
                                    label: 'Submit service request',
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: _selectedService != null 
                                          ? _services.firstWhere((s) => s['id'] == _selectedService)['gradient']
                                          : const LinearGradient(
                                              colors: [Color(0xFF6B7280), Color(0xFF4B5563)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (_selectedService != null 
                                              ? _services.firstWhere((s) => s['id'] == _selectedService)['color']
                                              : const Color(0xFF6B7280)).withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _handleServiceRequest,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          shadowColor: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          minimumSize: const Size(44, 44),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    _selectedService != null 
                                                      ? _services.firstWhere((s) => s['id'] == _selectedService)['icon']
                                                      : Icons.send,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Submit ${_selectedService ?? "Request"}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  if (_serviceResult != null) ...[
                                    const SizedBox(height: 24),
                                    Semantics(
                                      label: 'Service request result',
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.green.shade200),
                                        ),
                                        child: Text(
                                          _serviceResult!,
                                          style: GoogleFonts.poppins(
                                            fontSize: bodyFontSize,
                                            color: Colors.green.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (_hasError) ...[
                                    const SizedBox(height: 24),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red.shade700,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Backend Error Response',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: bodyFontSize,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red.shade800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (_errorDetails != null) ...[
                                            const SizedBox(height: 12),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: Colors.red.shade300),
                                              ),
                                              child: Text(
                                                _errorDetails!,
                                                style: GoogleFonts.robotoMono(
                                                  fontSize: bodyFontSize - 1,
                                                  color: Colors.red.shade800,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton.icon(
                                              onPressed: _clearError,
                                              icon: const Icon(Icons.clear, size: 16),
                                              label: const Text('Dismiss Error'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.red.shade700,
                                                side: BorderSide(color: Colors.red.shade300),
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
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