import 'package:flutter/material.dart';
import '../../views/bet_screen.dart';

class BetButton extends StatelessWidget {
  const BetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BetScreen(),
            ),
          );
        },
        icon: Image.asset(
          'assets/images/ticket.png',
          height: 40.0,
          color: Colors.white,
        ),
        label: const Text(
          'Apostar',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 8, 137, 12),
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 6.0,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}
