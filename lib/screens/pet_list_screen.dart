import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/owner_provider.dart';
import '../models/pet.dart';
import 'pet_detail_screen.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);
    final petProvider = Provider.of<PetProvider>(context);
    final currentOwner = ownerProvider.currentOwner;

    if (currentOwner == null) {
      return const Center(child: Text('Please create an owner profile first'));
    }

    final pets = petProvider.getPetsByOwner(currentOwner.id);

    return pets.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty_pets.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'No pets added yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap the + button to add your first pet',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pets.length,
          itemBuilder: (ctx, i) => PetCard(pet: pets[i]),
        );
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upcomingVaccinations = pet.upcomingVaccinations;
    final nextVaccination =
        upcomingVaccinations.isNotEmpty
            ? upcomingVaccinations.reduce(
              (a, b) => a.date.isBefore(b.date) ? a : b,
            )
            : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => PetDetailScreen(petId: pet.id)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child:
                  pet.imageUrl.isNotEmpty
                      ? Image.network(
                        pet.imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'assets/images/pet_placeholder.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pet.age,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(pet.breed, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  if (nextVaccination != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 16,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Next vaccination: ${nextVaccination.name}',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${nextVaccination.date.day}/${nextVaccination.date.month}/${nextVaccination.date.year}',
                          style: TextStyle(color: theme.colorScheme.secondary),
                        ),
                      ],
                    ),
                  ] else
                    Text(
                      'No upcoming vaccinations',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
