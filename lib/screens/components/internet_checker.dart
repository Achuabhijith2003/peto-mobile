import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:peto/providers/internet_provider.dart';
import 'package:peto/utils/image.dart';
import 'package:provider/provider.dart';

class NoconnectionScreen extends StatefulWidget {
  const NoconnectionScreen({super.key});

  @override
  State<NoconnectionScreen> createState() => _NoconnectionScreenState();
}

class _NoconnectionScreenState extends State<NoconnectionScreen> {
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        return;
      } else {
        Navigator.pop(context);
      }
    });
    _listener = AppLifecycleListener(
      onResume: _subscription.resume,
      onHide: _subscription.pause,
      onPause: _subscription.pause,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final internetprovider = Provider.of<InternetProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(ImagesPath.kNoConnection),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: "Opps!....",
                description:
                    '''Something wrong with your connection, Please try again after a while. or
                    check the internet connection and try again.''',
                // button: you can pass your custom button,
                // btnText: default is retry, you can pass your custom text,
                press: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: 16 * 2.5),
            button ??
                ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(btnText ?? "Retry".toUpperCase()),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
