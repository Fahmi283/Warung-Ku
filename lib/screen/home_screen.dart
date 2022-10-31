import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:warung_ku/provider/theme_provider.dart';
import 'package:warung_ku/screen/entry_data.dart';
import 'package:warung_ku/screen/login_screen.dart';
import 'package:warung_ku/widget/entry_sales.dart';
import 'package:warung_ku/widget/settings.dart';
import 'package:warung_ku/widget/table_item.dart';
import 'package:warung_ku/widget/table_sale.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'SMART STORE',
            style: GoogleFonts.lato(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue[200]),
          ),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (_currentPage == 1)
            ? FloatingActionButton(
                backgroundColor: Colors.blue[200],
                heroTag: 'edit-list',
                onPressed: () async {
                  if (_currentPage == 1) {
                    Navigator.pushNamed(context, EntryItems.routeName);
                  } else {
                    SmartDialog.showLoading();
                    await FirebaseAuth.instance.signOut();
                    SmartDialog.dismiss();
                    if (mounted) {}
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.routeName, (route) => false);
                  }
                },
                child: const Icon(Icons.add),
              )
            : null,
        // bottomNavigationBar: AnimatedBottomNavigationBar(
        //   icons: const [
        //     Icons.home,
        //     Icons.storage,
        //     Icons.history,
        //     Icons.settings,
        //   ],
        //   backgroundColor: Colors.blue[200],
        //   inactiveColor: Colors.white,
        //   activeColor: Colors.blue[900],
        //   gapLocation: GapLocation.none,
        //   activeIndex: _bottomNavIndex,
        //   leftCornerRadius: 32,
        //   rightCornerRadius: 32,
        //   onTap: (index) => setState(() => _bottomNavIndex = index),
        //   //other params
        // ),
        body: PageView(
          controller: _pageController,
          children: const [
            EntrySales(),
            TableInventory(),
            TableSaleData(),
            Settings(),
          ],
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
        ),
        bottomNavigationBar: BottomBar(
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: Colors.blue.shade200,
              activeTitleColor: Colors.blue.shade400,
            ),
            BottomBarItem(
              icon: const Icon(Icons.storage_rounded),
              title: const Text('Inventory'),
              activeColor: Colors.blue.shade200,
              activeTitleColor: Colors.blue.shade400,
            ),
            BottomBarItem(
              icon: const Icon(Icons.work_history),
              title: const Text('History'),
              activeColor: Colors.blue.shade200,
              activeTitleColor: Colors.blue.shade400,
            ),
            BottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text('Settings'),
              activeColor: Colors.blue.shade200,
              activeTitleColor: Colors.blue.shade400,
            ),
          ],
        ),
      );
    });
  }
}
