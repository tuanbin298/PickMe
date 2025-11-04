import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:pickme_fe_app/features/customer/services/review/review_service.dart';
import 'package:pickme_fe_app/core/common_services/upload_image_cloudinary.dart';
import 'package:go_router/go_router.dart';

class RestaurantReviewPage extends StatefulWidget {
  final int restaurantId;
  final int orderId;
  final String restaurantName;
  final String restaurantImage;
  final String token;

  const RestaurantReviewPage({
    super.key,
    required this.restaurantId,
    required this.orderId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.token,
  });

  @override
  State<RestaurantReviewPage> createState() => _RestaurantReviewPageState();
}

class _RestaurantReviewPageState extends State<RestaurantReviewPage> {
  int selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<File> _selectedImages = [];
  final _reviewService = ReviewService();

  // Create instance object of UploadImageCloudinary
  final UploadImageCloudinary _uploadImageCloudinary = UploadImageCloudinary();

  bool isSubmitting = false;

  // Pick multiple images using ImagePicker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  // Submit the restaurant review
  Future<void> _submitReview() async {
    if (selectedRating == 0) {
      NotificationService.showError(
        context,
        "Vui lòng chọn số sao để đánh giá",
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      List<String> uploadedUrls = [];
      for (var file in _selectedImages) {
        final url = await _uploadImageCloudinary.uploadImage(file);
        if (url != null) uploadedUrls.add(url);
      }

      final review = Review(
        orderId: widget.orderId,
        restaurantId: widget.restaurantId,
        overallRating: selectedRating,
        comment: _commentController.text.trim(),
        imageUrls: uploadedUrls,
      );

      final success = await _reviewService.addRestaurantReview(
        token: widget.token,
        review: review,
      );

      if (success) {
        NotificationService.showSuccess(context, "Gửi đánh giá thành công!");

        context.pop(true);
      } else {
        NotificationService.showError(
          context,
          "Gửi đánh giá thất bại. Vui lòng thử lại.",
        );
      }
    } catch (e) {
      print("Lỗi khi gửi đánh giá: $e");
      NotificationService.showError(
        context,
        "Đã xảy ra lỗi. Vui lòng thử lại.",
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Đánh giá nhà hàng",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRestaurantCard(),
            const SizedBox(height: 20),
            _buildRatingCard(),
            const SizedBox(height: 20),
            _buildCommentCard(),
            const SizedBox(height: 20),
            _buildImageUploadCard(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.restaurantImage.isNotEmpty
                  ? widget.restaurantImage
                  : 'https://via.placeholder.com/150',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.restaurantName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildRatingCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Bạn đánh giá nhà hàng này thế nào?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final star = index + 1;
              return IconButton(
                icon: Icon(
                  Icons.star,
                  size: 40,
                  color: selectedRating >= star
                      ? Colors.amber
                      : Colors.grey.shade300,
                ),
                onPressed: () => setState(() => selectedRating = star),
              );
            }),
          ),
        ],
      ),
    ),
  );

  Widget _buildCommentCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chia sẻ cảm nhận của bạn",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _commentController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Viết bình luận của bạn tại đây...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildImageUploadCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ảnh đính kèm",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_a_photo, color: AppColors.primary),
                label: const Text(
                  "Thêm ảnh",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final file in _selectedImages)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedImages.remove(file)),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: isSubmitting ? null : _submitReview,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isSubmitting
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Gửi đánh giá",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
    ),
  );
}
