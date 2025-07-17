import 'package:centralproject/models/airlineModels/passenger.dart';
import 'package:centralproject/screen/airline_interface.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class PassengerInputPage extends StatefulWidget {
  const PassengerInputPage({Key? key}) : super(key: key);

  @override
  _PassengerInputPageState createState() => _PassengerInputPageState();
}

class _PassengerInputPageState extends State<PassengerInputPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, TextEditingController>> _passengerControllers = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FlightBookingProvider>(context, listen: false);
    for (int i = 0; i < provider.passengers; i++) {
      _passengerControllers.add({
        'firstName': TextEditingController(),
        'lastName': TextEditingController(),
        'email': TextEditingController(),
      });
    }
  }

  @override
  void dispose() {
    for (var controllerMap in _passengerControllers) {
      controllerMap['firstName']?.dispose();
      controllerMap['lastName']?.dispose();
      controllerMap['email']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightBookingProvider>(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
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
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2))),
          ),
        ),
        title: Text(
          'Passenger Details',
          style: GoogleFonts.playfairDisplay(
            fontSize: isLargeScreen ? 28 : 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                itemCount: provider.passengers,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white.withOpacity(0.8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passenger ${index + 1}',
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passengerControllers[index]['firstName'],
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: GoogleFonts.poppins(color: Colors.black54),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            validator: (value) => value!.isEmpty ? 'First name is required' : null,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passengerControllers[index]['lastName'],
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: GoogleFonts.poppins(color: Colors.black54),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            validator: (value) => value!.isEmpty ? 'Last name is required' : null,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passengerControllers[index]['email'],
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.poppins(color: Colors.black54),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return 'Email is required';
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final passengers = _passengerControllers.map((controller) => Passenger(
              firstName: controller['firstName']!.text,
              lastName: controller['lastName']!.text,
              email: controller['email']!.text,
            )).toList();
            provider.updatePassengersData(passengers);
            Navigator.pushNamed(context, '/booking_details', arguments: provider.selectedRoutes);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fix the errors in the form')),
            );
          }
        },
        backgroundColor: Color.fromARGB(255, 12, 12, 12),
        child: Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}