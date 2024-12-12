import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/authentication.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Uint8List? _profileImage;
  String _selectedDepartment = "";
  String _errorMessage = "";
  final NavigateController _navigateController = NavigateController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImage = imageBytes;
      });
    }
  }

  Future<void> _submitProfile() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty || _selectedDepartment.isEmpty) {
      setState(() {
        _errorMessage = "Vui lòng điền đầy đủ thông tin!";
      });
      return;
    }

    if (!RegExp(r"^\d{10,11}$").hasMatch(phone)) {
      setState(() {
        _errorMessage = "Số điện thoại không hợp lệ!";
      });
      return;
    }

    // Lưu thông tin vào Firebase Firestore
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'department': _selectedDepartment,
          'profileImage': _profileImage,
        });

        setState(() {
          _errorMessage = "";
        });

        // Điều hướng đến HomePage sử dụng NavigateController
        _navigateController.navigateToHomePage(context);
      } else {
        setState(() {
          _errorMessage = "Không thể xác thực người dùng!";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Đã xảy ra lỗi: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Hoàn thiện thông tin cá nhân"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null ? MemoryImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey,
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Họ và tên",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedDepartment.isEmpty ? null : _selectedDepartment,
              items: const [
                DropdownMenuItem(value: "Bộ phận phục vụ", child: Text("Bộ phận phục vụ")),
                DropdownMenuItem(value: "Bộ phận pha chế", child: Text("Bộ phận pha chế")),
                DropdownMenuItem(value: "Bộ phận bếp bánh", child: Text("Bộ phận bếp bánh")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value ?? "";
                });
              },
              decoration: InputDecoration(
                labelText: "Chọn bộ phận",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF166FB1),
                ),
                child: const Text("Hoàn tất"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
