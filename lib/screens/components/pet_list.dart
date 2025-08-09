import 'package:flutter/material.dart';
import 'package:peto/providers/auth_provider.dart';
import 'package:peto/providers/pet_provider.dart';
import 'package:peto/screens/pet_screen/pet_details.dart';
import 'package:peto/utils/color.dart';
import 'package:provider/provider.dart';
import '../../models/pet.dart';

class Petlistcomponent extends StatefulWidget {
  const Petlistcomponent({super.key});

  @override
  State<Petlistcomponent> createState() => PetlistcomponentState();
}

class PetlistcomponentState extends State<Petlistcomponent> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    List<Pet> myPets = petProvider.getPetsByOwner(authProvider.user!.uid);
    return ListView.builder(
      itemCount: myPets.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // Handle pet item tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetDetailScreen(pet: myPets[index]),
              ),
            );
          },
          minLeadingWidth: 65,
          leading: Container(
            width: 70,
            height: 60,
            color: const Color.fromARGB(255, 229, 150, 150),
            child: Image.asset('assets/images/app_logo.png'),
          ),
          title: Text(
            myPets[index].name,
            style: TextStyle(color: AppColor.kGrayscaleDark100),
          ),
          subtitle: Text(
            myPets[index].breed,
            style: TextStyle(color: AppColor.kSecondary),
          ),
        );
      },
    );
  }
}
