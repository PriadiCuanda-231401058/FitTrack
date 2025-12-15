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

  Widget _inputRow(
    BuildContext context,
    String asset,
    String hint,
    String unit,
    TextEditingController controller,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double iconSize = screenWidth * 0.08;
    final double fontSize = screenWidth * 0.055;
    final double unitWidth = screenWidth * 0.18;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: Image.asset(asset, fit: BoxFit.contain, color: Colors.white),
        ),
        SizedBox(width: screenWidth * 0.05),

        Flexible(
          flex: 1,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000).withOpacity(0.3),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000).withOpacity(0.3),
              ),
              filled: true,
              fillColor: Color(0xFFFFFFFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.015,
                horizontal: screenWidth * 0.02,
              ),
            ),
          ),
        ),

        SizedBox(width: screenWidth * 0.05),

        SizedBox(
          width: unitWidth,
          child: Text(
            unit,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.85,
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.08,
          horizontal: screenWidth * 0.08,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFF1E1E1E),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFFFFF).withOpacity(0.8),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _inputRow(
              context,
              "assets/images/age.png",
              "Age",
              "Years",
              ageController,
            ),
            SizedBox(height: screenWidth * 0.06),
            _inputRow(
              context,
              "assets/images/height.png",
              "Height",
              "Cm",
              heightController,
            ),
            SizedBox(height: screenWidth * 0.06),
            _inputRow(
              context,
              "assets/images/weight.png",
              "Weight",
              "Kg",
              weightController,
            ),
          ],
        ),
      ),
    );
  }
}
