import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/ingredient_input.dart';
import 'history_screen.dart';
import 'recipe_result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
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
              const IngredientInput(),

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipeResultScreen(
                          recipeName: 'Nasi Goreng Tempe Surprise',
                          ingredients: [
                            'Nasi sisa 1 piring',
                            'Tempe 200g',
                            'Telur 2 butir',
                            'Kecap manis'
                          ],
                          steps: [
                            'Potong tempe kecil-kecil.',
                            'Panaskan wajan, tumis tempe hingga kecoklatan.',
                            'Masukkan nasi dan aduk rata.',
                            'Tambahkan kecap manis dan telur, aduk hingga matang.',
                            'Sajikan panas.',
                          ],
                          tips:
                              'Tambahkan irisan cabai rawit untuk rasa pedas.',
                          wtfLevel: 5,
                        ),
                      ),
                    );
                  },
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
                // Di dalam HomeScreen, update onPressed tombol "Lihat Riwayat":
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(),
                    ),
                  );
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
