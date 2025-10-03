import 'package:flutter/material.dart';

class MyVault extends StatefulWidget {
  const MyVault({super.key});

  @override
  State<MyVault> createState() => _MyVaultState();
}

class _MyVaultState extends State<MyVault> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to the vault service"),),
    );
  }
}