import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey = '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';
  final String apiUrl = 'http://localhost:1234/v1/chat/completions';

  Future<Map<String, dynamic>> generateRecipe(List<String> ingredients) async {
    // Create a more structured prompt that enforces JSON output
    final String prompt = """
    Buat resep menggunakan bahan berikut: ${ingredients.join(', ')}

    Berikan respon dalam format JSON yang valid seperti contoh berikut:
    {
      "nama_resep": "Nama Resep Disini",
      "bahan": ["Bahan 1", "Bahan 2", "Bahan 3"],
      "langkah": ["Langkah 1", "Langkah 2", "Langkah 3"],
      "tips_penyajian": "Tips penyajian disini",
      "wtfLevel": 3
    }

    PENTING: Pastikan output hanya berisi JSON yang valid, tanpa teks tambahan di awal atau akhir.
    """;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.2-3b-instruct',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Anda adalah chef AI yang akan memberikan resep dalam format JSON yang valid. Jangan tambahkan teks apapun selain JSON yang diminta.'
            },
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 500,
          'temperature': 0.1,
          'stream': false
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'];

        // Clean up the response to ensure it's valid JSON
        content = content.trim();

        // Remove any markdown code block indicators if present
        if (content.startsWith('```json')) {
          content = content.substring(7);
        }
        if (content.startsWith('```')) {
          content = content.substring(3);
        }
        if (content.endsWith('```')) {
          content = content.substring(0, content.length - 3);
        }

        content = content.trim();

        try {
          // Attempt to parse the JSON
          final Map<String, dynamic> recipe = jsonDecode(content);

          // Validate required fields
          if (!recipe.containsKey('nama_resep') ||
              !recipe.containsKey('bahan') ||
              !recipe.containsKey('langkah') ||
              !recipe.containsKey('tips_penyajian') ||
              !recipe.containsKey('wtfLevel')) {
            throw FormatException('Response is missing required fields');
          }

          return recipe;
        } catch (e) {
          print('JSON Parse Error. Response content: $content');
          throw FormatException('Invalid JSON format in AI response');
        }
      } else {
        throw Exception('Failed to load recipe: ${response.statusCode}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw FormatException('Error parsing AI response: ${e.message}');
      }
      throw Exception('Error generating recipe: $e');
    }
  }

  // Helper method to create a default recipe in case of errors
  Map<String, dynamic> createDefaultRecipe(List<String> ingredients) {
    return {
      "nama_resep": "Resep Darurat",
      "bahan": ingredients,
      "langkah": ["Maaf, terjadi kesalahan dalam pembuatan resep."],
      "tips_penyajian": "Silakan coba lagi nanti.",
      "wtfLevel": 1
    };
  }
}
