import 'package:flutter/material.dart';


class BmiService {
  static double calculateBmi(double weightKg, double heightCm) {
    final double heightM = heightCm / 100.0;
    
    return weightKg / (heightM * heightM);
  }

  static Map<String, dynamic> interpretBmi(double bmi, String gender) {
    String resultTest;
    String advice;
    Color color;

    double adjustedBmi = bmi;
    
    if (gender == 'male' && bmi < 20) {
      adjustedBmi = bmi + 0.5;
    } else if (gender == 'female' && bmi > 25) {
      adjustedBmi = bmi - 0.5;
    }

    if (adjustedBmi < 18.5) {
      advice = "Your BMI is below normal. Try to eat a bit more and stay consistent";
      resultTest = "UnderWeight!";
      color = Colors.blue;
    } else if (adjustedBmi >= 18.5 && adjustedBmi < 25.0) {
      advice = "You’re in a healthy BMI range, keep it up!";
      resultTest = "Normal!";
      color = Colors.green;
    } else if (adjustedBmi >= 25.0 && adjustedBmi < 30.0) {
      advice = "Your BMI is slightly above normal. Small changes = big progress!";
      resultTest = "OverWeight!";
      color = Colors.orange;
    } else {
      advice = "Your BMI is much higher than normal. Don’t worry, you can start improving today!";
      resultTest = "Obesity!";
      color = Colors.red;
    }

    return {
      'bmi': bmi.toStringAsFixed(1), 
      'advice': advice,
      'resultText': resultTest,
      'color': color,
    };
  }
}


class BmiResultDialog extends StatelessWidget {
  final String bmiValue;
  final String advice;
  final String resultText;
  final Color color;

  const BmiResultDialog({
    super.key,
    required this.bmiValue,
    required this.advice,
    required this.resultText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.08),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "BMI Result :",
              style: TextStyle(
                color: Color(0xFF9999A1),
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              bmiValue,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.18,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              resultText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            _buildBmiIndicator(screenWidth),

            SizedBox(height: screenHeight * 0.02),
            Text(
              advice,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenHeight * 0.015,
                ),
              ),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiIndicator(double screenWidth) {
    const double minRange = 16.0;
    const double maxRange = 32.0;
    
    double bmiNum = double.tryParse(bmiValue) ?? 0.0;
    
    double normalizedBmi = (bmiNum.clamp(minRange, maxRange) - minRange) / (maxRange - minRange);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("<18.5", style: TextStyle(fontSize: screenWidth * 0.035, color: Color(0xFF9999A1), fontWeight: FontWeight.w700)),
            Text("30<", style: TextStyle(fontSize: screenWidth * 0.035, color: Color(0xFF9999A1), fontWeight: FontWeight.w700)),
          ],
        ),
        SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.cyan,
                    Colors.lightGreen,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                  stops: [0.0, 0.15, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment(
                  (normalizedBmi * 2) - 1,
                  0,
                ),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black38, blurRadius: 3)
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}