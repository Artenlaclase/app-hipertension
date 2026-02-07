import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'education_articles_screen.dart';

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Educación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aprende sobre HTA',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Contenido educativo validado para tu bienestar.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Categorías
            _buildCategorySection(
              context,
              icon: Icons.science_outlined,
              title: 'Impacto del Sodio',
              description:
                  'Entiende cómo el sodio afecta tu presión arterial y cómo reducirlo.',
              articles: 3,
            ),
            _buildCategorySection(
              context,
              icon: Icons.label_outlined,
              title: 'Lectura de Etiquetas',
              description:
                  'Aprende a interpretar la información nutricional de los alimentos.',
              articles: 2,
            ),
            _buildCategorySection(
              context,
              icon: Icons.question_mark,
              title: 'Mitos Alimentarios',
              description:
                  'Desmitifica creencias comunes sobre alimentación e hipertensión.',
              articles: 4,
            ),
            _buildCategorySection(
              context,
              icon: Icons.restaurant_menu,
              title: 'Dieta DASH',
              description:
                  'Conoce el plan alimenticio DASH y sus beneficios para la HTA.',
              articles: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required int articles,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EducationArticlesScreen(
                categoryTitle: title,
                categoryIcon: icon,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$articles artículos',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
