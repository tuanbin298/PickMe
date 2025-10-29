import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';

class AddonCategoryCard extends StatelessWidget {
  final String category;
  final List<AddOn> addons;
  final Map<String, Map<int, int>> selections;
  final void Function(String, int) onToggle;

  const AddonCategoryCard({
    super.key,
    required this.category,
    required this.addons,
    required this.selections,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRequired = addons.isNotEmpty && (addons.first.isRequired);
    // Build the addon category card UI
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Row(
            children: [
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Requirement badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isRequired ? Colors.red.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isRequired ? 'Bắt buộc' : 'Không bắt buộc',
                  style: TextStyle(
                    color: isRequired ? Colors.redAccent : Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade300, thickness: 1, height: 20),
          ...addons.map((addon) {
            final selected = selections[category]?[addon.id] != null ?? false;
            return InkWell(
              onTap: () => onToggle(category, addon.id),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Checkbox(
                      value: selected,
                      onChanged: (_) => onToggle(category, addon.id),
                    ),
                    Expanded(
                      child: Text(
                        '${addon.name} (${UtilsMethod.formatMoney(addon.price)})',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
