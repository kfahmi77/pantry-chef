import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({super.key});

  @override
  _ConfettiAnimationState createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  void _playConfetti() {
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tombol untuk trigger confetti (contoh)
        Center(
          child: ElevatedButton(
            onPressed: _playConfetti,
            child: const Text('Simpan ke Favorit'),
          ),
        ),

        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.0, // Arah confetti (atas ke bawah)
            emissionFrequency: 0.05, // Frekuensi confetti
            numberOfParticles: 20, // Jumlah partikel
            gravity: 0.1, // Gravitasi
          ),
        ),
      ],
    );
  }
}
