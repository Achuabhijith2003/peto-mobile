import 'package:flutter/material.dart';
import 'components/pet_list.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const Text(
                'My Pets',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Petlistcomponent(),
            ),
          ],
        ),
      ),
    );
  }
}
