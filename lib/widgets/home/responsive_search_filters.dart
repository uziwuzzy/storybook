import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:storybook/controllers/home_controller.dart";
import "package:storybook/config/app_colors.dart";
import "package:storybook/widgets/dialogs/premium_paywall_dialog.dart";
import "package:storybook/widgets/home/filter_section_tab.dart";
import "package:storybook/widgets/home/filter_chip_menu.dart";
import "package:storybook/utils/ui_utils.dart";

class ResponsiveSearchFilters extends StatelessWidget {
  final HomeController controller;
  final RxString activeFilterSection;

  const ResponsiveSearchFilters({
    Key? key,
    required this.controller,
    required this.activeFilterSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if we're in landscape mode
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Get screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Compact mode for landscape on phones
    final useCompactMode = isLandscape && !isTablet;

    // Create a collapsible search widget that's more compact in landscape
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: useCompactMode ? 4 : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main search bar and filter tabs container
          Container(
            padding: EdgeInsets.all(useCompactMode ? 8 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: useCompactMode
                ? _buildCompactLayout(context)
                : _buildRegularLayout(context),
          ),

          // Filter chips are shown below in compact mode
          if (useCompactMode) ... [
            const SizedBox(height: 4),
            _buildFilterChips(),
          ],
        ],
      ),
    );
  }

  // Compact layout for landscape mode
  Widget _buildCompactLayout(BuildContext context) {
    return Row(
      children: [
        // Search field (takes most of the space)
        Expanded(
          flex: 2,
          child: _buildSearchField(),
        ),

        const SizedBox(width: 8),

        // Horizontal filter tabs
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            child: _buildFilterTabs(isScrollable: true),
          ),
        ),
      ],
    );
  }

  // Regular layout for portrait mode
  Widget _buildRegularLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search field
        _buildSearchField(),

        const SizedBox(height: 12),

        // Filter section tabs
        _buildFilterTabs(isScrollable: true),

        const SizedBox(height: 12),

        // Filter chips
        _buildFilterChips(),
      ],
    );
  }

  // Shared search field widget
  Widget _buildSearchField() {
    return TextField(
      onChanged: controller.searchBooks,
      style: const TextStyle(fontFamily: "Nunito", fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: "Find a magical story...",
        hintStyle: TextStyle(
          fontFamily: "Nunito",
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.primary,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
  }

  // Shared filter tabs widget
  Widget _buildFilterTabs({required bool isScrollable}) {
    // For landscape on smaller screens, use more compact tabs
    final isLandscape = MediaQuery.of(Get.context!).orientation == Orientation.landscape;
    final isSmallDevice = MediaQuery.of(Get.context!).size.width < 600;
    final useCompactTabs = isLandscape && isSmallDevice;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => Row(
        children: [
          // Compact tabs for landscape on small devices
          if (useCompactTabs) ... [
            _buildCompactTab("Category", "Category"),
            _buildCompactTab("Age", "Age"),
            _buildCompactTab("Values", "Values"),
          ] else ... [
            // Regular tabs for portrait or tablets
            FilterSectionTab(
              label: "Category",
              isSelected: activeFilterSection.value == "Category",
              onTap: () => activeFilterSection.value = "Category",
            ),
            FilterSectionTab(
              label: "Age",
              isSelected: activeFilterSection.value == "Age",
              onTap: () => activeFilterSection.value = "Age",
            ),
            FilterSectionTab(
              label: "Values",
              isSelected: activeFilterSection.value == "Values",
              onTap: () => activeFilterSection.value = "Values",
            ),
          ],
        ],
      )),
    );
  }

  // Compact tab for landscape mode
  Widget _buildCompactTab(String label, String value) {
    return GestureDetector(
      onTap: () => activeFilterSection.value = value,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: activeFilterSection.value == value
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: activeFilterSection.value == value
                ? Colors.transparent
                : AppColors.primary,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: "Baloo",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: activeFilterSection.value == value
                ? Colors.white
                : AppColors.primary,
          ),
        ),
      ),
    );
  }

  // Shared filter chips widget
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        List<Widget> filterChips = [];

        // Add "All" option first for all filter types
        filterChips.add(
          FilterChipMenu(
            label: "All",
            isSelected: _getIsAllSelected(),
            onTap: () => _selectAll(),
            color: AppColors.primary,
          ),
        );

        // Add chips based on selected filter section
        if (activeFilterSection.value == "Category") {
          filterChips.addAll(
            ["Adventure", "Fantasy", "Animals", "Sci-Fi"].map((category) =>
                FilterChipMenu(
                  label: category,
                  isSelected: controller.selectedCategory.value == category,
                  onTap: () => controller.filterByCategory(category),
                  color: UiUtils.getCategoryColor(category),
                ),
            ),
          );
        } else if (activeFilterSection.value == "Age") {
          filterChips.addAll(
            ["3-5", "6-8", "9-12"].map((age) =>
                FilterChipMenu(
                  label: age,
                  isSelected: controller.selectedAgeRange.value == age,
                  onTap: () => controller.filterByAgeRange(age),
                  color: UiUtils.getAgeRangeColor(age),
                ),
            ),
          );
        } else if (activeFilterSection.value == "Values") {
          filterChips.addAll(
            ["Kindness", "Friendship", "Courage", "Honesty",
              "Curiosity", "Perseverance", "Wisdom", "Sharing", "Acceptance"].map((value) =>
                FilterChipMenu(
                  label: value,
                  isSelected: controller.selectedValue.value == value,
                  onTap: () => controller.filterByValue(value),
                  color: UiUtils.getValueColor(value),
                ),
            ),
          );
        }

        // Add Premium filter at the end
        filterChips.add(
          FilterChipMenu(
            label: "Premium",
            isSelected: false, // Implement premium filter if needed
            onTap: () => PremiumPaywallDialog.show(),
            color: Colors.amber,
            icon: Icons.star,
          ),
        );

        return Row(children: filterChips);
      }),
    );
  }

  // Helper to check if "All" should be selected based on active filter section
  bool _getIsAllSelected() {
    if (activeFilterSection.value == "Category") {
      return controller.selectedCategory.value == "All";
    } else if (activeFilterSection.value == "Age") {
      return controller.selectedAgeRange.value == "All";
    } else if (activeFilterSection.value == "Values") {
      return controller.selectedValue.value == "All";
    }
    return false;
  }

  // Helper to select "All" based on active filter section
  void _selectAll() {
    if (activeFilterSection.value == "Category") {
      controller.filterByCategory("All");
    } else if (activeFilterSection.value == "Age") {
      controller.filterByAgeRange("All");
    } else if (activeFilterSection.value == "Values") {
      controller.filterByValue("All");
    }
  }
}