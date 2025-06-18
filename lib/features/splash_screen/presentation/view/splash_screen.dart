import 'package:budgethero/features/splash_screen/presentation/view_model/splash_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenRadius = MediaQuery.of(context).size.longestSide * 1.2;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Call the ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashScreenViewModel>().init(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Expanding animated circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: screenRadius),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return CustomPaint(
                painter: CirclePainter(radius: value),
                child: Container(),
              );
            },
          ),

          // Center content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: isPortrait
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Image.asset('assets/logo/logo.png', height: 80),
                        const SizedBox(width: 16),
                        const Text(
                          'BUDGET\nHERO',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: "Jaro",
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/logo/logo.png', height: 80),
                        const SizedBox(height: 16),
                        const Text(
                          'BUDGET\nHERO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Jaro",
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFFF55345)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) =>
      oldDelegate.radius != radius;
}
