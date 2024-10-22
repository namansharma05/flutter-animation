import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();

  @override
  Path getClip(Size size) {
    var path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    path.addOval(rect);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _circleController;
  late Animation<double> _circleAnimation;

  late AnimationController _checkOffsetController;
  late Animation<Offset> _checkOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _circleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 550), () {
            _circleController.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(milliseconds: 550), () {
            _circleController.forward();
          });
        }
      });
    ;
    _circleAnimation =
        Tween<double>(begin: 1, end: 7).animate(_circleController);

    _checkOffsetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 550), () {
            _checkOffsetController.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(milliseconds: 550), () {
            _checkOffsetController.forward();
          });
        }
      });
    ;
    _checkOffsetAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 10))
            .animate(_checkOffsetController);

    _circleController.forward();
    // _checkController.repeat(
    //   reverse: true,
    // );
    _checkOffsetController.forward();
  }

  @override
  void dispose() {
    _circleController.dispose();
    _checkOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "Thank you\nfor your order!",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Your order is successful!\nSee you again!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.black38,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  child: AnimatedBuilder(
                    animation: Listenable.merge(
                        [_circleController, _checkOffsetController]),
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..scale(_circleAnimation.value),
                        child: ClipPath(
                          clipper: const CircleClipper(),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration:
                                const BoxDecoration(color: Colors.green),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..translate(_checkOffsetAnimation.value.dx,
                                    _checkOffsetAnimation.value.dy),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
