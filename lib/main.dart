import 'package:flutter/material.dart';

void main() => runApp(SimpleCalculator());

class SimpleCalculator extends StatelessWidget {
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

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  String _result = '';

  void _calculate() {
    final double a = double.tryParse(_controllerA.text) ?? 0;
    final double b = double.tryParse(_controllerB.text) ?? 0;
    setState(() {
      _result = (a - b).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerA,
              decoration: InputDecoration(labelText: 'Enter number A'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _controllerB,
              decoration: InputDecoration(labelText: 'Enter number B'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: Text('Calculate A - B'),
            ),
            SizedBox(height: 20),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
