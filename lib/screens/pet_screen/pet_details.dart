import 'package:flutter/material.dart';
import 'package:peto/models/pet.dart';
import 'package:peto/screens/components/tabbar_pet.dart';
import 'package:peto/utils/color.dart';

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
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back, size: 28, color: Colors.black),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Pet Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.settings, size: 28, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 36),
            Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      Image.asset('assets/images/pet_placeholder.png').image,
                ),
                SizedBox(height: 10),
                Text(widget.pet.name, style: TextStyle(fontSize: 20)),
                Text(
                  "${widget.pet.breed}, 5 years old",
                  style: TextStyle(fontSize: 15, color: AppColor.kSecondary),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: TabbarPetProfile()),
          ],
        ),
      ),
    );
  }
}
