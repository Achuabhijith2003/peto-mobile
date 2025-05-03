import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/owner_provider.dart';
import '../providers/auth_provider.dart';
import 'pet_list_screen.dart';
import 'owner_profile_screen.dart';
import 'add_pet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

Future<void> _loadData() async {
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
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);
    final petProvider = Provider.of<PetProvider>(context);
    final currentOwner = ownerProvider.currentOwner;

    final List<Widget> _pages = [
      const PetListScreen(),
      const OwnerProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'My Pets' : 'My Profile',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body:
          ownerProvider.isLoading || petProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : currentOwner == null
              ? const Center(
                child: Text('Please create an owner profile first'),
              )
              : _pages[_selectedIndex],
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
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
