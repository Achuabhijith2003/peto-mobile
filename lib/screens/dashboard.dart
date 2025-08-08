import 'package:flutter/material.dart';
import 'package:peto/providers/auth_provider.dart';
import 'package:peto/providers/internet_provider.dart';
import 'package:peto/screens/auth/loginScreen.dart';
import 'package:peto/screens/components/internet_checker.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final InternetProvider internet;

  @override
  void initState() {
    super.initState();
    internet = Provider.of<InternetProvider>(context, listen: false);
    internet.checkinternet().then((isConnected) {
      if (!isConnected) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (ctx) => NoconnectionScreen()));
      }
    });
  }

  @override
  void dispose() {
    internet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [Row(children: [
            
          ],)],
        ),
      ),
    );
  }
}
