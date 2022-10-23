import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_ku/screen/entry_data.dart';
import 'package:warung_ku/screen/login_screen.dart';
import 'package:warung_ku/widget/list_item.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  final List<Widget> screens = [
    const Center(child: Text('Home')),
    ListItems(),
    const Center(child: Text('Profile')),
    const Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WarungKu',
          style: GoogleFonts.lato(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                if (_bottomNavIndex == 1) {
                  Navigator.pushNamed(context, EntryItems.routeName);
                } else {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.routeName, (route) => false);
                }
              },
              icon: Icon(
                  (_bottomNavIndex == 1) ? Icons.add : Icons.logout_outlined),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.storage,
          Icons.person,
          Icons.settings,
        ],
        activeColor: Colors.blue,
        gapLocation: GapLocation.none,
        activeIndex: _bottomNavIndex,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: screens,
      ),
    );
  }
}