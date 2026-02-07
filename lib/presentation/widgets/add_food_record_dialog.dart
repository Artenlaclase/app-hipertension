import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/food.dart';

class AddFoodRecordDialog extends StatefulWidget {
  const AddFoodRecordDialog({super.key});

  @override
  State<AddFoodRecordDialog> createState() => _AddFoodRecordDialogState();
}

class _AddFoodRecordDialogState extends State<AddFoodRecordDialog> {
  String _selectedMealType = 'desayuno';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  // Alimentos de ejemplo para la demo
  static const _sampleFoods = [
    _FoodItem('Avena', 'Cereales', SodiumLevel.low, true, '🥣'),
    _FoodItem('Plátano', 'Frutas', SodiumLevel.low, true, '🍌'),
    _FoodItem('Espinaca', 'Verduras', SodiumLevel.low, true, '🥬'),
    _FoodItem('Salmón', 'Proteínas', SodiumLevel.low, true, '🐟'),
    _FoodItem('Yogurt natural', 'Lácteos', SodiumLevel.low, true, '🥛'),
    _FoodItem('Nueces', 'Frutos secos', SodiumLevel.low, true, '🥜'),
    _FoodItem('Pollo a la plancha', 'Proteínas', SodiumLevel.low, true, '🍗'),
    _FoodItem('Arroz integral', 'Cereales', SodiumLevel.low, true, '🍚'),
    _FoodItem('Brócoli', 'Verduras', SodiumLevel.low, true, '🥦'),
    _FoodItem('Manzana', 'Frutas', SodiumLevel.low, true, '🍎'),
    _FoodItem('Pan blanco', 'Cereales', SodiumLevel.medium, false, '🍞'),
    _FoodItem('Queso procesado', 'Lácteos', SodiumLevel.high, false, '🧀'),
    _FoodItem('Embutidos', 'Proteínas', SodiumLevel.high, false, '🥩'),
    _FoodItem('Papas fritas', 'Snacks', SodiumLevel.high, false, '🍟'),
    _FoodItem('Sopa instantánea', 'Preparados', SodiumLevel.high, false, '🍜'),
  ];

  List<_FoodItem> get _filteredFoods {
    if (_searchQuery.isEmpty) return _sampleFoods;
    return _sampleFoods
        .where(
          (f) =>
              f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              f.category.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectFood(_FoodItem food) {
    final data = {
      'name': food.name,
      'category': food.category,
      'sodiumLevel': food.sodiumLevel.name,
      'isRecommended': food.isRecommended,
      'mealType': _selectedMealType,
      'recordedAt': DateTime.now().toIso8601String(),
    };
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Alimento'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            // Tipo de comida
            Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'desayuno', label: Text('🌅')),
                  ButtonSegment(value: 'almuerzo', label: Text('☀️')),
                  ButtonSegment(value: 'cena', label: Text('🌙')),
                  ButtonSegment(value: 'snack', label: Text('🍎')),
                ],
                selected: {_selectedMealType},
                onSelectionChanged: (v) =>
                    setState(() => _selectedMealType = v.first),
              ),
            ),

            // Búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar alimento...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            const SizedBox(height: 8),

            // Lista de alimentos
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = _filteredFoods[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      leading: Text(
                        food.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(
                        food.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Row(
                        children: [
                          Text(food.category),
                          const SizedBox(width: 8),
                          _buildSodiumBadge(food.sodiumLevel),
                        ],
                      ),
                      trailing: food.isRecommended
                          ? const Icon(
                              Icons.thumb_up,
                              color: AppTheme.secondaryColor,
                              size: 20,
                            )
                          : const Icon(
                              Icons.warning_amber,
                              color: AppTheme.warningColor,
                              size: 20,
                            ),
                      onTap: () => _selectFood(food),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSodiumBadge(SodiumLevel level) {
    final (label, color) = switch (level) {
      SodiumLevel.low => ('Bajo Na', AppTheme.secondaryColor),
      SodiumLevel.medium => ('Medio Na', AppTheme.warningColor),
      SodiumLevel.high => ('Alto Na', AppTheme.errorColor),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FoodItem {
  final String name;
  final String category;
  final SodiumLevel sodiumLevel;
  final bool isRecommended;
  final String emoji;

  const _FoodItem(
    this.name,
    this.category,
    this.sodiumLevel,
    this.isRecommended,
    this.emoji,
  );
}
