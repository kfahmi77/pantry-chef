import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RecipeResultScreen extends StatefulWidget {
  final String recipeName;
  final List<String> ingredients;
  final List<String> steps;
  final String tips;
  final int wtfLevel;

  const RecipeResultScreen({
    super.key,
    required this.recipeName,
    required this.ingredients,
    required this.steps,
    required this.tips,
    required this.wtfLevel,
  });

  @override
  State<RecipeResultScreen> createState() => _RecipeResultScreenState();
}

class _RecipeResultScreenState extends State<RecipeResultScreen> {
  late Map<String, bool> _checkedIngredients;

  @override
  void initState() {
    super.initState();
    // Inisialisasi checklist dengan semua nilai false
    _checkedIngredients = {
      for (var ingredient in widget.ingredients) ingredient: false
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Resep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implementasi share resep
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Resep
            Text(
              widget.recipeName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // WTF Level
            if (widget.wtfLevel > 3)
              Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'WTF Level: ${widget.wtfLevel}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Bahan dengan CheckboxListTile
            Text(
              'Bahan:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...widget.ingredients.map((ingredient) {
              return CheckboxListTile(
                title: Text(
                  ingredient,
                  style: _checkedIngredients[ingredient] == true
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                value: _checkedIngredients[ingredient],
                onChanged: (value) {
                  setState(() {
                    _checkedIngredients[ingredient] = value!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 16),

            // Langkah-Langkah
            Text(
              'Langkah-Langkah:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...widget.steps.asMap().entries.map((entry) {
              final int index = entry.key + 1;
              final String step = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  child: Text('$index'),
                ),
                title: Text(step),
              );
            }).toList(),
            const SizedBox(height: 16),

            // Tips Penyajian
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Tips Penyajian:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.tips),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Re-generate
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implementasi re-generate resep
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Re-generate Resep'),
              ),
            ),

            const SizedBox(height: 16),

            // Animasi
            Center(
              child: Lottie.asset(
                'assets/animations/cooking_pot.json',
                height: 150,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementasi simpan ke favorit
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
