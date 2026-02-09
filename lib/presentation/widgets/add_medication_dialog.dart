import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/medication.dart';

class AddMedicationDialog extends StatefulWidget {
  const AddMedicationDialog({super.key});

  @override
  State<AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends State<AddMedicationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();

  int _frequencyHours = 8;
  TimeOfDay _startTime = TimeOfDay.now();
  TreatmentDuration _duration = TreatmentDuration.days7;

  final List<int> _frequencyOptions = [4, 6, 8, 12, 24];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      helpText: 'Hora de inicio de la primera dosis',
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _startTime.hour,
      _startTime.minute,
    );

    final medication = Medication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      frequencyHours: _frequencyHours,
      startTime: startDateTime,
      duration: _duration,
      endDate: _duration.endDate(startDateTime),
      isActive: true,
      createdAt: now,
    );

    Navigator.of(context).pop(medication);
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final startDateTime = DateTime(
      2025,
      1,
      1,
      _startTime.hour,
      _startTime.minute,
    );

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.medication, color: Color(0xFF1A73E8)),
          SizedBox(width: 8),
          Text('Nuevo Medicamento'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del medicamento
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del medicamento',
                    hintText: 'Ej: Losartán, Enalapril...',
                    prefixIcon: Icon(Icons.medical_services_outlined),
                  ),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Ingrese el nombre' : null,
                ),
                const SizedBox(height: 16),

                // Dosis
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosis',
                    hintText: 'Ej: 50mg, 1 tableta...',
                    prefixIcon: Icon(Icons.science_outlined),
                  ),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Ingrese la dosis' : null,
                ),
                const SizedBox(height: 20),

                // Frecuencia
                Text(
                  '¿Cada cuántas horas?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _frequencyOptions.map((hours) {
                    final selected = _frequencyHours == hours;
                    return ChoiceChip(
                      label: Text('${hours}h'),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _frequencyHours = hours),
                      selectedColor: const Color(
                        0xFF1A73E8,
                      ).withValues(alpha: 0.2),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Hora de inicio
                Text(
                  'Hora de inicio',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickStartTime,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF1A73E8)),
                        const SizedBox(width: 12),
                        Text(
                          timeFormat.format(startDateTime),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Spacer(),
                        const Text(
                          'Cambiar',
                          style: TextStyle(color: Color(0xFF1A73E8)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Duración
                Text(
                  '¿Hasta cuándo?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                RadioGroup<TreatmentDuration>(
                  groupValue: _duration,
                  onChanged: (v) => setState(() => _duration = v),
                  child: Column(
                    children: TreatmentDuration.values.map((d) {
                      return RadioListTile<TreatmentDuration>(
                        title: Text(d.label),
                        value: d,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.check),
          label: const Text('Agregar'),
        ),
      ],
    );
  }
}
