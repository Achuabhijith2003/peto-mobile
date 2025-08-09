import 'package:flutter/material.dart';
import 'package:peto/providers/auth_provider.dart';
import 'package:peto/providers/pet_provider.dart';
import 'package:peto/screens/auth/signupScreen.dart';
import 'package:peto/screens/components/button.dart';
import 'package:peto/utils/color.dart';
import 'package:provider/provider.dart';
import '../components/pet_list.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PetListScreen extends StatefulWidget {
  PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  XFile? _petImage;

  Future<void> _pickPetImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _petImage = image;
      });
    }
  }

  TextEditingController Nicknamecontroler = TextEditingController();

  TextEditingController PetTypeController = TextEditingController();

  bool _isLoading = false;

  late final AuthProvider authProvider;
  late final PetProvider petProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    petProvider = Provider.of<PetProvider>(context, listen: false);
  }

  // ignore: non_constant_identifier_names
  submit_add_pet() {
    setState(() {
      _isLoading = true;
    });
    String nickname = Nicknamecontroler.text;
    String petType = PetTypeController.text;
    if (nickname.isEmpty || petType.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      // Show an error message or handle empty fields
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }
    // Add your submit logic here
    try {
      File file = File(_petImage!.path);
      print('image path: ${file.path}');
      petProvider.addPet(
        authProvider.user!.uid,
        nickname,
        petType,
        DateTime.now(), // Example date, replace with actual input
        file,
        [], // Replace with actual vaccination history if needed
      );
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (error) {
      // Handle error, show a message, etc.
      print('Error adding pet: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error in adding pet')));
      Navigator.of(context).pop();
    }

    setState(() {
      _isLoading = false;
    });
  }

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
            Expanded(child: Petlistcomponent()),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 60,
          width: 120,
          child: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Add New Pet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickPetImage,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    _petImage != null
                                        ? Image.file(
                                          File(_petImage!.path),
                                        ).image
                                        : null,
                                child:
                                    _petImage == null ? Icon(Icons.edit) : null,
                              ),
                            ),
                            Text("Edit Pet Image"),
                            SizedBox(height: 16),
                            Center(
                              child: PrimaryTextFormField(
                                hintText: "Pet Nickname",
                                controller: Nicknamecontroler,
                                width: 327,
                                height: 52,
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: PrimaryTextFormField(
                                hintText: "Pet Type",
                                controller: PetTypeController,
                                width: 327,
                                height: 52,
                              ),
                            ),
                            SizedBox(height: 16),
                            PrimaryButton(
                              elevation: 0,
                              onTap: () {
                                _isLoading ? null : submit_add_pet();
                              },
                              text: 'Add Pet',
                              bgColor: AppColor.kPrimary,
                              borderRadius: 20,
                              height: 46,
                              width: 327,
                              textColor: AppColor.kWhite,
                              fontSize: 14,
                              isloading: petProvider.isLoading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: AppColor.kPrimary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.add, color: AppColor.kLine, size: 22),
                  Text(
                    "Add Pet",
                    style: TextStyle(color: AppColor.kLine, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
