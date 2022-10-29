import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:warung_ku/provider/items_provider.dart';
import 'package:warung_ku/provider/selling_provider.dart';
import 'package:warung_ku/provider/theme_provider.dart';
import 'package:warung_ku/screen/entry_data.dart';
import 'package:warung_ku/screen/home_screen.dart';
import 'package:warung_ku/screen/login_screen.dart';
import 'package:warung_ku/screen/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ItemsProvider()),
      ChangeNotifierProvider(create: (_) => SellingProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColorDark: Colors.blue,
            brightness: value.isdark ? Brightness.light : Brightness.dark,
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          routes: {
            EntryItems.routeName: (context) => const EntryItems(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            Wrapper.routeName: (context) => const Wrapper(),
          },
          initialRoute: Wrapper.routeName,
        );
      },
    );
  }
}
