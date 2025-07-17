import 'package:centralproject/screen/airline_interface.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class CurrencySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightBookingProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: PopupMenuButton<String>(
        initialValue: provider.currency,
        onSelected: (value) => provider.updateCurrency(value),
        itemBuilder: (context) => provider.currencyRates.keys.map((currency) {
          return PopupMenuItem(
            value: currency,
            child: Text(currency, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
          );
        }).toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.currency, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}