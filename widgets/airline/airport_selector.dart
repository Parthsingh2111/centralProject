import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AirportSelector extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const AirportSelector({
    required this.label,
    required this.value,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.flight_takeoff, color: Colors.black, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}