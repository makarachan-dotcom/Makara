import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum FaceState {
  noFace,
  eyesClosed,
  eyesOpenNoSmile,
  eyesOpenSmiling,
}

class FaceDetectionResult {
  final FaceState state;
  final double? leftEyeOpenProbability;
  final double? rightEyeOpenProbability;
  final double? smilingProbability;

  const FaceDetectionResult({
    required this.state,
    this.leftEyeOpenProbability,
    this.rightEyeOpenProbability,
    this.smilingProbability,
  });

  bool get eyesOpen =>
      (leftEyeOpenProbability ?? 0) > 0.6 &&
      (rightEyeOpenProbability ?? 0) > 0.6;

  bool get isSmiling => (smilingProbability ?? 0) > 0.7;

  bool get challengeCompleted => eyesOpen && isSmiling;
}

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
      minFaceSize: 0.15,
    ),
  );

  bool _isProcessing = false;

  InputImageRotation _rotationFromSensorOrientation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<FaceDetectionResult> processImage(CameraImage image,
      CameraDescription camera) async {
    if (_isProcessing) {
      return const FaceDetectionResult(state: FaceState.noFace);
    }

    _isProcessing = true;

    try {
      final rotation = _rotationFromSensorOrientation(
          camera.sensorOrientation);

      final inputImage = InputImage.fromBytes(
        bytes: _concatenatePlanes(image.planes),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        return const FaceDetectionResult(state: FaceState.noFace);
      }

      final face = faces.first;
      final leftEyeOpen = face.leftEyeOpenProbability;
      final rightEyeOpen = face.rightEyeOpenProbability;
      final smiling = face.smilingProbability;

      final result = FaceDetectionResult(
        state: _determineState(leftEyeOpen, rightEyeOpen, smiling),
        leftEyeOpenProbability: leftEyeOpen,
        rightEyeOpenProbability: rightEyeOpen,
        smilingProbability: smiling,
      );

      return result;
    } catch (_) {
      return const FaceDetectionResult(state: FaceState.noFace);
    } finally {
      _isProcessing = false;
    }
  }

  FaceState _determineState(
      double? leftEye, double? rightEye, double? smile) {
    final eyesAreOpen = (leftEye ?? 0) > 0.6 && (rightEye ?? 0) > 0.6;
    final isSmiling = (smile ?? 0) > 0.7;

    if (eyesAreOpen && isSmiling) return FaceState.eyesOpenSmiling;
    if (eyesAreOpen) return FaceState.eyesOpenNoSmile;
    return FaceState.eyesClosed;
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final builder = BytesBuilder();
    for (final plane in planes) {
      builder.add(plane.bytes);
    }
    return builder.toBytes();
  }

  void dispose() {
    _faceDetector.close();
  }
}
