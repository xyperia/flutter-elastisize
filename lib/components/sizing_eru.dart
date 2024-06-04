import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class SizingERU extends StatefulWidget {
  const SizingERU({Key? key}) : super(key: key);

  @override
  State<SizingERU> createState() => _SizingERUState();
}

class _SizingERUState extends State<SizingERU> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sizing ERU')),
      body: Center(
        child: Text("Sizing ERU is under development!")
      )
    );
  }
}
