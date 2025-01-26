// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplex_conference_redo_repo/admin/home/home_page.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _showPassword;
  late bool _showPassword2;
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;
  TextEditingController? _usernameController2;
  TextEditingController? _passwordController2;
  late bool _isSigningIn;

  @override
  void initState() {
    super.initState();
    _showPassword = false;
    _showPassword2 = false;
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController2 = TextEditingController();
    _passwordController2 = TextEditingController();
    _isSigningIn = false;
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    _passwordController2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(227, 232, 237, 1),
      body:
          // the body is a row consisting of a container and a column. The container has the gradient and the column has the log-in fields
          Row(children: [
        Container(
          decoration: const BoxDecoration(
              // the container's background is a a gradient ripped from the web
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(150, 0, 0, 0), BlendMode.darken),
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://t3.ftcdn.net/jpg/02/98/47/38/360_F_298473896_Vsz21xTwMtroEeeGgU8pL2vwt3N65pfR.jpg"),
                  alignment: Alignment(-0.5, 0.5))),
          // the container takes up about 3/8 of the screen width wise
          width: MediaQuery.of(context).size.width / 8 * 3,
          child: const Column(
            // text on top of the gradient
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Streamlining\nConference\nLogistics",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 55,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),
        // column containing the sign-in fields
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(65.0, 50, 0, 0),
              // row with the sielfiy admin and link
              child: Row(
                children: [
                  Image.asset('assets/images/appicondisplay.png', height: 75),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text("Sielify",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
                  const Text(
                    " Admin",
                    style: TextStyle(fontSize: 50),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(65, 100, 0, 0),
              child: Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 90, color: Color.fromRGBO(101, 88, 245, 1)),
              ),
            ),
            const SizedBox(height: 20),
            // Username Field
            Padding(
              padding: const EdgeInsets.fromLTRB(65.0, 0, 0, 0),
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Conference Name',
                      hintText: 'e.g. \'WA FBLA SBLC\'',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      hoverColor: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Password Field
            Padding(
              padding: const EdgeInsets.fromLTRB(65.0, 0, 0, 0),
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  obscureText: !_showPassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Conference Password',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Password Field
            Padding(
              padding: const EdgeInsets.fromLTRB(65.0, 0, 0, 0),
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  controller: _usernameController2,
                  decoration: const InputDecoration(
                      labelText: 'Sielify Account Email',
                      hintText:
                          'e.g. \'mahiremran7@gmail.com\' (You must have an existing Sielify account with an email)',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      hoverColor: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Password Field
            Padding(
              padding: const EdgeInsets.fromLTRB(65.0, 0, 0, 0),
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  obscureText: !_showPassword2,
                  controller: _passwordController2,
                  decoration: InputDecoration(
                    labelText: 'Sielify Account Password',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() => _showPassword2 = !_showPassword2);
                        },
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            // Forgat Password Button
            Padding(
              padding: const EdgeInsets.fromLTRB(65 * 10, 10, 5, 5),
              child: TextButton(
                  child: const Text('Forgot Password?'),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          alignment: Alignment.bottomRight,
                          title: const Text('Don\'t Fret 😉'),
                          content: const Text(
                              'Please contact the Sielify Team for speedy assistance\n\nEmail: ncfbla.app@gmail.com\nPhone Number: 425-877-6783'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'),
                            )
                          ],
                        );
                      })),
            ),
            // Login Button
            Center(
              widthFactor: 3,
              // if we're not signing in, then display the circular progress indicator
              child: !_isSigningIn
                  ? ElevatedButton(
                      style: const ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(Size(300, 75)),
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(101, 88, 245, 1))),
                      onPressed: () async {
                        setState(() {
                          _isSigningIn = true;
                        });
                        if (await API().loginConference(
                            _passwordController?.text ?? "",
                            _usernameController?.text ?? "")) {
                          AppInfo.conference = await API().findConference(
                              _passwordController?.text ?? "",
                              _usernameController?.text ?? "");
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _usernameController2!.text,
                                    password: _passwordController2!.text);
                          } catch (e) {
                            if (e is FirebaseAuthException) {
                              switch (e.code) {
                                case 'invalid-credential':
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: const Color.fromARGB(
                                              255, 105, 27, 27),
                                          content: Text(
                                              'Error: invalid Sielify credential provided. Recheck email and/or password.',
                                              style: GoogleFonts.getFont(
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                'Poppins',
                                              ))));

                                  break;
                                case 'invalid-email':
                                  // Handle invalid email address format
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: const Color.fromARGB(
                                              255, 105, 27, 27),
                                          content: Text(
                                              'Error: Sielify Email is invalid. Did you make a typo?',
                                              style: GoogleFonts.getFont(
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                'Poppins',
                                              ))));
                                  break;
                                case 'user-not-found':
                                  // Handle when the user does not exist
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: const Color.fromARGB(
                                              255, 105, 27, 27),
                                          content: Text(
                                              'Error: User does not exist.',
                                              style: GoogleFonts.getFont(
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                'Poppins',
                                              ))));
                                  break;

                                case 'user-disabled':
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: const Color.fromARGB(
                                              255, 105, 27, 27),
                                          content: Text(
                                              'Error: User account is disabled.',
                                              style: GoogleFonts.getFont(
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                'Poppins',
                                              ))));

                                  break;
                                default:
                                  // Handle other Firebase Authentication errors
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: const Color.fromARGB(
                                              255, 105, 27, 27),
                                          content: Text(
                                              'An unknown error occurred when signing in.',
                                              style: GoogleFonts.getFont(
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                'Poppins',
                                              ))));
                                  break;
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: const Color.fromARGB(
                                          255, 105, 27, 27),
                                      content: Text(
                                          'An unknown error occurred when signing in.',
                                          style: GoogleFonts.getFont(
                                            fontSize: 16,
                                            color: const Color(0xFFe9e9e9),
                                            'Poppins',
                                          ))));
                            }
                            setState(() {
                              _isSigningIn = false;
                            });
                            return;
                          }

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    (HomePageAdmin(pIndex: 0))),
                            (route) =>
                                false, // This condition removes all previous routes
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 105, 27, 27),
                              content: Text(
                                  'Incorrect conference password or conference name.',
                                  style: GoogleFonts.getFont(
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    'Poppins',
                                  ))));
                          setState(() {
                            _isSigningIn = false;
                          });
                        }
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  : const Center(
                      widthFactor: 8, child: CircularProgressIndicator()),
            )
          ],
        ),
      ]),
    );
  }
}
