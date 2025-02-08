import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'recipe_result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> recipes = [
    {
      'name': 'Nasi Goreng Tempe Surprise',
      'ingredients': [
        'Nasi sisa 1 piring',
        'Tempe 200g',
        'Telur 2 butir',
        'Kecap manis'
      ],
      'steps': [
        'Potong tempe kecil-kecil.',
        'Panaskan wajan, tumis tempe hingga kecoklatan.',
        'Masukkan nasi dan aduk rata.',
        'Tambahkan kecap manis dan telur, aduk hingga matang.',
        'Sajikan panas.',
      ],
      'tips': 'Tambahkan irisan cabai rawit untuk rasa pedas.',
      'wtfLevel': 2,
    },
    {
      'name': 'Pancake Pisang Kecap',
      'ingredients': [
        'Pisang 2 buah',
        'Tepung 100g',
        'Kecap manis',
        'Telur 1 butir'
      ],
      'steps': [
        'Hancurkan pisang dalam mangkuk.',
        'Campurkan tepung dan telur, aduk hingga rata.',
        'Tambahkan kecap manis secukupnya.',
        'Panaskan wajan, tuang adonan dan masak hingga matang.',
        'Sajikan dengan topping sesuai selera.',
      ],
      'tips': 'Tambahkan madu untuk rasa manis alami.',
      'wtfLevel': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Resep'),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/empty_box.json',
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada resep yang di-generate.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Dismissible(
                  key: Key(recipe['name']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Hapus resep dari daftar
                    setState(() {
                      recipes.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('${recipe['name']} dihapus dari riwayat')),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(recipe['name']),
                      subtitle: Text(
                        'Bahan: ${recipe['ingredients'].join(', ')}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            recipes.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${recipe['name']} dihapus dari riwayat')),
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeResultScreen(
                              recipeName: recipe['name'],
                              ingredients: recipe['ingredients'],
                              steps: recipe['steps'],
                              tips: recipe['tips'],
                              wtfLevel: recipe['wtfLevel'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
