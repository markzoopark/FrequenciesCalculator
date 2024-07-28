import 'package:flutter/material.dart';
import 'dart:math';

class ModeQuestion extends StatefulWidget {
  @override
  _ModeQuestionState createState() => _ModeQuestionState();
}

class _ModeQuestionState extends State<ModeQuestion> {
  final TextEditingController _controllerH1 = TextEditingController(text: '36');
  final TextEditingController _controllerH2 = TextEditingController(text: '16');
  final TextEditingController _controllerR = TextEditingController();
  final TextEditingController _controllerF = TextEditingController(text: '300');
  final TextEditingController _controllerD = TextEditingController(text: '2.5');
  final TextEditingController _controllerL = TextEditingController();
  final TextEditingController _controllerLambda = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerH1.addListener(_calculateRange);
    _controllerH2.addListener(_calculateRange);
    _controllerF.addListener(_calculateDipole);
    _controllerD.addListener(_calculateDipole);
    _calculateRange();
    _calculateDipole();
  }

  @override
  void dispose() {
    _controllerH1.removeListener(_calculateRange);
    _controllerH2.removeListener(_calculateRange);
    _controllerF.removeListener(_calculateDipole);
    _controllerD.removeListener(_calculateDipole);
    _controllerH1.dispose();
    _controllerH2.dispose();
    _controllerR.dispose();
    _controllerF.dispose();
    _controllerD.dispose();
    _controllerL.dispose();
    _controllerLambda.dispose();
    super.dispose();
  }

  void _calculateRange() {
    final double h1 = double.tryParse(_controllerH1.text) ?? 36;
    final double h2 = double.tryParse(_controllerH2.text) ?? 16;
    final double R = 3.57 * (sqrt(h1) + sqrt(h2));
    _controllerR.text = R.toStringAsFixed(2);
    setState(() {});
  }

  void _calculateDipole() {
    final double F =
        double.tryParse(_controllerF.text) ?? 3000; // F = 3000 МГц по умолчанию
    final double d =
        double.tryParse(_controllerD.text) ?? 2.5; // d = 2.5 мм по умолчанию
    final double lambda = 300 / F; // Расчет длины волны в метрах
    _controllerLambda.text = lambda.toStringAsFixed(6);

    final double Rld = lambda / (0.001 * d); // Расчет Rld
    final num exponent1 = pow(
        (Rld / 0.0004490702), 1.792529); // Внутренний экспоненциальный расчет
    final num denominatorBase =
        exponent1 + 1; // Добавляем 1 перед возведением в степень
    final num denominator =
        pow(denominatorBase, 0.3004597); // Экспоненциальный расчет знаменателя
    final double numerator = -10.88627 - 0.9787011;
    final double k = 0.9787011 + (numerator / denominator); // Расчет k
    final double L = 50 * k * (300 / F); // Расчет L

    // Печать всех промежуточных значений для отладки
    print("lambda: $lambda");
    print("Rld: $Rld");
    print("exponent1: $exponent1");
    print("denominatorBase: $denominatorBase");
    print("denominator: $denominator");
    print("k: $k");
    print("L: $L");

    _controllerL.text =
        L.toStringAsFixed(6); // 6 знаков после запятой для точности
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Дальність прямої видимості',
                'assets/line_of_sight.png', screenWidth),
            _buildTextField(controller: _controllerH1, label: 'h1 (м)'),
            _buildTextField(controller: _controllerH2, label: 'h2 (м)'),
            _buildResultField(
                controller: _controllerR,
                label: 'R (км)',
                screenWidth: screenWidth),
            SizedBox(height: 20),
            _buildSectionTitle(
                'Розрахунок диполю', 'assets/dipole_lambda.png', screenWidth),
            _buildTextField(controller: _controllerF, label: 'F (МГц)'),
            _buildTextField(controller: _controllerD, label: 'd (мм)'),
            _buildResultField(
                controller: _controllerL,
                label: 'L (см)',
                screenWidth: screenWidth),
            _buildResultField(
                controller: _controllerLambda,
                label: 'λ (м)',
                screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      String title, String imagePath, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        SizedBox(height: 10),
        Center(child: Image.asset(imagePath, width: screenWidth * 0.85)),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildResultField({
    required TextEditingController controller,
    required String label,
    String? additionalImage,
    required double screenWidth,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (additionalImage != null)
            Center(
                child: Image.asset(additionalImage, width: screenWidth * 0.85)),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
