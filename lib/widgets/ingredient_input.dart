import 'package:flutter/material.dart';

class IngredientInput extends StatefulWidget {
  const IngredientInput({super.key});

  @override
  State<IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends State<IngredientInput> {
  final List<String> _ingredients = [];
  final TextEditingController _controller = TextEditingController();

  void _addIngredient(String ingredient) {
    if (ingredient.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(ingredient.trim());
      });
      _controller.clear();
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
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
          children: _ingredients.map((ingredient) {
            return Chip(
              label: Text(ingredient),
              onDeleted: () {
                _removeIngredient(_ingredients.indexOf(ingredient));
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
