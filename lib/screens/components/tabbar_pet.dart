import 'package:flutter/material.dart';

class TabbarPetProfile extends StatefulWidget {
  const TabbarPetProfile({super.key});

  @override
  State<TabbarPetProfile> createState() => _TabbarPetProfileState();
}

class _TabbarPetProfileState extends State<TabbarPetProfile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Health'),
              Tab(text: 'Activities'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('Pet Details')),
                Center(child: Text('Health Records')),
                Center(child: Text('Activities Log')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
