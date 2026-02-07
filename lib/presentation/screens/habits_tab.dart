import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/add_habit_dialog.dart';

class HabitsTab extends StatelessWidget {
  const HabitsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hábitos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progreso del día
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Progreso de Hoy',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: 0,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation(
                                AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                          const Text(
                            '0%',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '0 de 0 hábitos completados',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Hábitos sugeridos
            Text(
              'Hábitos Sugeridos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildHabitSuggestion(
              context,
              icon: '❤️',
              title: 'Medir presión arterial',
              description: 'Registra tu PA diariamente',
            ),
            _buildHabitSuggestion(
              context,
              icon: '🥗',
              title: 'Consumir frutas y verduras',
              description: 'Al menos 5 porciones al día',
            ),
            _buildHabitSuggestion(
              context,
              icon: '💧',
              title: 'Hidratación',
              description: 'Beber al menos 8 vasos de agua',
            ),
            _buildHabitSuggestion(
              context,
              icon: '🚶',
              title: 'Caminar 30 minutos',
              description: 'Actividad física moderada diaria',
            ),
            _buildHabitSuggestion(
              context,
              icon: '🧂',
              title: 'Reducir sal',
              description: 'Evitar agregar sal extra a las comidas',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (_) => const AddHabitDialog(),
          );
          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hábito "${result['title']}" creado'),
                backgroundColor: AppTheme.secondaryColor,
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Hábito'),
      ),
    );
  }

  Widget _buildHabitSuggestion(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 28)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: AppTheme.primaryColor,
          onPressed: () async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (_) => AddHabitDialog(
                initialTitle: title,
                initialDescription: description,
                initialIcon: icon,
              ),
            );
            if (result != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Hábito "${result['title']}" agregado'),
                  backgroundColor: AppTheme.secondaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
