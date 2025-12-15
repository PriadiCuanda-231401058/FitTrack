import 'package:flutter/material.dart';
import 'package:fittrack/services/payment_services.dart';

class PremiumFeaturesScreen extends StatefulWidget {
  const PremiumFeaturesScreen({super.key});

  @override
  State<PremiumFeaturesScreen> createState() => _PremiumFeaturesScreenState();
}

class _PremiumFeaturesScreenState extends State<PremiumFeaturesScreen> {
  String? _selectedPlan;
  bool _isProcessing = false;
  final PaymentService _paymentService = PaymentService();
  String? _stripeCustomerId;
  // bool _isLoadingCustomer = true;
  String customerId = '';

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  final Map<String, int> _planDurations = {
    'Basic': 1,
    'Standard': 3,
    'Pro': 6,
    'Ultimate': 12,
  };

  final Map<String, int> _planAmounts = {
    'Basic': 4900000,
    'Standard': 9900000,
    'Pro': 22900000,
    'Ultimate': 39900000,
  };

  Future<void> _initializePayment() async {
    try {
      _stripeCustomerId = await _paymentService.getOrCreateStripeCustomer();
    } catch (e) {
      // print('Error initializing payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          // _isLoadingCustomer = false;
        });
      }
    }
  }

  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Basic',
      'price': 'Rp49.000',
      'duration': '/ month',
      'description': 'Ideal for beginners starting their fitness journey.',
      'icon': 'assets/images/blue_crown.png',
      'color': const Color(0xFF1E90FF),
    },
    {
      'title': 'Standard',
      'price': 'Rp99.000',
      'duration': '/ 3 months',
      'description': 'Stay consistent and see real progress.',
      'icon': 'assets/images/green_crown.png',
      'color': const Color(0xFF1E90FF),
    },
    {
      'title': 'Pro',
      'price': 'Rp229.000',
      'duration': '/ 6 months',
      'description': 'Get advanced workouts and detailed progress tracking.',
      'icon': 'assets/images/yellow_crown.png',
      'color': const Color(0xFF1E90FF),
    },
    {
      'title': 'Ultimate',
      'price': 'Rp399.000',
      'duration': '/ year',
      'description': 'Full access to all features and premium programs.',
      'icon': 'assets/images/red_crown.png',
      'color': const Color(0xFF1E90FF),
    },
  ];

  void _selectPlan(String planTitle) {
    setState(() {
      _selectedPlan = planTitle;
    });
  }

  Future<void> _onGetAccessPressed() async {
    if (_selectedPlan == null || _isProcessing || _stripeCustomerId == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final amount = _planAmounts[_selectedPlan]!;
      final duration = _planDurations[_selectedPlan]!;

      await _paymentService.payWithPremiumUpdate(
        amount: amount,
        customerId: _stripeCustomerId!,
        premiumType: _selectedPlan!,
        durationInMonths: duration,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Premium features activated.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.of(
          context,
        ).pop({'success': true, 'plan': _selectedPlan, 'isPremium': true});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      // print('Payment error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

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

        ..._plans.map((plan) {
          final isSelected = _selectedPlan == plan['title'];

          return Column(
            children: [
              GestureDetector(
                onTap: () => _selectPlan(plan['title'] as String),
                child: _plan(
                  context: context,
                  title: plan['title'] as String,
                  price: plan['price'] as String,
                  duration: plan['duration'] as String,
                  description: plan['description'] as String,
                  icon: Image.asset(
                    plan['icon'] as String,
                    width: screenWidth * 0.02,
                  ),
                  isSelected: isSelected,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          );
        }).toList(),

        SizedBox(height: screenHeight * 0.05),

        GestureDetector(
          onTap: _selectedPlan != null ? _onGetAccessPressed : null,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
            decoration: BoxDecoration(
              color: _selectedPlan != null
                  ? const Color(0xff1E90FF)
                  : const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Get Access",
                  style: TextStyle(
                    color: _selectedPlan != null ? Colors.white : Colors.black,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Image.asset(
                  'assets/images/get_access.png',
                  width: screenWidth * 0.1,
                  color: _selectedPlan != null ? Colors.white : null,
                ),
              ],
            ),
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
    required bool isSelected,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E90FF) : const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: isSelected ? Border.all(color: Colors.white, width: 2.0) : null,
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
                        color: isSelected ? Colors.white : Colors.black,
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
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: screenWidth * 0.028,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black54,
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
                    color: isSelected ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          SizedBox(width: screenWidth * 0.06, child: icon),
          if (isSelected)
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: screenWidth * 0.05,
              ),
            ),
        ],
      ),
    );
  }
}
