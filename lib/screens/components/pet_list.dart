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
    if (myPets.isEmpty) {
      return Center(
        child: Text(
          'No pets found. Please add a pet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    } else if (myPets.isNotEmpty) {
      if (petProvider.isLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return ListView.builder(
          itemCount: myPets.length,
          itemBuilder: (context, index) {
            Pet pet = myPets[index];
            return Card(
              color: AppColor.kBackground2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      Image.asset('assets/images/pet_placeholder.png').image,
                ),
                title: Text(pet.name, style: TextStyle(fontSize: 18)),
                subtitle: Text(
                  "${pet.breed}, 5 years old",
                  style: TextStyle(color: AppColor.kSecondary),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetDetailScreen(pet: pet),
                    ),
                  );
                },
              ),
            );
          },
        );
      }
    }
    // Fallback widget in case none of the above conditions are met
    return SizedBox.shrink();
  }
}
