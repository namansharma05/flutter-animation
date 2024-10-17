import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

const widthAndHeight = 100.0;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();
    _xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 40));

    _animation = Tween<double>(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: widthAndHeight,
              width: double.infinity,
            ),
            AnimatedBuilder(
              animation:
                  Listenable.merge([_xController, _yController, _zController]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(_animation.evaluate(_yController))
                    ..rotateX(_animation.evaluate(_xController))
                    ..rotateZ(
                      _animation.evaluate(_zController),
                    ),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.green,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(Vector3(0, 0, -widthAndHeight)),
                        child: Container(
                          color: Colors.purple,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        child: Container(
                          color: Colors.red,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi / 2),
                        child: Container(
                          color: Colors.brown,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        child: Container(
                          color: Colors.blue,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi / 2),
                        child: Container(
                          color: Colors.yellow,
                          width: widthAndHeight,
                          height: widthAndHeight,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
