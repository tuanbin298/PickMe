import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatefulWidget {
  final double height;
  final File? initialImage;
  final ValueChanged<File> onImageSelected; //Callback

  const ImagePickerField({
    super.key,
    this.height = 200,
    this.initialImage,
    required this.onImageSelected,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  // Variable to store image, if dont have image = null
  File? _selectedImage;

  // Object to get image from gallery
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  // Method get image
  Future<void> _pickImage() async {
    // Open gallery
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    // Assign image path to _coverImage
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Call outside
      widget.onImageSelected(File(pickedFile.path));
    }
  }

  // Method delete image
  void _deleteImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: _selectedImage == null
          ? InkWell(
              onTap: _pickImage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // UI when dont have photo
                children: const [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey),

                  SizedBox(height: 8),

                  Text("Thêm ảnh", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Stack(
              children: [
                // UI when have photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    height: widget.height,
                    fit: BoxFit.cover,
                  ),
                ),

                // Edit btn
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Delete btn
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: InkWell(
                    onTap: _deleteImage,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
