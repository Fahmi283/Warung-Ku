import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:warung_ku/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  final formKey = GlobalKey<FormState>();
  int activeTab = 0;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'WarungKu',
          style: GoogleFonts.lato(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleSwitch(
                minWidth: 90.0,
                initialLabelIndex: activeTab,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['SignUp', 'SignIn'],
                activeBgColors: const [
                  [Colors.blue],
                  [Colors.blueAccent]
                ],
                onToggle: (index) {
                  setState(() {
                    activeTab = index!;
                  });
                  // ignore: avoid_print
                  print(activeTab);
                },
              ),
              //* TITLE
              const SizedBox(
                height: 40,
              ),
              Text(
                'SIGN IN WITH EMAIL/PASSWORD',
                style:
                    GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              //* EMAIL TEXTFIELD
              (activeTab == 0)
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'Name'),
                      ),
                    )
                  : const SizedBox(
                      width: 1,
                      height: 0,
                    ),

              Container(
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Email'),
                ),
              ),

              //* PASSWORD TEXTFIELD
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: TextFormField(
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Password'),
                ),
              ),
              (activeTab == 0)
                  ? SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);

                              try {
                                await FirebaseAuth.instance.currentUser!
                                    .updateDisplayName(nameController.text);
                                // ignore: use_build_context_synchronously
                                showNotification(context,
                                    'Account has been created, please login');
                                emailController.clear();
                                passwordController.clear();
                                setState(() {
                                  activeTab = 1;
                                });
                              } on FirebaseAuthException catch (e) {
                                // ignore: use_build_context_synchronously
                                showNotification(context, e.message.toString());
                              }
                            } on FirebaseAuthException catch (e) {
                              showNotification(context, e.message.toString());
                            }
                          },
                          child: const Text("Sign Up")),
                    )
                  : SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () async {
                            SmartDialog.showLoading();
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomeScreen.routeName, (route) => false);
                              SmartDialog.dismiss();
                            } on FirebaseAuthException catch (e) {
                              showNotification(context, e.message.toString());
                              SmartDialog.dismiss();
                            }
                          },
                          // CODE HERE: Change button text based on current user
                          child: const Text("Sign In")),
                    ),

              //* RESET PASSWORD BUTTON
              TextButton(
                onPressed: () async {
                  SmartDialog.showLoading();
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);
                    SmartDialog.dismiss();
                    if (mounted) {}
                    showNotification(context, 'Silahkan Cek Email Anda');
                  } on FirebaseAuthException catch (e) {
                    SmartDialog.dismiss();
                    showNotification(context, e.message.toString());
                  }
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue, content: Text(message.toString())));
  }
}
