import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:doaniot/core/theme/app_colors.dart';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen>
    with TickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  final ValueNotifier<double> _levelNotifier = ValueNotifier(0.0);

  // Animation controller for the continuous wave movement
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    // Auto-repeat animation for the wave phase shift
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _initSpeech();
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        // print('onStatus: $status');
        if (status == 'notListening' || status == 'done') {
          if (mounted) {
            setState(() => _isListening = false);
            _levelNotifier.value = 0.0; // Reset wave
          }
        } else if (status == 'listening') {
          if (mounted) {
            setState(() => _isListening = true);
          }
        }
      },
      onError: (errorNotification) {
        // print('onError: $errorNotification');
        if (mounted) {
          setState(() => _isListening = false);
          _levelNotifier.value = 0.0;
        }
      },
    );

    if (available) {
      // Small delay to ensure UI is ready
      Timer(const Duration(milliseconds: 100), () {
        _startListening();
      });
    } else {
      if (mounted) {
        setState(() {
          _text = "Microphone access denied or not available";
        });
      }
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (val) {
        setState(() {
          _text = val.recognizedWords;
        });
      },
      onSoundLevelChange: (level) {
        // Level typically ranges from -10 to 10 or similar depending on platform.
        // Normalize: if < 0, mostly silence. Max around 10.
        // We can do a slight smoothing if needed, but direct mapping is responsive.
        _levelNotifier.value = level;
      },
      listenFor: const Duration(seconds: 30),
      cancelOnError: true,
      partialResults: true,
      pauseFor: const Duration(seconds: 3),
      listenMode: stt.ListenMode.confirmation,
    );
    setState(() => _isListening = true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Close Button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.close, size: 30, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Text Prompts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Text(
                    _isListening
                        ? "We are listening..."
                        : "Tap the orb to listen",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "What do you want to do?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Recognized Text or Placeholder
                  Text(
                    _text.isEmpty
                        ? "“Turn on all the lights in the entire room”"
                        : "“$_text”",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: _text.isEmpty ? Colors.black87 : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Wave Animation
            SizedBox(
              height: 180, // Increased height for larger waves
              width: double.infinity,
              child: AnimatedBuilder(
                animation: Listenable.merge([_waveController, _levelNotifier]),
                builder: (context, child) {
                  return CustomPaint(
                    painter: SiriWavePainter(
                      animationValue: _waveController.value,
                      soundLevel: _levelNotifier.value, // User smoothed level
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // Siri Orb / Mic Button
            GestureDetector(
              onTap: () {
                if (!_isListening) {
                  _startListening();
                } else {
                  _speech.stop();
                  setState(() => _isListening = false);
                }
              },
              child: _SiriOrb(isListening: _isListening),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class _SiriOrb extends StatefulWidget {
  final bool isListening;

  const _SiriOrb({required this.isListening});

  @override
  State<_SiriOrb> createState() => _SiriOrbState();
}

class _SiriOrbState extends State<_SiriOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, // Slightly larger
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow (Breathing)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width:
                    80 +
                    (widget.isListening
                        ? 10 * math.sin(_controller.value * 2 * math.pi)
                        : 0),
                height:
                    80 +
                    (widget.isListening
                        ? 10 * math.sin(_controller.value * 2 * math.pi)
                        : 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5E5CE6).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: const Color(0xFF0A84FF).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              );
            },
          ),

          // Core Sphere Gradient
          RotationTransition(
            turns: _controller,
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0xFF32D74B), // Green
                    Color(0xFF5E5CE6), // Indigo
                    Color(0xFFFF375F), // Pink Red
                    Color(0xFF0A84FF), // Blue
                    Color(0xFF32D74B), // Loop back to Green
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Inner Overlay to creating "glassy" orb look
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          // Mic Icon (Optional, centered)
          if (!widget.isListening)
            const Icon(Icons.mic, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}

class SiriWavePainter extends CustomPainter {
  final double animationValue;
  final double soundLevel;

  SiriWavePainter({required this.animationValue, required this.soundLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height / 2;
    // Normalize sound level.
    final double normalizedSound = math.max(0, soundLevel);
    // Base amplitude plus dynamic reaction
    final double amplitude = 30 + (normalizedSound * 15);

    // Draw layers from back to front
    // 1. Purple & Orange (Background)
    _drawSymmetricWave(
      canvas: canvas,
      size: size,
      centerY: centerY,
      waveHeight: amplitude * 0.6,
      frequency: 1.8,
      phaseShift: animationValue + 2.0,
      color: const Color(0xFFAC5DD9).withOpacity(0.5), // Purple
    );
    _drawSymmetricWave(
      canvas: canvas,
      size: size,
      centerY: centerY,
      waveHeight: amplitude * 0.5,
      frequency: 2.1,
      phaseShift: animationValue + 4.0,
      color: const Color(0xFFFF9F47).withOpacity(0.6), // Orange
    );

    // 2. Green
    _drawSymmetricWave(
      canvas: canvas,
      size: size,
      centerY: centerY,
      waveHeight: amplitude * 0.8,
      frequency: 1.4,
      phaseShift: animationValue + 1.2,
      color: const Color(0xFF8CD867).withOpacity(0.7), // Green
    );

    // 3. Blue (Front/Center)
    _drawSymmetricWave(
      canvas: canvas,
      size: size,
      centerY: centerY,
      waveHeight: amplitude,
      frequency: 1.0,
      phaseShift: animationValue,
      color: const Color(0xFF445EF2).withOpacity(0.9), // Blue
    );
  }

  void _drawSymmetricWave({
    required Canvas canvas,
    required Size size,
    required double centerY,
    required double waveHeight,
    required double frequency,
    required double phaseShift,
    required Color color,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill; // Changed to fill

    final path = Path();
    final double width = size.width;

    // Effective frequency jitters slightly with sound
    final double effectiveFreq = frequency + (soundLevel * 0.1);

    path.moveTo(0, centerY);

    // Top half
    for (double x = 0; x <= width; x += 1) {
      // Step optimization
      final double nx = (x / width) * 2 - 1; // -1 to 1
      // Envelope: Bell curve to taper edges to 0
      final double envelope = math.pow(1 - (nx * nx), 2).toDouble();

      final double angle =
          (x / width) * 2 * math.pi * effectiveFreq +
          (phaseShift * 2 * math.pi);

      // Calculate offset from center
      final double offset = math.sin(angle) * waveHeight * envelope;

      path.lineTo(x, centerY - offset.abs()); // Go UP
    }

    // Bottom half (Mirror)
    for (double x = width; x >= 0; x -= 1) {
      final double nx = (x / width) * 2 - 1;
      final double envelope = math.pow(1 - (nx * nx), 2).toDouble();
      final double angle =
          (x / width) * 2 * math.pi * effectiveFreq +
          (phaseShift * 2 * math.pi);
      final double offset = math.sin(angle) * waveHeight * envelope;

      path.lineTo(x, centerY + offset.abs()); // Go DOWN
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SiriWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.soundLevel != soundLevel;
  }
}
