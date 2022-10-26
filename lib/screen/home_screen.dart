import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:warung_ku/provider/items_provider.dart';
import 'package:warung_ku/screen/entry_data.dart';
import 'package:warung_ku/screen/login_screen.dart';
import 'package:warung_ku/widget/entry_sales.dart';
import 'package:warung_ku/widget/list_item.dart';
import 'package:warung_ku/widget/settings.dart';
import 'package:warung_ku/widget/table_items.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  final List<Widget> screens = [
    const EntrySales(),
    ListItems(),
    TableData(),
    const Settings(),
  ];

  Future<void> initialState() async {
    var data = Provider.of<ItemsProvider>(context, listen: false);
    data.get();
    if (mounted) {}
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialState();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Store',
          style: GoogleFonts.lato(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: (_bottomNavIndex == 1)
                ? IconButton(
                    onPressed: () async {
                      if (_bottomNavIndex == 1) {
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
                    icon: Icon((_bottomNavIndex == 1)
                        ? Icons.add
                        : Icons.logout_outlined),
                  )
                : Container(),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.storage,
          Icons.history,
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
