import 'package:flutter/material.dart';
import 'package:peto/utils/color.dart';

class Petlistcomponent extends StatefulWidget {
  const Petlistcomponent({super.key});

  @override
  State<Petlistcomponent> createState() => PetlistcomponentState();
}

class PetlistcomponentState extends State<Petlistcomponent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 60,
            height: 60,
            color: const Color.fromARGB(255, 229, 150, 150),
            child: Image.asset('assets/images/app_logo.png'),
          ),
          title: Text(
            'Pet ${index + 1}',
            style: TextStyle(color: AppColor.kGrayscaleDark100),
          ),
          subtitle: Text(
            'Description of Pet ${index + 1}',
            style: TextStyle(color: AppColor.kSecondary),
          ),
        );
      },
    );
  }
}
