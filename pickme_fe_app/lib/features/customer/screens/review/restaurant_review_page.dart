import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:pickme_fe_app/features/customer/services/review/review_service.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
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

  bool isSubmitting = false;
  bool isLoading = true;
  Review? existingReview;

  @override
  void initState() {
    super.initState();
    _fetchExistingReview();
  }

  // Method load feedback
  Future<void> _fetchExistingReview() async {
    final reviews = await _reviewService.getRestaurantReviewsByRestaurantId(
      token: widget.token,
      restaurantId: widget.restaurantId,
    );

    final userReview = reviews.isNotEmpty ? reviews.first : null;

    setState(() {
      existingReview = userReview;
      isLoading = false;
    });
  }

  // Load image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  // Subtmit feedback
  Future<void> _submitReview() async {
    if (selectedRating == 0) {
      NotificationService.showError(
        context,
        "Vui lòng chọn số sao để đánh giá",
      );
      return;
    }

    setState(() => isSubmitting = true);

    final review = Review(
      orderId: widget.orderId,
      restaurantId: widget.restaurantId,
      overallRating: selectedRating,
      comment: _commentController.text,
      imageUrls: [],
    );

    final success = await _reviewService.addRestaurantReview(
      token: widget.token,
      review: review,
    );

    setState(() => isSubmitting = false);

    if (success) {
      NotificationService.showSuccess(context, 'Đánh giá thành công!');
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) context.go('/home-page');
    } else {
      NotificationService.showError(context, 'Gửi đánh giá thất bại!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If there’s already a review → display it with the edit button
    if (existingReview != null) {
      final formattedDate = existingReview?.createdAt != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(existingReview!.createdAt!)
          : '—';

      return Scaffold(
        backgroundColor: AppColors.background,
        // Appbar
        appBar: AppBar(
          title: const Text(
            "Đánh giá của bạn",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Restaurant information
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.restaurantImage.isNotEmpty
                              ? widget.restaurantImage
                              : 'https://via.placeholder.com/150',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            size: 70,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurantName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(5, (i) {
                                final star = i + 1;
                                return Icon(
                                  Icons.star,
                                  color:
                                      star <=
                                          (existingReview?.overallRating ?? 0)
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                                  size: 22,
                                );
                              }),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Đánh giá vào: $formattedDate',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Comment
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nhận xét của bạn",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        existingReview?.comment ?? 'Không có bình luận.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Button update
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "Chỉnh sửa đánh giá",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantReviewPage(
                          restaurantId: widget.restaurantId,
                          orderId: widget.orderId,
                          restaurantName: widget.restaurantName,
                          restaurantImage: widget.restaurantImage,
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If no review yet → display the review form as usual
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
