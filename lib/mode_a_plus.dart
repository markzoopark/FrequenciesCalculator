import 'package:flutter/material.dart';

class ModeAPlus extends StatefulWidget {
  @override
  _ModeAPlusState createState() => _ModeAPlusState();
}

class _ModeAPlusState extends State<ModeAPlus> {
  final TextEditingController _controllerRF1 = TextEditingController();
  final TextEditingController _controllerIF1 = TextEditingController();
  final TextEditingController _controllerLO1 = TextEditingController();
  final TextEditingController _controllerIF2 = TextEditingController();
  final TextEditingController _controllerRF2 = TextEditingController();
  final TextEditingController _controllerLO2 = TextEditingController();
  bool _isDuplicate = false;
  String? _errorRF1;
  String? _errorIF1;
  String? _errorRF2;
  String? _errorIF2;

  @override
  void initState() {
    super.initState();
    _controllerRF1.addListener(_updateResults);
    _controllerIF1.addListener(_updateResults);
    _controllerRF2.addListener(_updateResults);
    _controllerIF2.addListener(_updateResults);
  }

  @override
  void dispose() {
    _controllerRF1.removeListener(_updateResults);
    _controllerIF1.removeListener(_updateResults);
    _controllerRF2.removeListener(_updateResults);
    _controllerIF2.removeListener(_updateResults);
    _controllerRF1.dispose();
    _controllerIF1.dispose();
    _controllerLO1.dispose();
    _controllerRF2.dispose();
    _controllerIF2.dispose();
    _controllerLO2.dispose();
    super.dispose();
  }

  void _updateResults() {
    _validateAndUpdate(
        _controllerRF1, (error) => setState(() => _errorRF1 = error));
    _validateAndUpdate(
        _controllerIF1, (error) => setState(() => _errorIF1 = error));
    _validateAndUpdate(
        _controllerRF2, (error) => setState(() => _errorRF2 = error));
    _validateAndUpdate(
        _controllerIF2, (error) => setState(() => _errorIF2 = error));

    final int? RF1 =
        _validateInput(_controllerRF1.text, (error) => _errorRF1 = error);
    final int? IF1 =
        _validateInput(_controllerIF1.text, (error) => _errorIF1 = error);
    final int? RF2 =
        _validateInput(_controllerRF2.text, (error) => _errorRF2 = error);
    int? IF2 =
        _validateInput(_controllerIF2.text, (error) => _errorIF2 = error);

    if (_isDuplicate && IF1 != null) {
      IF2 = IF1;
      _controllerIF2.text = IF2.toString();
    }

    if (RF1 != null && IF1 != null) {
      final int LO1 = RF1 + IF1;
      _controllerLO1.text = LO1.toString();
    } else {
      _controllerLO1.text = '';
    }

    if (RF2 != null && IF2 != null) {
      final int LO2 = RF2 + IF2;
      _controllerLO2.text = LO2.toString();
    } else {
      _controllerLO2.text = '';
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

  void _validateAndUpdate(
      TextEditingController controller, Function(String?) setError) {
    final int? value = _validateInput(controller.text, setError);
    if (value != null) {
      _calculateResults();
    }
  }

  void _calculateResults() {
    final int? RF1 =
        _validateInput(_controllerRF1.text, (error) => _errorRF1 = error);
    final int? IF1 =
        _validateInput(_controllerIF1.text, (error) => _errorIF1 = error);
    final int? RF2 =
        _validateInput(_controllerRF2.text, (error) => _errorRF2 = error);
    int? IF2 =
        _validateInput(_controllerIF2.text, (error) => _errorIF2 = error);

    if (_isDuplicate && IF1 != null) {
      IF2 = IF1;
      _controllerIF2.text = IF2.toString();
    }

    if (RF1 != null && IF1 != null) {
      final int LO1 = RF1 + IF1;
      _controllerLO1.text = LO1.toString();
    } else {
      _controllerLO1.text = '';
    }

    if (RF2 != null && IF2 != null) {
      final int LO2 = RF2 + IF2;
      _controllerLO2.text = LO2.toString();
    } else {
      _controllerLO2.text = '';
    }

    setState(() {});
  }

  void _onDuplicateChanged(bool? value) {
    setState(() {
      _isDuplicate = value ?? false;
      if (!_isDuplicate) {
        _controllerIF2.clear();
      }
      _updateResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Передавач (МГц) RF+IF=LO',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            _buildTextField(
                controller: _controllerRF1,
                label: 'Сигнал (RF)',
                errorText: _errorRF1),
            _buildTextField(
                controller: _controllerIF1,
                label: 'Ефір (IF)',
                errorText: _errorIF1),
            TextField(
                controller: _controllerLO1,
                decoration: InputDecoration(labelText: 'Генератор (LO)'),
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
            Text('Приймач (МГц) RF+IF=LO',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            _buildTextField(
                controller: _controllerIF2,
                label: 'Ефір (IF)',
                errorText: _errorIF2),
            _buildTextField(
                controller: _controllerRF2,
                label: 'Сигнал (RF)',
                errorText: _errorRF2),
            TextField(
                controller: _controllerLO2,
                decoration: InputDecoration(labelText: 'Генератор (LO)'),
                readOnly: true,
                style: TextStyle(fontSize: 18)),
          ],
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
            if (controller == _controllerRF1) _errorRF1 = error;
            if (controller == _controllerIF1) _errorIF1 = error;
            if (controller == _controllerRF2) _errorRF2 = error;
            if (controller == _controllerIF2) _errorIF2 = error;
          });
        });
      },
    );
  }
}
