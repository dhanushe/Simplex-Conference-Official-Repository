import 'package:flutter/material.dart';
import 'package:simplex_conference_redo_repo/app/login/login_screen.dart';
import '../../api/logic/API.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    API.setDark();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/welcomebg.png',
            ).image,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 60),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Get Started',
                      style: TextStyle(
                        fontFamily: 'ClashGrotesk',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const LoginScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin =
                                    Offset(1.0, 0.0); // Slide in from the right
                                const end = Offset.zero;
                                final tween = Tween(begin: begin, end: end);
                                final offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                            // This condition removes all previous routes
                          );
                        },
                        child: Container(
                          width: 84,
                          height: 84,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD7E4F8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF226ADD),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
