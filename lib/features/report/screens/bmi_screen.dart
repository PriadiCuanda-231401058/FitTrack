import "package:flutter/material.dart";
import "../widgets/bmi_input_card.dart";
import "../widgets/profile_avatar.dart";
import "../widgets/bmi_result_dialog.dart"; 
import "package:fittrack/shared/widgets/navigation_bar_widget.dart";

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  String selectedGender = "";
  late final TextEditingController ageController;
  late final TextEditingController heightController;
  late final TextEditingController weightController;
  bool isFormComplete = false;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    ageController.addListener(updateFormStatus);
    heightController.addListener(updateFormStatus);
    weightController.addListener(updateFormStatus);
  }

  void updateFormStatus() {
    if (!mounted) return;

    setState(() {
      isFormComplete = ageController.text.isNotEmpty &&
          heightController.text.isNotEmpty &&
          weightController.text.isNotEmpty &&
          selectedGender.isNotEmpty;
    });
  }

  void selectGender(String gender) {
    if (!mounted) return;

    setState(() {
      selectedGender = gender;
    });
    updateFormStatus();
  }

  void _calculateAndShowBmi() {
    if (!isFormComplete) return;

    final double weight = double.tryParse(weightController.text) ?? 0.0;
    final double height = double.tryParse(heightController.text) ?? 0.0;

    if (weight <= 0 || height <= 0) return;

    final double bmiValue = BmiService.calculateBmi(weight, height);
    final Map<String, dynamic> interpretation = BmiService.interpretBmi(bmiValue, selectedGender);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BmiResultDialog(
          bmiValue: interpretation['bmi'],
          advice: interpretation['advice'],
          resultText: interpretation['resultText'],
          color: interpretation['color'],
        );
      },
    );
  }

  @override
  void dispose() {
    ageController.removeListener(updateFormStatus);
    heightController.removeListener(updateFormStatus);
    weightController.removeListener(updateFormStatus);

    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    final MaterialStateProperty<Color> buttonBackgroundColor = 
        MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) {
        return const Color(0xFFD9D9D9); 
      }
      return const Color(0xFF3B82F6);
    });

    final MaterialStateProperty<Color> buttonForegroundColor = 
        MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.black54; 
      }
      return Colors.white70;
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "BMI",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: (screenWidth / 390) * 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.03),
                Visibility(
                  visible: !keyboardVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => selectGender("male"),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: selectedGender == "male"
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF1E90FF),
                                      blurRadius: 12,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: ProfileAvatar(
                            size: screenWidth * 0.22,
                            imagePath: "assets/images/male.png",
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.15),
                      GestureDetector(
                        onTap: () => selectGender("female"),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: selectedGender == "female"
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF1E90FF),
                                      blurRadius: 12,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: ProfileAvatar(
                            size: screenWidth * 0.22,
                            imagePath: "assets/images/female.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                BmiInputCard(
                  ageController: ageController,
                  heightController: heightController,
                  weightController: weightController,
                ),
                SizedBox(height: screenHeight * 0.05),
                Visibility(
                  visible: !keyboardVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.065,
                    child: ElevatedButton(
                      onPressed: isFormComplete ? _calculateAndShowBmi : null,
                      style: ButtonStyle(
                        backgroundColor: buttonBackgroundColor,
                        foregroundColor: buttonForegroundColor,
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Text(
                        "Calculate BMI",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Visibility(
            visible: !keyboardVisible,
            child: NavigationBarWidget(location: "/reportScreen"),
          ),
        ),
      ),
    );
  }
}