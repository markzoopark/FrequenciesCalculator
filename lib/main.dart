import 'package:flutter/material.dart';
import 'frequency_calculator.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор частот v2'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "A (+)"),
            Tab(text: "V (-)"),
            Tab(text: "?"),
            Tab(text: "TX, RX"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ModeAPlus(),
          ModeVMinus(),
          ModeQuestion(),
          FrequencyCalculator(),
        ],
      ),
    );
  }
}
