import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/widgets/confetti_screen.dart';

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
  // Track checked ingredients
  final Map<String, bool> _checkedIngredients = {};

  @override
  void initState() {
    super.initState();
    // Initialize all ingredients as unchecked
    for (var ingredient in widget.ingredients) {
      _checkedIngredients[ingredient] = false;
    }
  }

  void _toggleIngredient(String ingredient) {
    setState(() {
      _checkedIngredients[ingredient] =
          !(_checkedIngredients[ingredient] ?? false);
    });
  }

  void _shareRecipe() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur share akan segera hadir!')),
    );
  }

  void _regenerateRecipe() {
    // TODO: Implement regenerate functionality
    Navigator.pop(context);
  }

  void _addToFavorites() {
    // TODO: Implement favorites functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resep ditambahkan ke favorit!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Resep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareRecipe,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Title with Animation
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            widget.wtfLevel > 3 ? Colors.orange : Colors.black,
                      ),
                  child: Text(widget.recipeName),
                ),
                const SizedBox(height: 8),

                // WTF Level Indicator
                if (widget.wtfLevel > 3)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'WTF Level: ${widget.wtfLevel}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Ingredients Section
                Text(
                  'Bahan:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Card(
                  child: Column(
                    children: widget.ingredients.map((ingredient) {
                      return CheckboxListTile(
                        title: Text(
                          ingredient,
                          style: TextStyle(
                            decoration: _checkedIngredients[ingredient] == true
                                ? TextDecoration.lineThrough
                                : null,
                            color: _checkedIngredients[ingredient] == true
                                ? Colors.grey
                                : null,
                          ),
                        ),
                        value: _checkedIngredients[ingredient],
                        onChanged: (_) => _toggleIngredient(ingredient),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Steps Section
                Text(
                  'Langkah-Langkah:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Card(
                  child: Column(
                    children: widget.steps.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final step = entry.value;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '$index',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(step),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Tips Section
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Tips Penyajian:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(widget.tips),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Regenerate Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _regenerateRecipe,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Re-generate Resep',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Cooking Animation
                Center(
                  child: Lottie.asset(
                    'assets/animations/cooking_pot.json',
                    height: 150,
                  ),
                ),
              ],
            ),
          ),

          // Boiling Animation for high WTF levels
          if (widget.wtfLevel > 3)
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

          // Confetti Animation
          const ConfettiAnimation(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToFavorites,
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
