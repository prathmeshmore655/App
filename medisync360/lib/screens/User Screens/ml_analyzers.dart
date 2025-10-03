import 'package:flutter/material.dart';

class MlAnalyzers extends StatefulWidget {
  const MlAnalyzers({super.key});

  @override
  State<MlAnalyzers> createState() => _MlAnalyzersState();
}

class _MlAnalyzersState extends State<MlAnalyzers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome to the ml analyzer"),),
    );
  }
}