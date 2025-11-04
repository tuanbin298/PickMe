import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:pickme_fe_app/features/customer/services/review/review_service.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class EditReviewPage extends StatefulWidget {
  final Review review;
  final String token;

  const EditReviewPage({super.key, required this.review, required this.token});

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  late int selectedRating;
  late TextEditingController _commentController;
  late List<String> existingImageUrls;
  final List<File> _selectedImages = [];
  final _reviewService = ReviewService();

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    selectedRating = widget.review.overallRating;
    _commentController = TextEditingController(text: widget.review.comment);
    existingImageUrls = List.from(widget.review.imageUrls ?? []);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _submitEdit() async {
    setState(() => isSubmitting = true);

    final updatedReview = Review(
      id: widget.review.id,
      restaurantId: widget.review.restaurantId,
      orderId: widget.review.orderId,
      overallRating: selectedRating,
      comment: _commentController.text,
      imageUrls: existingImageUrls,
    );

    final success = await _reviewService.updateReview(
      token: widget.token,
      reviewId: widget.review.id!,
      review: updatedReview,
    );

    setState(() => isSubmitting = false);

    if (success) {
      NotificationService.showSuccess(context, "Cập nhật đánh giá thành công!");
      Navigator.pop(context, updatedReview);
    } else {
      NotificationService.showError(context, "Lỗi khi cập nhật đánh giá");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chỉnh sửa đánh giá",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRatingCard(),
            const SizedBox(height: 20),
            _buildCommentCard(),
            const SizedBox(height: 20),
            _buildImageEditCard(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
      final star = index + 1;
      return IconButton(
        icon: Icon(
          Icons.star,
          size: 40,
          color: selectedRating >= star ? Colors.amber : Colors.grey.shade300,
        ),
        onPressed: () => setState(() => selectedRating = star),
      );
    }),
  );

  Widget _buildCommentCard() => TextField(
    controller: _commentController,
    minLines: 3,
    maxLines: 5,
    decoration: InputDecoration(
      hintText: "Cập nhật cảm nhận của bạn...",
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _buildImageEditCard() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final url in existingImageUrls)
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                url,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => setState(() => existingImageUrls.remove(url)),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      for (final file in _selectedImages)
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => setState(() => _selectedImages.remove(file)),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
    ],
  );

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: isSubmitting ? null : _submitEdit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isSubmitting
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Cập nhật đánh giá",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
    ),
  );
}
