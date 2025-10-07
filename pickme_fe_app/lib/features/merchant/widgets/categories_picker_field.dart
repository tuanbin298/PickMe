import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class CategoriesPickerField extends StatefulWidget {
  final List<String> allCategories;
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategoriesSelected;

  const CategoriesPickerField({
    super.key,
    required this.allCategories,
    required this.selectedCategories,
    required this.onCategoriesSelected,
  });

  @override
  State<CategoriesPickerField> createState() => _CategoriesPickerFieldState();
}

class _CategoriesPickerFieldState extends State<CategoriesPickerField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Label
          Row(
            children: [
              Icon(Icons.category, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                "Sản phẩm cửa hàng bán",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Dropdown categories
          MultiSelectDialogField(
            items: widget.allCategories
                .map((cate) => MultiSelectItem(cate, cate))
                .toList(),
            onConfirm: (values) {
              widget.onCategoriesSelected(values.cast<String>());
            },
            title: const Text("Danh mục"),
            selectedColor: AppColors.primary,
            initialValue: widget.selectedCategories,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),

            // Show all categories had choose by user
            chipDisplay: MultiSelectChipDisplay(
              chipColor: AppColors.primary.withOpacity(0.1),
              textStyle: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
