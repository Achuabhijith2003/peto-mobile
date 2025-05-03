import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
// import '../models/pet.dart';
import 'edit_pet_screen.dart';
import 'vaccination_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final pet = petProvider.getPetById(petId);

    if (pet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pet Details')),
        body: const Center(child: Text('Pet not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => EditPetScreen(pet: pet)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet image
            SizedBox(
              height: 250,
              width: double.infinity,
              child:
                  pet.imageUrl.isNotEmpty
                      ? Image.network(pet.imageUrl, fit: BoxFit.cover)
                      : Image.asset(
                        'assets/images/pet_placeholder.png',
                        fit: BoxFit.cover,
                      ),
            ),

            // Pet info
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
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pet.age,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Breed: ${pet.breed}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Birth date: ${pet.birthDate.day}/${pet.birthDate.month}/${pet.birthDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // Vaccination section
                  const Text(
                    'Vaccination History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  if (pet.vaccinationHistory.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No vaccination history yet'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pet.vaccinationHistory.length,
                      itemBuilder: (ctx, i) {
                        final vaccination = pet.vaccinationHistory[i];
                        return ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          title: Text(vaccination.name),
                          subtitle: Text(
                            '${vaccination.date.day}/${vaccination.date.month}/${vaccination.date.year}',
                          ),
                          trailing:
                              vaccination.notes.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: Text(vaccination.name),
                                              content: Text(vaccination.notes),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            ctx,
                                                          ).pop(),
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  )
                                  : null,
                        );
                      },
                    ),

                  const SizedBox(height: 24),

                  // Upcoming vaccinations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Vaccinations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (ctx) => VaccinationScreen(petId: pet.id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (pet.upcomingVaccinations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No upcoming vaccinations'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pet.upcomingVaccinations.length,
                      itemBuilder: (ctx, i) {
                        final vaccination = pet.upcomingVaccinations[i];
                        return ListTile(
                          leading: const Icon(Icons.event_available),
                          title: Text(vaccination.name),
                          subtitle: Text(
                            '${vaccination.date.day}/${vaccination.date.month}/${vaccination.date.year}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (vaccination.notes.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (ctx) => AlertDialog(
                                            title: Text(vaccination.name),
                                            content: Text(vaccination.notes),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(ctx).pop(),
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (ctx) => AlertDialog(
                                          title: const Text(
                                            'Mark as Completed',
                                          ),
                                          content: Text(
                                            'Mark ${vaccination.name} as completed?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(ctx).pop(),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                petProvider.completeVaccination(
                                                  pet.id,
                                                  vaccination.id,
                                                );
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text('Complete'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
