import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storybook/utils/ui_utils.dart';
import 'package:storybook/widgets/paywall/premium_benefit_item.dart';
import 'package:storybook/widgets/paywall/subscription_option.dart';
import 'package:storybook/widgets/paywall/text_link.dart';

class PremiumPaywallDialog {
  static void show() {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/gambar1.png', // Use an existing image or replace with your own
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.5),
                  colorBlendMode: BlendMode.darken,
                ),
              ),

              // Close button
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 30),
                  ),
                ),
              ),

              // Content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Header and award badge
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: Colors.amber,
                            size: 40,
                          ),
                          SizedBox(width: 16),
                          Text(
                            "Premium Stories",
                            style: TextStyle(
                              fontFamily: 'Baloo',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Benefits
                      ..._buildPremiumBenefits(),

                      const SizedBox(height: 40),

                      // Pricing options
                      const Text(
                        "Choose Your Plan",
                        style: TextStyle(
                          fontFamily: 'Baloo',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 3, offset: Offset(1, 1)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Subscription options
                      Row(
                        children: [
                          Expanded(
                            child: SubscriptionOption(
                              title: "Monthly",
                              price: "Rp 79.000",
                              perPeriod: "per month",
                              isPopular: false,
                              onTap: () => _processPurchase("monthly"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SubscriptionOption(
                              title: "Annual",
                              price: "Rp 699.000",
                              perPeriod: "per year",
                              originalPrice: "Rp 948.000",
                              discount: "25% OFF",
                              isPopular: true,
                              onTap: () => _processPurchase("annual"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Free trial button
                      ElevatedButton(
                        onPressed: () => _processPurchase("trial"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 10),
                            Text(
                              "Try 3 Days Free",
                              style: TextStyle(
                                fontFamily: 'Baloo',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Terms and conditions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextLink(
                            text: "Terms of Use",
                            onTap: () => UiUtils.showComingSoonMessage("Terms of use"),
                          ),
                          const SizedBox(width: 20),
                          TextLink(
                            text: "Restore Purchases",
                            onTap: () => UiUtils.showComingSoonMessage("Restore purchases"),
                          ),
                          const SizedBox(width: 20),
                          TextLink(
                            text: "Privacy Policy",
                            onTap: () => UiUtils.showComingSoonMessage("Privacy policy"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Social proof
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              color: Colors.amber,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Trusted by 1,209 happy families",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<Widget> _buildPremiumBenefits() {
    final benefits = [
      "Unlimited access to all premium stories",
      "New stories added every month",
      "Educational content with valuable lessons",
      "Ad-free reading experience",
      "Personalized reading recommendations",
    ];

    return benefits.map((benefit) =>
        PremiumBenefitItem(text: benefit)
    ).toList();
  }

  static void _processPurchase(String plan) {
    Get.back();
    UiUtils.showSuccessMessage(
      'Subscription Processing',
      'Processing $plan subscription...',
    );
  }
}