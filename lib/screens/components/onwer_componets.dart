import 'package:flutter/material.dart';
import 'package:peto/models/owner.dart';
import 'package:peto/utils/color.dart';

class InformationList extends StatelessWidget {
  final Owner? owner;
  const InformationList({super.key, this.owner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Email"),
          subtitle: Text(
            owner?.email ?? 'Not provided',
            style: TextStyle(color: AppColor.kSecondary),
          ),
        ),
        ListTile(
          title: Text("Phone"),
          subtitle: Text(
            owner?.phone ?? 'Not provided',
            style: TextStyle(color: AppColor.kSecondary),
          ),
        ),
        ListTile(
          title: Text("Address"),
          subtitle: Text(
            owner?.address ?? 'Not provided',
            style: TextStyle(color: AppColor.kSecondary),
          ),
        ),
      ],
    );
  }
}
