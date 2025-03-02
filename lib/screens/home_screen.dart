import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/service_ai.dart';
import '../services/servicee_recipe.dart';
import '../widgets/ingredient_input.dart';
import 'history_screen.dart';
import 'loading_screen.dart';
import 'recipe_result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AIService _aiService = AIService(); // Gunakan AIService
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

  Future<void> _generateRecipe() async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan minimal 1 bahan!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingScreen(),
      ),
    );

    try {
      final recipe = await _aiService.generateRecipe(_ingredients);
      await HiveService.saveRecipeHistory(recipe);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeResultScreen(
            recipeName: recipe['nama_resep'],
            ingredients: List<String>.from(recipe['bahan']),
            steps: List<String>.from(recipe['langkah']),
            tips: recipe['tips_penyajian'],
            wtfLevel: recipe['wtfLevel'],
          ),
        ),
      );
      print(recipe);
    } catch (e) {
      Navigator.pop(context); // Kembali ke halaman utama
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 32,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'CookMaster',
              style: TextStyle(
                color: Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, color: Colors.black87),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section dengan Gradient Background
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange[50]!,
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Chef! 👋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mau masak apa hari ini?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            // Input Bahan dengan Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bahan-bahan yang tersedia',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      IngredientInput(
                        ingredients: _ingredients,
                        onAdd: _addIngredient,
                        onRemove: _removeIngredient,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Animasi dengan Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                color: Colors.orange[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/cooking_pot.json',
                    height: 180,
                  ),
                ),
              ),
            ),

            // Tombol Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _generateRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restaurant_menu, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text(
                          'Generate Resep',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryScreen()));
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Lihat Riwayat Resep'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
