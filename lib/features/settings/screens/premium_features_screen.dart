import 'package:flutter/material.dart';

class PremiumFeaturesScreen extends StatelessWidget {
  const PremiumFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "Premium Features",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: const Color(0xffA55EFF),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.02),

        _plan(
          context: context,
          title: "Basic",
          price: "Rp49.000",
          duration: "/ month",
          description: "Ideal for beginners starting their fitness journey.",
          icon: Image.asset('assets/images/blue_crown.png', width: screenWidth * 0.02),
        ),
        SizedBox(height: screenHeight * 0.02),

        _plan(
          context: context,
          title: "Standard",
          price: "Rp99.000",
          duration: "/ 3 months",
          description: "Stay consistent and see real progress.",
          icon: Image.asset('assets/images/green_crown.png', width: screenWidth * 0.02),
        ),
        SizedBox(height: screenHeight * 0.02),

        _plan(
          context: context,
          title: "Pro",
          price: "Rp229.000",
          duration: "/ 6 months",
          description: "Get advanced workouts and detailed progress tracking.",
          icon: Image.asset('assets/images/yellow_crown.png', width: screenWidth * 0.02),
        ),
        SizedBox(height: screenHeight * 0.02),

        _plan(
          context: context,
          title: "Ultimate",
          price: "Rp399.000",
          duration: "/ year",
          description: "Full access to all features and premium programs.",
          icon: Image.asset('assets/images/red_crown.png', width: screenWidth * 0.02),
        ),

        SizedBox(height: screenHeight * 0.05),

        Container(
          padding: EdgeInsets.symmetric(vertical: screenHeight  * 0.008),
          decoration: BoxDecoration(
            color: const Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Get Access",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Image.asset('assets/images/get_access.png', width: screenWidth * 0.1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _plan({
    required BuildContext context,
    required String title,
    required String price,
    required String duration,
    required String description,
    required Widget icon,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const Spacer(),

                    SizedBox(
                      width: screenWidth * 0.18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: screenWidth * 0.028,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.006),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.020,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.03),

          SizedBox(width: screenWidth * 0.06, child: icon),
        ],
      ),
    );
  }
    }
