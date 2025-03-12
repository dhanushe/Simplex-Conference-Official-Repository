import 'package:flutter/material.dart';

import 'login_page.dart';
import '../../app/login/login_screen.dart';

class AdminWelcomePage extends StatefulWidget {
  const AdminWelcomePage({super.key});

  @override
  State<AdminWelcomePage> createState() => _AdminWelcomePageState();
}

class _AdminWelcomePageState extends State<AdminWelcomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
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
      backgroundColor: const Color(0xFFFBFBFB),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/darklogoname.png',
                        width: 325,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 325,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBFBFB),
                  ),
                  child: Text(
                    'Simplifying Conference Logistics',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontFamily: 'DM Sans',
                      
                      color: Colors.black,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 200),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) =>
                          false, // This condition removes all previous routes
                    );
                  },
                  child: Container(
                    width: 325,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFFA0A0A0),
                        width: 2,
                      ),
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        'Continue to User Portal',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'DM Sans',
                          
                          color: const Color(0xFFA0A0A0),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      ); // This condition removes all previous routes
                    },
                    child: Container(
                      width: 325,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF490FFF),
                          width: 2,
                        ),
                      ),
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Text(
                          'Continue to Admin Portal',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'DM Sans',
                            
                            color: const Color(0xFF490FFF),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
