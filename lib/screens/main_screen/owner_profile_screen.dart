import 'package:flutter/material.dart';
import 'package:peto/models/owner.dart';
import 'package:peto/providers/auth_provider.dart';
import 'package:peto/providers/owner_provider.dart';
import 'package:peto/screens/components/onwer_componets.dart';
import 'package:peto/utils/color.dart';
import 'package:provider/provider.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);
    Future<Owner?> ownerProfile = ownerProvider.fetchOwnerProfile();
    if (ownerProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: ownerProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColor.kPrimary),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final owner = snapshot.data;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: AssetImage(
                                'assets/images/app_logo.png',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${owner?.firstname} ${owner?.secondname}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            owner?.id ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColor.kSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Personal Information",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.kPrimary,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [Icon(Icons.edit), Text("Edit")],
                                ),
                              ),
                            ],
                          ),
                          InformationList(owner: owner),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
    }
  }
}
