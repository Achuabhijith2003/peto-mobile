import 'package:flutter/material.dart';
import 'package:peto/screens/dashboard.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/owner_provider.dart';
import '../providers/auth_provider.dart';
import 'pet_list_screen.dart';
import 'owner_profile_screen.dart';
import 'add_pet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _loadData();
      _isInit = true;
    }
  }

  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      // Update state safely
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ownerProvider = Provider.of<OwnerProvider>(context, listen: false);
      final petProvider = Provider.of<PetProvider>(context, listen: false);

      await ownerProvider.loadOwnerProfile();
      await petProvider.loadPets();

      if (ownerProvider.currentOwner == null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const OwnerProfileScreen(isNewOwner: true),
          ),
        );
      }
    });
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
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
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing operations or listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);
    final petProvider = Provider.of<PetProvider>(context);
    final currentOwner = ownerProvider.currentOwner;

    final List<Widget> pages = [
      const Dashboard(),
      const PetListScreen(),
      const OwnerProfileScreen(),
    ];

    return Scaffold(
      body:
          ownerProvider.isLoading || petProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : currentOwner == null
              ? const Center(
                child: Text('Please create an owner profile first'),
              )
              : pages[_selectedIndex],
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const AddPetScreen()),
                  );
                },
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
