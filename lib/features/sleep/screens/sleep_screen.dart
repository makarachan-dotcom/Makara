import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';

class SoundItem {
  final String name;
  final IconData icon;
  final String assetPath;
  bool isPlaying;

  SoundItem({
    required this.name,
    required this.icon,
    required this.assetPath,
    this.isPlaying = false,
  });
}

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final List<SoundItem> _sounds = [
    SoundItem(
      name: AppStrings.sleepRain,
      icon: Icons.water_drop_rounded,
      assetPath: 'assets/sounds/rain.mp3',
    ),
    SoundItem(
      name: AppStrings.sleepOcean,
      icon: Icons.waves_rounded,
      assetPath: 'assets/sounds/ocean.mp3',
    ),
    SoundItem(
      name: AppStrings.sleepForest,
      icon: Icons.forest_rounded,
      assetPath: 'assets/sounds/forest.mp3',
    ),
    SoundItem(
      name: AppStrings.sleepWhiteNoise,
      icon: Icons.graphic_eq_rounded,
      assetPath: 'assets/sounds/white_noise.mp3',
    ),
    SoundItem(
      name: AppStrings.sleepFireplace,
      icon: Icons.local_fire_department_rounded,
      assetPath: 'assets/sounds/fireplace.mp3',
    ),
    SoundItem(
      name: AppStrings.sleepNightAmbient,
      icon: Icons.nightlight_rounded,
      assetPath: 'assets/sounds/night.mp3',
    ),
  ];

  int _sleepTimerMinutes = 30;
  bool _timerActive = false;
  Timer? _sleepTimer;
  int _remainingSeconds = 0;

  void _toggleSound(int index) {
    setState(() {
      _sounds[index].isPlaying = !_sounds[index].isPlaying;
    });
  }

  void _startSleepTimer() {
    setState(() {
      _timerActive = true;
      _remainingSeconds = _sleepTimerMinutes * 60;
    });

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopAllSounds();
        timer.cancel();
        setState(() => _timerActive = false);
      }
    });
  }

  void _stopAllSounds() {
    setState(() {
      for (final sound in _sounds) {
        sound.isPlaying = false;
      }
    });
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    setState(() {
      _timerActive = false;
      _remainingSeconds = 0;
    });
  }

  String _formatTimer(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.sleepTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.sleepSounds,
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _sounds.length,
              itemBuilder: (context, index) {
                final sound = _sounds[index];
                return GestureDetector(
                  onTap: () => _toggleSound(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: sound.isPlaying
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
                          : theme.cardTheme.color,
                      border: Border.all(
                        color: sound.isPlaying
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          sound.icon,
                          size: 32,
                          color: sound.isPlaying
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sound.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: sound.isPlaying
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: sound.isPlaying
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: (index * 80).ms).fadeIn().scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                    );
              },
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.sleepTimer,
                          style: theme.textTheme.titleMedium),
                      if (_timerActive)
                        Text(
                          _formatTimer(_remainingSeconds),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!_timerActive) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [15, 30, 45, 60, 90].map((m) {
                        final isSelected = m == _sleepTimerMinutes;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _sleepTimerMinutes = m),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isSelected
                                  ? theme.colorScheme.onSurface
                                      .withValues(alpha: 0.1)
                                  : Colors.transparent,
                            ),
                            child: Text(
                              '$m',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _startSleepTimer,
                        child: Text(AppStrings.timerStart),
                      ),
                    ),
                  ] else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _cancelSleepTimer,
                        child: Text(AppStrings.cancel),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
