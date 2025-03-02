import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/servicee_recipe.dart';
import 'recipe_result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Map<String, dynamic>> recipes;
  List<Map<String, dynamic>> filteredRecipes = [];
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      recipes = HiveService.getRecipeHistory();
      filteredRecipes = recipes;
    });
  }

  Future<void> _deleteRecipe(String recipeName, int index) async {
    final deletedRecipe = recipes[index];
    final deletedFromFiltered = filteredRecipes[index];

    setState(() {
      recipes.remove(deletedRecipe);
      filteredRecipes = recipes.where((recipe) {
        if (_searchController.text.isEmpty) return true;
        final nameMatch = recipe['nama_resep']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final ingredientsMatch = recipe['bahan'].any((ingredient) => ingredient
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()));
        return nameMatch || ingredientsMatch;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedRecipe['nama_resep']} dihapus dari riwayat'),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () async {
            setState(() {
              recipes.insert(index, deletedRecipe);
              _filterRecipes(_searchController.text);
            });
            await HiveService.saveRecipeHistory(deletedRecipe);
          },
        ),
      ),
    );

    await HiveService.removeFavoriteRecipe(recipeName);
  }

  void _filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecipes = recipes;
      } else {
        filteredRecipes = recipes.where((recipe) {
          final nameMatch = recipe['nama_resep']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
          final ingredientsMatch = recipe['bahan'].any((ingredient) =>
              ingredient
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()));
          return nameMatch || ingredientsMatch;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: !isSearching
            ? const Text(
                'Riwayat Resep',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            : TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Cari resep atau bahan...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                onChanged: _filterRecipes,
              ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  _searchController.clear();
                  filteredRecipes = recipes;
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: filteredRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/empty_history.png',
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSearching && _searchController.text.isNotEmpty
                        ? 'Tidak ada resep yang cocok'
                        : 'Belum ada riwayat resep',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSearching && _searchController.text.isNotEmpty
                        ? 'Coba kata kunci lain'
                        : 'Mulai jelajahi resep-resep baru!',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return Dismissible(
                  key: Key(recipe['nama_resep']),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Hapus Resep'),
                          content: Text(
                              'Apakah Anda yakin ingin menghapus resep "${recipe['nama_resep']}" dari riwayat?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    _deleteRecipe(
                        recipe['nama_resep'], recipes.indexOf(recipe));
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
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
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_menu,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe['nama_resep'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          _buildDifficultyIndicator(
                                              recipe['wtfLevel']),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${recipe['bahan'].length} Bahan',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Bahan: ${recipe['bahan'].join(', ')}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

Widget _buildDifficultyIndicator(int level) {
  Color color;
  String text;

  switch (level) {
    case 1:
      color = Colors.green;
      text = 'Mudah';
      break;
    case 2:
      color = Colors.orange;
      text = 'Sedang';
      break;
    default:
      color = Colors.red;
      text = 'Sulit';
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
