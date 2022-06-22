import 'package:flutter/material.dart';
import 'package:ParkShield/globals.dart';
import 'package:ParkShield/services/Firebase/FireAuth/fireauth.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
    value: 1,
  )
    ..forward(from: 0)
    ..addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          if (checkLoggedIn()) {
            Navigator.pushReplacementNamed(context, '/profile_page');
          } else {
            Navigator.pushReplacementNamed(context, '/login_register_page');
          }
        }
      },
    );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(APP_ICON), context);
    return Scaffold(
      body: ScaleTransition(
        scale: _animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.width / 3,
                child: Image.asset(
                  APP_ICON,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
