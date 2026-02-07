import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AddBloodPressureDialog extends StatefulWidget {
  const AddBloodPressureDialog({super.key});

  @override
  State<AddBloodPressureDialog> createState() => _AddBloodPressureDialogState();
}

class _AddBloodPressureDialogState extends State<AddBloodPressureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(double systolic, double diastolic) {
    if (systolic >= 180 || diastolic >= 120) return AppTheme.pressureCrisis;
    if (systolic >= 140 || diastolic >= 90) return AppTheme.pressureHigh;
    if (systolic >= 130 || diastolic >= 80) return AppTheme.pressureElevated;
    return AppTheme.pressureNormal;
  }

  String _getCategoryLabel(double systolic, double diastolic) {
    if (systolic >= 180 || diastolic >= 120) return '⚠️ Crisis hipertensiva';
    if (systolic >= 140 || diastolic >= 90) return 'Presión alta';
    if (systolic >= 130 || diastolic >= 80) return 'Presión elevada';
    return '✅ Normal';
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'systolic': double.parse(_systolicController.text),
        'diastolic': double.parse(_diastolicController.text),
        'pulse': _pulseController.text.isNotEmpty
            ? int.parse(_pulseController.text)
            : null,
        'notes': _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        'recordedAt': DateTime.now().toIso8601String(),
      };
      Navigator.of(context).pop(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Presión'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: _submit,
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingresa tu medición',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Registra los valores de tu tensiómetro.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Sistólica y Diastólica en fila
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _systolicController,
                        decoration: const InputDecoration(
                          labelText: 'Sistólica',
                          suffixText: 'mmHg',
                          prefixIcon: Icon(
                            Icons.arrow_upward,
                            color: AppTheme.errorColor,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Requerido';
                          }
                          final val = double.tryParse(v);
                          if (val == null || val < 60 || val > 300) {
                            return '60-300';
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '/',
                        style: TextStyle(
                          fontSize: 28,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _diastolicController,
                        decoration: const InputDecoration(
                          labelText: 'Diastólica',
                          suffixText: 'mmHg',
                          prefixIcon: Icon(
                            Icons.arrow_downward,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Requerido';
                          }
                          final val = double.tryParse(v);
                          if (val == null || val < 30 || val > 200) {
                            return '30-200';
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Indicador en tiempo real
                if (_systolicController.text.isNotEmpty &&
                    _diastolicController.text.isNotEmpty)
                  Builder(
                    builder: (context) {
                      final sys =
                          double.tryParse(_systolicController.text) ?? 0;
                      final dia =
                          double.tryParse(_diastolicController.text) ?? 0;
                      if (sys > 0 && dia > 0) {
                        final color = _getCategoryColor(sys, dia);
                        final label = _getCategoryLabel(sys, dia);
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                const SizedBox(height: 16),

                // Pulso
                TextFormField(
                  controller: _pulseController,
                  decoration: const InputDecoration(
                    labelText: 'Pulso (opcional)',
                    suffixText: 'bpm',
                    prefixIcon: Icon(Icons.monitor_heart_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Notas
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas (opcional)',
                    prefixIcon: Icon(Icons.note_outlined),
                    hintText: 'Ej: después de caminar, en reposo...',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
