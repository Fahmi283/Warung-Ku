import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../screen/login_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var active = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('Dark Mode'),
              trailing: ToggleSwitch(
                minWidth: 60.0,
                minHeight: 30,
                initialLabelIndex: active,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['OFF', 'ON'],
                activeBgColors: const [
                  [Colors.blue],
                  [Colors.blueAccent]
                ],
                onToggle: (index) {
                  setState(() {
                    active = index!;
                  });
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () async {
                SmartDialog.showLoading();
                await FirebaseAuth.instance.signOut();
                SmartDialog.dismiss();
                if (mounted) {}
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.routeName, (route) => false);
              },
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          )
        ],
      ),
    );
  }
}
