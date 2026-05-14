import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/face_detection_service.dart';
import '../../../core/constants/app_strings.dart';

class SnoozeChallengeScreen extends StatefulWidget {
  const SnoozeChallengeScreen({super.key});

  @override
  State<SnoozeChallengeScreen> createState() => _SnoozeChallengeScreenState();
}

class _SnoozeChallengeScreenState extends State<SnoozeChallengeScreen> {
  CameraController? _cameraController;
  final FaceDetectionService _faceDetection = FaceDetectionService();
  FaceDetectionResult? _lastResult;
  bool _isCameraReady = false;
  bool _challengeCompleted = false;
  int _consecutiveDetections = 0;
  static const int _requiredDetections = 5;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() => _isCameraReady = true);
        _startDetection();
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void _startDetection() {
    _cameraController?.startImageStream((image) async {
      if (_challengeCompleted) return;

      final camera = _cameraController!.description;
      final result = await _faceDetection.processImage(image, camera);

      if (!mounted) return;

      setState(() => _lastResult = result);

      if (result.challengeCompleted) {
        _consecutiveDetections++;
        if (_consecutiveDetections >= _requiredDetections) {
          _onChallengeCompleted();
        }
      } else {
        _consecutiveDetections = 0;
      }
    });
  }

  void _onChallengeCompleted() {
    setState(() => _challengeCompleted = true);
    _cameraController?.stopImageStream();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop(true);
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              AppStrings.alarmSnoozeChallenge,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 600.ms),
            const SizedBox(height: 8),
            Text(
              AppStrings.alarmOpenEyes,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white60,
              ),
            ).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 32),
            Expanded(
              child: kIsWeb
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_off_rounded,
                              size: 64, color: Colors.white24),
                          const SizedBox(height: 16),
                          Text(
                            'មុខងារកាមេរ៉ាមិនអាចប្រើបានលើ Web',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('បញ្ឈប់រោទ៍'),
                          ),
                        ],
                      ),
                    )
                  : _isCameraReady
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: _challengeCompleted
                                    ? Colors.green
                                    : Colors.white24,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white24,
                            strokeWidth: 1.5,
                          ),
                        ),
            ),
            const SizedBox(height: 32),
            if (!kIsWeb) _buildStatusIndicators(theme),
            const SizedBox(height: 16),
            if (_challengeCompleted)
              Text(
                AppStrings.alarmStopped,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.green,
                ),
              ).animate().fadeIn().scale(),
            if (!kIsWeb && !_challengeCompleted && _lastResult != null)
              _buildProgressBar(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicators(ThemeData theme) {
    final eyesOpen = _lastResult?.eyesOpen ?? false;
    final isSmiling = _lastResult?.isSmiling ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatusIndicator(
            icon: Icons.visibility_rounded,
            label: 'ភ្នែក',
            isActive: eyesOpen,
          ),
          _StatusIndicator(
            icon: Icons.sentiment_satisfied_rounded,
            label: 'ញញឹម',
            isActive: isSmiling,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = _consecutiveDetections / _requiredDetections;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_consecutiveDetections * 100 / _requiredDetections).toInt()}%',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _StatusIndicator({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: isActive ? Colors.white : Colors.white24,
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white38,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 12,
            fontFamily: 'Battambang',
          ),
        ),
      ],
    );
  }
}
