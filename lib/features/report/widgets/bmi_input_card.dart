import "package:flutter/material.dart";

class BmiInputCard extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  const BmiInputCard({
    super.key,
    required this.ageController,
    required this.heightController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Defined locally in build() to safely access 'context' without a redundant Builder.
    Widget inputRow(String asset, String hint, String unit,
        TextEditingController controller) {
      final double iconSize = screenWidth * 0.07;

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          SizedBox(width: screenWidth * 0.04),
          Flexible(
            child: SizedBox(
              width: screenWidth * 0.42,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                style: TextStyle(
                  fontSize: screenWidth * 0.048,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.9),
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: screenWidth * 0.048,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000).withOpacity(0.30),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF000000).withOpacity(0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.02,
                    horizontal: screenWidth * 0.02,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.035),
          Text(
            unit,
            style: TextStyle(
              fontSize: screenWidth * 0.048,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          )
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF66666E).withOpacity(0.60),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFFFFF).withOpacity(0.28),
            blurRadius: 8,
            spreadRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          inputRow("assets/images/age.png", "Age", "Years", ageController),
          SizedBox(height: screenWidth * 0.05),
          inputRow(
              "assets/images/height.png", "Height", "Cm", heightController),
          SizedBox(height: screenWidth * 0.05),
          inputRow(
              "assets/images/weight.png", "Weight", "Kg", weightController),
        ],
      ),
    );
  }
}