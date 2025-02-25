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
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main content container
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with badge
                        const _PaywallHeader(),

                        const SizedBox(height: 30),

                        // Benefits section
                        _buildBenefitsSection(),

                        const SizedBox(height: 30),

                        // Subscription options
                        _buildSubscriptionOptions(),

                        const SizedBox(height: 24),

                        // Free trial button
                        _buildFreeTrialButton(),

                        const SizedBox(height: 24),

                        // Terms and policy links
                        _buildTermsAndPolicyLinks(),

                        const SizedBox(height: 20),

                        // Social proof badge
                        _buildSocialProofBadge(),
                      ],
                    ),
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // Benefits section with cute star icons
  static Widget _buildBenefitsSection() {
    final benefits = [
      "Unlimited access to all premium stories",
      "New stories added every month",
      "Educational content with valuable lessons",
      "Ad-free reading experience",
      "Personalized reading recommendations",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "✨ Premium Benefits",
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...benefits.map((benefit) => PremiumBenefitItem(text: benefit)),
      ],
    );
  }

  // Subscription options with proper alignment
  static Widget _buildSubscriptionOptions() {
    return Column(
      children: [
        const Text(
          "Choose Your Plan",
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
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
      ],
    );
  }

  // Free trial button with cute animation
  static Widget _buildFreeTrialButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _processPurchase("trial"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }

  // Terms and policy links with better spacing
  static Widget _buildTermsAndPolicyLinks() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      children: [
        TextLink(
          text: "Terms of Use",
          onTap: () => UiUtils.showComingSoonMessage("Terms of use"),
        ),
        TextLink(
          text: "Restore Purchases",
          onTap: () => UiUtils.showComingSoonMessage("Restore purchases"),
        ),
        TextLink(
          text: "Privacy Policy",
          onTap: () => UiUtils.showComingSoonMessage("Privacy policy"),
        ),
      ],
    );
  }

  // Social proof badge with cute animation
  static Widget _buildSocialProofBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
            size: 20,
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
    );
  }

  static void _processPurchase(String plan) {
    Get.back();
    UiUtils.showSuccessMessage(
      'Thank You!',
      'Your $plan subscription is being processed.',
    );
  }
}

// Separate header widget for cleaner code
class _PaywallHeader extends StatelessWidget {
  const _PaywallHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Premium icon with sparkles
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.workspace_premium,
            color: Colors.amber,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        // Fun premium title
        const Text(
          "Unlock Magic Stories!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle with friendly message
        Text(
          "Join thousands of families who love our magical stories",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}