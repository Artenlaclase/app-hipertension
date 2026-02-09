import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/medication.dart';
import '../widgets/add_medication_dialog.dart';

class MedicationTab extends StatefulWidget {
  const MedicationTab({super.key});

  @override
  State<MedicationTab> createState() => _MedicationTabState();
}

class _MedicationTabState extends State<MedicationTab> {
  final List<Medication> _medications = [];
  final Map<String, Map<String, bool>> _dosesTaken = {};
  // _dosesTaken[medicationId][scheduledTimeIso] = true/false

  void _addMedication(Medication med) {
    setState(() {
      _medications.add(med);
      _dosesTaken[med.id] = {};
    });
  }

  void _toggleDose(String medicationId, DateTime scheduledTime) {
    final key = scheduledTime.toIso8601String();
    setState(() {
      _dosesTaken[medicationId] ??= {};
      _dosesTaken[medicationId]![key] =
          !(_dosesTaken[medicationId]![key] ?? false);
    });
  }

  bool _isDoseTaken(String medicationId, DateTime scheduledTime) {
    final key = scheduledTime.toIso8601String();
    return _dosesTaken[medicationId]?[key] ?? false;
  }

  void _deleteMedication(int index) {
    setState(() {
      final med = _medications.removeAt(index);
      _dosesTaken.remove(med.id);
    });
  }

  /// Genera las horas de dosis para hoy
  List<DateTime> _todayDoses(Medication med) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final doses = <DateTime>[];
    DateTime next = med.startTime;

    // Retroceder hasta antes de hoy
    while (next.isAfter(todayEnd)) {
      next = next.subtract(Duration(hours: med.frequencyHours));
    }
    // Avanzar hasta el inicio de hoy
    while (next.isBefore(todayStart)) {
      next = next.add(Duration(hours: med.frequencyHours));
    }
    // Recopilar las dosis de hoy
    while (next.isBefore(todayEnd)) {
      if (med.endDate == null || next.isBefore(med.endDate!)) {
        doses.add(next);
      }
      next = next.add(Duration(hours: med.frequencyHours));
    }
    return doses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: _medications.isEmpty
          ? _buildEmptyState(context)
          : _buildMedicationList(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<Medication>(
            context: context,
            builder: (_) => const AddMedicationDialog(),
          );
          if (result != null) {
            _addMedication(result);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar Medicamento'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin medicamentos registrados',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega tus medicamentos para recibir alertas y llevar un control de tu tratamiento.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationList(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen del día
          _buildDaySummaryCard(context),
          const SizedBox(height: 20),
          Text(
            'Mis Medicamentos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ..._medications.asMap().entries.map((entry) {
            final index = entry.key;
            final med = entry.value;
            return _buildMedicationCard(context, med, index);
          }),
          const SizedBox(height: 80), // espacio para FAB
        ],
      ),
    );
  }

  Widget _buildDaySummaryCard(BuildContext context) {
    int totalDoses = 0;
    int takenDoses = 0;
    for (final med in _medications) {
      final doses = _todayDoses(med);
      totalDoses += doses.length;
      for (final dose in doses) {
        if (_isDoseTaken(med.id, dose)) takenDoses++;
      }
    }
    final progress = totalDoses > 0 ? takenDoses / totalDoses : 0.0;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Adherencia de Hoy',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        progress >= 1.0
                            ? AppTheme.secondaryColor
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$takenDoses de $totalDoses dosis tomadas',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, Medication med, int index) {
    final todayDoses = _todayDoses(med);
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    final isExpired = med.endDate != null && now.isAfter(med.endDate!);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isExpired
                      ? Colors.grey.shade200
                      : AppTheme.primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.medication,
                    color: isExpired ? Colors.grey : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          decoration: isExpired
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        '${med.dosage} · Cada ${med.frequencyHours}h',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') _deleteMedication(index);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  med.duration.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (med.endDate != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '· Hasta ${DateFormat('dd/MM/yyyy').format(med.endDate!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            if (!isExpired && todayDoses.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Dosis de hoy',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: todayDoses.map((doseTime) {
                  final taken = _isDoseTaken(med.id, doseTime);
                  final isPast = doseTime.isBefore(now);
                  return InkWell(
                    onTap: () => _toggleDose(med.id, doseTime),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: taken
                            ? AppTheme.secondaryColor.withValues(alpha: 0.15)
                            : isPast
                            ? AppTheme.errorColor.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: taken
                              ? AppTheme.secondaryColor
                              : isPast
                              ? AppTheme.errorColor.withValues(alpha: 0.5)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            taken
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 18,
                            color: taken
                                ? AppTheme.secondaryColor
                                : isPast
                                ? AppTheme.errorColor
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timeFormat.format(doseTime),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: taken
                                  ? AppTheme.secondaryColor
                                  : isPast
                                  ? AppTheme.errorColor
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (isExpired)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Tratamiento finalizado',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Cómo funciona?'),
        content: const Text(
          '1. Agrega tu medicamento con nombre y dosis.\n'
          '2. Indica cada cuántas horas debes tomarlo.\n'
          '3. Selecciona la hora de inicio.\n'
          '4. Elige la duración del tratamiento.\n'
          '5. Marca cada dosis cuando la tomes para llevar un registro.\n\n'
          '✅ Verde = tomado\n'
          '🔴 Rojo = hora pasada sin tomar\n'
          '⚪ Gris = próxima dosis',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
