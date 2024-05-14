import 'package:flutter/material.dart';

void main() => runApp(FrequencyCalculator());

class FrequencyCalculator extends StatelessWidget {
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
  final TextEditingController _controllerAt = TextEditingController();
  final TextEditingController _controllerBt = TextEditingController();
  final TextEditingController _controllerAr = TextEditingController();
  final TextEditingController _controllerBr = TextEditingController();
  final TextEditingController _controllerCt = TextEditingController();
  final TextEditingController _controllerCr = TextEditingController();
  bool _isDuplicate = false;
  String? _errorAt;
  String? _errorBt;
  String? _errorAr;
  String? _errorBr;

  @override
  void initState() {
    super.initState();
    _controllerAt.addListener(_updateResults);
    _controllerBt.addListener(_updateResults);
    _controllerAr.addListener(_updateResults);
    _controllerBr.addListener(_updateResults);
  }

  @override
  void dispose() {
    _controllerAt.removeListener(_updateResults);
    _controllerBt.removeListener(_updateResults);
    _controllerAr.removeListener(_updateResults);
    _controllerBr.removeListener(_updateResults);
    _controllerAt.dispose();
    _controllerBt.dispose();
    _controllerAr.dispose();
    _controllerBr.dispose();
    _controllerCt.dispose();
    _controllerCr.dispose();
    super.dispose();
  }

  void _updateResults() {
    _validateAndUpdate(
        _controllerAt, (error) => setState(() => _errorAt = error));
    _validateAndUpdate(
        _controllerBt, (error) => setState(() => _errorBt = error));
    _validateAndUpdate(
        _controllerAr, (error) => setState(() => _errorAr = error));
    _validateAndUpdate(
        _controllerBr, (error) => setState(() => _errorBr = error));
  }

  void _validateAndUpdate(
      TextEditingController controller, Function(String?) setError) {
    final int? value = _validateInput(controller.text, setError);
    if (value != null) {
      _calculateResults();
    }
  }

  void _calculateResults() {
    final int? At =
        _validateInput(_controllerAt.text, (error) => _errorAt = error);
    final int? Bt =
        _validateInput(_controllerBt.text, (error) => _errorBt = error);
    final int? Ar =
        _validateInput(_controllerAr.text, (error) => _errorAr = error);
    int? Br = _validateInput(_controllerBr.text, (error) => _errorBr = error);

    if (_isDuplicate && At != null && Bt != null) {
      Br = At - Bt;
      _controllerBr.text = Br.toString();
    }

    if (At != null && Bt != null) {
      final int Ct = At - Bt;
      _controllerCt.text = Ct.toString();
    } else {
      _controllerCt.text = '';
    }

    if (Ar != null && Br != null) {
      final int Cr = Ar - Br;
      _controllerCr.text = Cr.toString();
    } else {
      _controllerCr.text = '';
    }

    setState(() {});
  }

  int? _validateInput(String input, Function(String?) setError) {
    if (input.isEmpty) {
      setError(null);
      return null;
    }
    final int? value = int.tryParse(input);
    if (value == null || value < 100 || value > 6000) {
      setError('Будь ласка, введіть значення між 100 та 6000 МГц.');
      return null;
    }
    setError(null);
    return value;
  }

  void _onDuplicateChanged(bool? value) {
    setState(() {
      _isDuplicate = value ?? false;
      if (!_isDuplicate) {
        _controllerBr.clear();
      }
    });
    _calculateResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор частот v1'),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TX (передавач)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Ат - Вт = Ст (Ат > Вт)', style: TextStyle(fontSize: 16)),
              _buildTextField(
                  controller: _controllerAt,
                  label: 'Ат (100-6000 МГц)',
                  errorText: _errorAt),
              _buildTextField(
                  controller: _controllerBt,
                  label: 'Вт (100-6000 МГц)',
                  errorText: _errorBt),
              TextField(
                  controller: _controllerCt,
                  decoration: InputDecoration(labelText: 'Ст'),
                  readOnly: true,
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Дубль', style: TextStyle(fontSize: 18)),
                  Checkbox(value: _isDuplicate, onChanged: _onDuplicateChanged),
                ],
              ),
              SizedBox(height: 20),
              Text('RX (приймач)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Аr - Вr = Cr (Аr > Вr)', style: TextStyle(fontSize: 16)),
              _buildTextField(
                  controller: _controllerAr,
                  label: 'Аr (100-6000 МГц)',
                  errorText: _errorAr),
              _buildTextField(
                  controller: _controllerBr,
                  label: 'Вr (100-6000 МГц)',
                  errorText: _errorBr),
              TextField(
                  controller: _controllerCr,
                  decoration: InputDecoration(labelText: 'Cr'),
                  readOnly: true,
                  style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 18),
      onChanged: (value) {
        _validateInput(value, (error) {
          setState(() {
            if (controller == _controllerAt) _errorAt = error;
            if (controller == _controllerBt) _errorBt = error;
            if (controller == _controllerAr) _errorAr = error;
            if (controller == _controllerBr) _errorBr = error;
          });
        });
      },
    );
  }
}
