import 'package:flutter/material.dart';
import 'package:peto/utils/color.dart';

class InformationList extends StatelessWidget {
  const InformationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Email"),
          subtitle: Text(
            "name@example.com",
            style: TextStyle(color: AppColor.kSecondary),
          ),
        ),
        ListTile(
          title: Text("Phone"),
          subtitle: Text(
            "+123456789",
            style: TextStyle(color: AppColor.kSecondary),
          ),
        ),
        ListTile(
          title: Text("Address"),
          subtitle: Text(
            "123 Main St, City, Country",
            style: TextStyle(color: AppColor.kSecondary),
          ),
        ),
      ],
    );
  }
}
