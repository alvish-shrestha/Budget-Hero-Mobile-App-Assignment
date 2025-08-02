// In: lib/core/utils/shake_detector.dart

import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final void Function() onPhoneShake;

  final double shakeThreshold;

  final int shakeWindowMS;

  final int requiredShakes;

  final int minTimeBetweenShakesMS;

  StreamSubscription? _subscription;

  int _shakeCount = 0;
  DateTime? _firstShakeTime;

  DateTime? _lastShakeTimestamp;

  ShakeDetector({
    required this.onPhoneShake,
    this.shakeThreshold = 18.0,
    this.shakeWindowMS = 3000,
    this.requiredShakes = 3,
    this.minTimeBetweenShakesMS = 500,
  });

  void startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > shakeThreshold) {
        final now = DateTime.now();

        if (_lastShakeTimestamp != null &&
            now.difference(_lastShakeTimestamp!) <
                Duration(milliseconds: minTimeBetweenShakesMS)) {
          return;
        }

        _lastShakeTimestamp = now;

        if (_firstShakeTime == null ||
            now.difference(_firstShakeTime!) >
                Duration(milliseconds: shakeWindowMS)) {
          _firstShakeTime = now;
          _shakeCount = 1;
          return;
        }

        _shakeCount++;

        if (_shakeCount >= requiredShakes) {
          onPhoneShake();
          _resetShake();
        }
      }
    });
  }

  void _resetShake() {
    _firstShakeTime = null;
    _lastShakeTimestamp = null;
    _shakeCount = 0;
  }

  void stopListening() {
    _subscription?.cancel();
    _resetShake();
  }
}
