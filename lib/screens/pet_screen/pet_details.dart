import 'package:flutter/material.dart';
import 'package:peto/models/pet.dart';

class PetDetailScreen extends StatefulWidget {
  final Pet pet;
  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [Text(widget.pet.name), Text(widget.pet.breed)]),
      ),
    );
  }
}
