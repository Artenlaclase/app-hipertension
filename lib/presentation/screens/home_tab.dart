import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTApp')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo
            Text(
              '¡Hola! 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Tu resumen de hoy',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Tarjeta PA
            _buildSummaryCard(
              context,
              icon: Icons.favorite,
              iconColor: AppTheme.pressureNormal,
              title: 'Presión Arterial',
              subtitle: 'Sin medición hoy',
              actionText: 'Registrar',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            // Tarjeta Medicamentos
            _buildSummaryCard(
              context,
              icon: Icons.medication,
              iconColor: const Color(0xFF7B1FA2),
              title: 'Medicamentos',
              subtitle: 'Controla tus dosis',
              actionText: 'Ver alertas',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            // Tarjeta Hidratación
            _buildSummaryCard(
              context,
              icon: Icons.water_drop,
              iconColor: Colors.blue.shade400,
              title: 'Hidratación',
              subtitle: 'Registra tu consumo de líquidos',
              actionText: 'Registrar',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            // Tarjeta Nutrición
            _buildSummaryCard(
              context,
              icon: Icons.restaurant,
              iconColor: AppTheme.secondaryColor,
              title: 'Alimentación',
              subtitle: 'Sin registros hoy',
              actionText: 'Ver plan',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            // Tarjeta Hábitos
            _buildSummaryCard(
              context,
              icon: Icons.check_circle,
              iconColor: AppTheme.primaryColor,
              title: 'Hábitos',
              subtitle: '0 de 0 completados',
              actionText: 'Ver hábitos',
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Tip del día
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 Tip del día',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'La dieta DASH recomienda consumir menos de 1,500 mg '
                    'de sodio al día para ayudar a controlar la presión arterial.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: iconColor.withValues(alpha: 0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: TextButton(onPressed: onTap, child: Text(actionText)),
      ),
    );
  }
}
