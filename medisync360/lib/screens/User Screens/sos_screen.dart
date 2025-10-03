import 'package:flutter/material.dart';

class SOS_Screen extends StatefulWidget {
  const SOS_Screen({super.key});

  @override
  State<SOS_Screen> createState() => _SOS_ScreenState();
}

class _SOS_ScreenState extends State<SOS_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to the SOS service"),),
    );
  }
}