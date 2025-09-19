import 'package:flutter/material.dart';

class ModeScreen extends StatefulWidget {
  final bool isDark;
  final void Function() toggleTheme;
  const ModeScreen(
      {super.key, required this.isDark, required this.toggleTheme});

  @override
  State<ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          child: SwitchListTile(
              title: Text((widget.isDark) ? 'Dark Mode' : 'Light Mode'),
              value: widget.isDark,
              onChanged: (value) {
                widget.toggleTheme();
              }),
        ),
      ),
    );
  }
}
