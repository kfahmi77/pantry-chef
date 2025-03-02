import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _favoriteBoxName = 'favoriteRecipes';
  static const String _historyBoxName = 'recipeHistory';

  // Inisialisasi Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_favoriteBoxName);
    await Hive.openBox<Map>(_historyBoxName);
  }

  // Simpan resep favorit
  static Future<void> saveFavoriteRecipe(Map<String, dynamic> recipe) async {
    final box = Hive.box<Map>(_favoriteBoxName);
    await box.put(recipe['nama_resep'], recipe);
  }

  // Hapus resep favorit
  static Future<void> removeFavoriteRecipe(String recipeName) async {
    final box = Hive.box<Map>(_favoriteBoxName);
    await box.delete(recipeName);
  }

  // Ambil semua resep favorit
  static List<Map<String, dynamic>> getFavoriteRecipes() {
    final box = Hive.box<Map>(_favoriteBoxName);
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // Simpan riwayat resep
  static Future<void> saveRecipeHistory(Map<String, dynamic> recipe) async {
    final box = Hive.box<Map>(_historyBoxName);
    await box.put(recipe['nama_resep'], recipe);
  }

  // Ambil semua riwayat resep
  static List<Map<String, dynamic>> getRecipeHistory() {
    final box = Hive.box<Map>(_historyBoxName);
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
