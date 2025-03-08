import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/utils/ui_utils.dart";

class PremiumPaywallDialog {
  static void show() {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => const SimplePaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}

class SimplePaywallScreen extends StatelessWidget {
  const SimplePaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if we're in landscape mode
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF23348B), // Deep indigo blue
      body: Stack(
        children: [
          // Background stars - simple and minimal
          for (int i = 0; i < 10; i++)
            Positioned(
              left: (i * 37) % MediaQuery.of(context).size.width,
              top: (i * 59) % MediaQuery.of(context).size.height,
              child: Icon(
                Icons.star,
                size: 8.0 + (i % 5),
                color: Colors.amber.withOpacity(0.5),
              ),
            ),

          // Main content with scrolling
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: isLandscape
                    ? _buildLandscapeContent(context)
                    : _buildPortraitContent(context, screenWidth),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Portrait content layout
  Widget _buildPortraitContent(BuildContext context, double screenWidth) {
    // Calculate appropriate button width
    final buttonWidth = screenWidth * 0.8;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 40),

            // Benefits
            _buildBenefits(),
            const SizedBox(height: 40),

            // Plan selection title
            _buildPlanTitle(),
            const SizedBox(height: 20),

            // Subscription options for portrait with fixed width
            Container(
              width: buttonWidth,
              child: _buildPortraitSubscriptions(),
            ),
            const SizedBox(height: 30),

            // Free trial button with fixed width
            _buildFreeTrialButton(context, buttonWidth),
            const SizedBox(height: 20),

            // Footer
            _buildLinks(context),
            const SizedBox(height: 16),
            _buildTrustBadge(),
          ],
        ),
      ),
    );
  }

  // Landscape content layout
  Widget _buildLandscapeContent(BuildContext context) {
    return Column(
      children: [
        // Header
        _buildHeader(),
        const SizedBox(height: 20),

        // Two-column layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Benefits
            Expanded(
              child: _buildBenefits(),
            ),
            const SizedBox(width: 16),

            // Right: Plans and footer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildPlanTitle(),
                  const SizedBox(height: 16),
                  _buildLandscapeSubscriptions(),
                  const SizedBox(height: 16),
                  _buildFreeTrialButton(context, null),
                  const SizedBox(height: 12),
                  _buildLinks(context),
                  const SizedBox(height: 10),
                  _buildTrustBadge(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Plan selection title
  Widget _buildPlanTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.payments_outlined, color: Colors.amber, size: 22),
        SizedBox(width: 8),
        Text(
          "Choose Your Plan",
          style: TextStyle(
            fontFamily: "Baloo",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Header with premium badge and title
  Widget _buildHeader() {
    return Column(
      children: [
        // Premium badge
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.withOpacity(0.3),
            border: Border.all(color: Colors.amber.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.workspace_premium,
            color: Colors.amber,
            size: 36,
          ),
        ),
        const SizedBox(height: 20),

        // Title
        const Text(
          "Unlock Magic Stories!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Baloo",
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          "Join thousands of families who love our magical stories",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Benefits section
  Widget _buildBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.auto_awesome, color: Colors.amber, size: 22),
            SizedBox(width: 8),
            Text(
              "Premium Benefits",
              style: TextStyle(
                fontFamily: "Baloo",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Benefits list
        _buildBenefitItem("Unlimited access to all premium stories"),
        _buildBenefitItem("New stories added every month"),
        _buildBenefitItem("Educational content with valuable lessons"),
        _buildBenefitItem("Ad-free reading experience"),
        _buildBenefitItem("Personalized reading recommendations"),
      ],
    );
  }

  // Individual benefit item
  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Portrait subscription layout
  Widget _buildPortraitSubscriptions() {
    return Container(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // The cards
          Column(
            children: [
              // Monthly card
              _buildMonthlyCard(),
              const SizedBox(height: 16),
              // Annual card
              _buildAnnualCard(),
            ],
          ),

          // BEST VALUE badge positioned between the cards
          Positioned(
            top: 85,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.shade600,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "BEST VALUE",
                style: TextStyle(
                  fontFamily: "Baloo",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Landscape subscription layout
  Widget _buildLandscapeSubscriptions() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // The cards side by side
        Row(
          children: [
            // Monthly card
            Expanded(child: _buildMonthlyCard()),
            const SizedBox(width: 12),
            // Annual card
            Expanded(child: _buildAnnualCard()),
          ],
        ),

        // BEST VALUE badge
        Positioned(
          top: -10,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.amber.shade600,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              "BEST VALUE",
              style: TextStyle(
                fontFamily: "Baloo",
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Monthly subscription card
  Widget _buildMonthlyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Monthly",
            style: TextStyle(
              fontFamily: "Baloo",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Rp 79.000",
            style: TextStyle(
              fontFamily: "Baloo",
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "per month",
            style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Annual subscription card with discount badge
  Widget _buildAnnualCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                "Annual",
                style: TextStyle(
                  fontFamily: "Baloo",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Rp 699.000",
                style: TextStyle(
                  fontFamily: "Baloo",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "per year",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Rp 948.000",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),

        // Discount badge
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: const Text(
              "25% OFF",
              style: TextStyle(
                fontFamily: "Baloo",
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Free trial button
  Widget _buildFreeTrialButton(BuildContext context, double? customWidth) {
    return SizedBox(
      width: customWidth ?? double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          UiUtils.showSuccessMessage(
            "Thank You!",
            "Your trial subscription is being processed.",
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle_outline, size: 20),
            SizedBox(width: 8),
            Text(
              "Try 3 Days Free",
              style: TextStyle(
                fontFamily: "Baloo",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Links row
  Widget _buildLinks(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLink(context, "Terms of Use"),
        const SizedBox(width: 20),
        _buildLink(context, "Restore Purchases"),
        const SizedBox(width: 20),
        _buildLink(context, "Privacy Policy"),
      ],
    );
  }

  // Individual link
  Widget _buildLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () => UiUtils.showComingSoonMessage(text),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Nunito",
          fontSize: 14,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // Trust badge
  Widget _buildTrustBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.verified,
            color: Colors.amber,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            "Trusted by 1,209 happy families",
            style: TextStyle(
              fontFamily: "Nunito",
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}