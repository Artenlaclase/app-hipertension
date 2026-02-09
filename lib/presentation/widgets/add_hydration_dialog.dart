import 'package:flutter/material.dart';
import '../../domain/entities/hydration.dart';

class AddHydrationDialog extends StatefulWidget {
  const AddHydrationDialog({super.key});

  @override
  State<AddHydrationDialog> createState() => _AddHydrationDialogState();
}

class _AddHydrationDialogState extends State<AddHydrationDialog> {
  LiquidType _liquidType = LiquidType.water;
  int _amountMl = 250;
  final _noteController = TextEditingController();

  final List<int> _quickAmounts = [100, 200, 250, 330, 500];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final record = HydrationRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      liquidType: _liquidType,
      amountMl: _amountMl,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      timestamp: DateTime.now(),
    );
    Navigator.of(context).pop(record);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Text('💧', style: TextStyle(fontSize: 24)),
          SizedBox(width: 8),
          Text('Registrar Líquido'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo de líquido
              Text(
                '¿Qué tomaste?',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: LiquidType.values.map((type) {
                  final selected = _liquidType == type;
                  return ChoiceChip(
                    avatar: Text(type.icon),
                    label: Text(type.label),
                    selected: selected,
                    onSelected: (_) => setState(() => _liquidType = type),
                    selectedColor: Colors.blue.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Cantidad
              Text(
                'Cantidad (ml)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _quickAmounts.map((amount) {
                  final selected = _amountMl == amount;
                  return ChoiceChip(
                    label: Text('${amount}ml'),
                    selected: selected,
                    onSelected: (_) => setState(() => _amountMl = amount),
                    selectedColor: Colors.blue.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Slider para cantidad personalizada
              Row(
                children: [
                  const Icon(Icons.water_drop, size: 16, color: Colors.blue),
                  Expanded(
                    child: Slider(
                      value: _amountMl.toDouble(),
                      min: 50,
                      max: 1000,
                      divisions: 19,
                      label: '${_amountMl}ml',
                      onChanged: (v) => setState(() => _amountMl = v.toInt()),
                    ),
                  ),
                  Text(
                    '${_amountMl}ml',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Nota opcional
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  hintText: 'Ej: Agua con limón, Manzanilla...',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
            ],
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
          label: const Text('Registrar'),
        ),
      ],
    );
  }
}
