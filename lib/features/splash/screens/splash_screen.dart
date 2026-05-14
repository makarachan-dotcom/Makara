import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4500), widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cinematic particle effect background
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.05),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 48,
                color: Colors.white,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 1200.ms,
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 48),
            Text(
              'Made with',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
                letterSpacing: 4,
                fontWeight: FontWeight.w300,
              ),
            )
                .animate(delay: 800.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 12),
            const Text(
              'UNREAL ENGINE 5',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 6,
              ),
            )
                .animate(delay: 1200.ms)
                .fadeIn(duration: 800.ms)
                .shimmer(
                  duration: 2000.ms,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
            const SizedBox(height: 16),
            Container(
              width: 60,
              height: 1,
              color: Colors.white24,
            ).animate(delay: 1800.ms).fadeIn(duration: 600.ms).scaleX(
                  begin: 0,
                  end: 1,
                  duration: 800.ms,
                  curve: Curves.easeOut,
                ),
            const SizedBox(height: 16),
            Text(
              'by Makara',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 3,
                fontWeight: FontWeight.w300,
              ),
            )
                .animate(delay: 2200.ms)
                .fadeIn(duration: 800.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 80),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(
                  Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ).animate(delay: 2800.ms).fadeIn(duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
