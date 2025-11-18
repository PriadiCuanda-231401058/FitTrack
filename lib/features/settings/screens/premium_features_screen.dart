import 'package:flutter/material.dart';

class PremiumFeaturesScreen extends StatelessWidget {
  const PremiumFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ------------------ TITLE ------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Premium Features",
              style: TextStyle(
                fontSize: 26,
                color: Color(0xffA55EFF),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ],
        ),

        const SizedBox(height: 24),

        /// ------------------ LIST PLANS ------------------
        _plan(
          title: "Basic",
          price: "Rp49.000",
          duration: "/ month",
          description: "Ideal for beginners starting their fitness journey.",
          icon: Image.asset('assets/images/blue_crown.png', width: 26),
        ),
        const SizedBox(height: 16),

        _plan(
          title: "Standard",
          price: "Rp99.000",
          duration: "/ 3 months",
          description: "Stay consistent and see real progress.",
          icon: Image.asset('assets/images/green_crown.png', width: 26),
        ),
        const SizedBox(height: 16),

        _plan(
          title: "Pro",
          price: "Rp229.000",
          duration: "/ 6 months",
          description: "Get advanced workouts and detailed progress tracking.",
          icon: Image.asset('assets/images/yellow_crown.png', width: 26),
        ),
        const SizedBox(height: 16),

        _plan(
          title: "Ultimate",
          price: "Rp399.000",
          duration: "/ year",
          description: "Full access to all features and premium programs.",
          icon: Image.asset('assets/images/red_crown.png', width: 26),
        ),

        const SizedBox(height: 30),

        /// ------------------ GET ACCESS BUTTON ------------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Get Access",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Image.asset('assets/images/get_access.png', width: 26),
            ],
          ),
        ),
      ],
    );
  }

  /// -------------------------------------------------------
  ///                 PLAN COMPONENT (FIXED ALIGNMENT)
  /// -------------------------------------------------------
  Widget _plan({
    required String title,
    required String price,
    required String duration,
    required String description,
    required Widget icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          /// LEFT: Title + Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const Spacer(),

                    /// ---- FIXED WIDTH PRICE COLUMN ----
                    SizedBox(
                      width: 70, // <--- ini yg membuat harga sejajar semua
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            duration,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 7,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// ICON
          Center(child: icon),
        ],
      ),
    );
  }

}
