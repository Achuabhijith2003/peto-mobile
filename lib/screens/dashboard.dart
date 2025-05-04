import 'package:flutter/material.dart';
import 'package:peto/providers/auth_provider.dart';
import 'package:peto/screens/auth/loginScreen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle sign out logic here
              showDialog(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Perform sign out action
                            Navigator.of(ctx).pop(true);
                            try {
                              await authProvider.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => SignInScreen(),
                                ),
                              );
                            } catch (e) {
                              // Handle sign out error
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error signing out: $e'),
                                ),
                              );
                            }
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Dashboard!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to another screen or perform an action
              },
              child: const Text('Go to Pet List'),
            ),
          ],
        ),
      ),
    );
  }
}
