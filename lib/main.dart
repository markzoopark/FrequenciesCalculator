import 'package:flutter/material.dart';
import 'mode_a_plus.dart';
import 'mode_v_minus.dart';
import 'mode_question.dart';

void main() => runApp(FrequencyCalculatorApp());

class FrequencyCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTitleTap() {
    _tapCount++;
    if (_tapCount == 5) {
      _showEasterEgg();
      _tapCount = 0;
    }
  }

  void _showEasterEgg() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_decryptMessage("pdgh eb Ihgrufkhqnr Pdun")),
      ),
    );
  }

  String _decryptMessage(String message) {
    String decrypted = '';
    for (int i = 0; i < message.length; i++) {
      int charCode = message.codeUnitAt(i);
      if ((charCode >= 65 && charCode <= 90) ||
          (charCode >= 97 && charCode <= 122)) {
        charCode -= 3;
        if ((charCode < 65 && message[i].toUpperCase() == message[i]) ||
            (charCode < 97 && message[i].toLowerCase() == message[i])) {
          charCode += 26;
        }
      }
      decrypted += String.fromCharCode(charCode);
    }
    return decrypted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _handleTitleTap,
          child: Text('Калькулятор частот v2'),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "A (+)"),
            Tab(text: "V (-)"),
            Tab(text: "?"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ModeAPlus(),
          ModeVMinus(),
          ModeQuestion(),
        ],
      ),
    );
  }
}
