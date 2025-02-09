import 'package:flutter/material.dart';

class IngredientInput extends StatefulWidget {
  final List<String> ingredients;
  final Function(String) onAdd;
  final Function(int) onRemove;

  const IngredientInput({
    super.key,
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends State<IngredientInput> {
  final TextEditingController _controller = TextEditingController();

  void _addIngredient(String ingredient) {
    if (ingredient.trim().isNotEmpty) {
      widget.onAdd(ingredient.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Field
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText:
                'Masukkan bahan sisa kamu (contoh: telur, nasi, tempe)...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Implementasi input suara
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: _addIngredient,
        ),

        const SizedBox(height: 8),

        // Daftar Bahan
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.ingredients.asMap().entries.map((entry) {
            final index = entry.key;
            final ingredient = entry.value;
            return Chip(
              label: Text(ingredient),
              onDeleted: () => widget.onRemove(index),
            );
          }).toList(),
        ),
      ],
    );
  }
}
