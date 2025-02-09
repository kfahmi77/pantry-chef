import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<String> _cookingTips = [
    'Jangan lupa panaskan wajan sebelum menggoreng!',
    'Tambahkan garam secukupnya untuk meningkatkan rasa.',
    'Gunakan api kecil saat memasak telur agar tidak gosong.',
    'Aduk terus saus agar tidak menggumpal.',
    'Tambahkan sedikit gula untuk menyeimbangkan rasa asam.',
  ];

  int _currentTipIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTipsRotation();
  }

  void _startTipsRotation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _cookingTips.length;
        });
        _startTipsRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi Panci Mendidih
            Lottie.asset(
              'assets/animations/boiling_pot.json',
              height: 150,
            ),

            const SizedBox(height: 24),

            // Progress Bar
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),

            const SizedBox(height: 16),

            // Teks Loading
            const Text(
              'Sedang Memasak Resep Terbaik...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Tips Memasak
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _cookingTips[_currentTipIndex],
                key: ValueKey<int>(_currentTipIndex),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
