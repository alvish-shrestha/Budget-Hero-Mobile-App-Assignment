import 'package:budgethero/view/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _radius = 0.0;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _radius = MediaQuery.of(context).size.longestSide * 1.2;
        _opacity = 1.0;
      });
    });

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: _radius),
            duration: Duration(seconds: 2),
            builder: (context, value, child) {
              return CustomPaint(
                painter: CirclePainter(radius: value),
                child: Container(),
              );
            },
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child:
                    isPortrait
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Image.asset('assets/logo/logo.png', height: 80),
                            SizedBox(width: 16),
                            Text(
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
                            SizedBox(height: 16),
                            Text(
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

    final paint =
        Paint()
          ..color = Color(0xFFF55345)
          ..style = PaintingStyle.fill
          ..strokeWidth = 0.0;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => oldDelegate.radius != radius;
}
