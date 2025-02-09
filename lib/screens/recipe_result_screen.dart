import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/widgets/confetti_screen.dart';

class RecipeResultScreen extends StatelessWidget {
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
      body: Stack(
        children: [
          // Konten utama
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Resep
                Text(
                  recipeName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // WTF Level
                if (wtfLevel > 3)
                  Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 500),
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: Text('WTF Level: $wtfLevel'),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Bahan
                Text(
                  'Bahan:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ...ingredients.map((ingredient) {
                  return CheckboxListTile(
                    title: Text(ingredient),
                    value: false,
                    onChanged: (value) {
                      // Implementasi checklist bahan
                    },
                  );
                }).toList(),
                const SizedBox(height: 16),

                // Langkah-Langkah
                Text(
                  'Langkah-Langkah:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ...steps.asMap().entries.map((entry) {
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
                        Text(tips),
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
                    child: const Text(
                      'Re-generate Resep',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Animasi Panci
                Center(
                  child: Lottie.asset(
                    'assets/animations/cooking_pot.json',
                    height: 150,
                  ),
                ),
              ],
            ),
          ),

          // Animasi Api (jika WTF Level > 3)
          if (wtfLevel > 3)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Lottie.asset(
                'assets/animations/boiling_pot.json',
                height: 200,
                repeat: true,
              ),
            ),
          ConfettiAnimation(),
        ],
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
