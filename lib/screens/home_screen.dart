import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/service_ai.dart';
import '../widgets/ingredient_input.dart';
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
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.jpg',
          height: 40,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Navigasi ke halaman profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Text(
                'Halo, Chef! Apa yang mau kamu masak hari ini?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Input Bahan
              IngredientInput(
                ingredients: _ingredients,
                onAdd: _addIngredient,
                onRemove: _removeIngredient,
              ),

              const SizedBox(height: 24),

              // Animasi Panci
              Center(
                child: Lottie.asset(
                  'assets/animations/cooking_pot.json',
                  height: 200,
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Generate Resep
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generateRecipe,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Generate Resep',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Riwayat
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman riwayat
                },
                child: const Text('Lihat Riwayat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
