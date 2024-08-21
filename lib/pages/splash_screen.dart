import 'package:taufiqsejati_motobike_cs/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(70),
          Image.asset(
            'assets/logo_text.png',
            height: 38,
            width: 171,
          ),
          const Gap(10),
          const Text(
            'Rent Our Bike Today',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xff070623),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(-99, 0),
              child: Image.asset(
                'assets/splash_screen.png',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              'Help people to have a great moments while riding our best choices motorcycles',
              style: TextStyle(
                height: 1.7,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff070623),
              ),
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ButtonPrimary(
              text: 'Get Started',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
