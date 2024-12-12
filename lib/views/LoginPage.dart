import 'package:flutter/material.dart';
import '../controllers/authentication.dart'; // Import the authentication controller
import 'HomePage.dart'; // Trang chính sau khi đăng nhập thành công
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService authService = FirebaseAuthService();
  String? errorMessage; // Dùng để lưu thông báo lỗi

  Future<void> _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Vui lòng điền đầy đủ thông tin';
      });
      return;
    }

    try {
      User? user = await authService.signInWithEmailAndPassword(email, password);

      if (user != null) {
        // Nếu đăng nhập thành công, điều hướng đến trang HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          errorMessage = 'Tài khoản hoặc mật khẩu không chính xác';
        });
      }
    } catch (e) {
      print("Login error: $e");
      setState(() {
        errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigateController = NavigateController();

    return Scaffold(
      resizeToAvoidBottomInset: true, // Thay đổi kích thước màn hình khi bàn phím xuất hiện
      body: SingleChildScrollView( // Cho phép cuộn màn hình khi bàn phím xuất hiện
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.orange),
                  onPressed: () {
                    navigateController.navigateToWelcome(context); // Sử dụng controller để điều hướng
                  },
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0), // Thêm khoảng cách từ trên
                      child: Text(
                        'HRM',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Text(
                      'Powered by iPOS.vn',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 48), // khoảng trống để căn giữa icon và text phía bên phải
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Đăng nhập HRM Nhân Viên',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey[400]),
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
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                labelStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center( // Center align the forgot password text
              child: Text(
                'Bạn quên mật khẩu? Lấy lại mật khẩu',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Đặt chiều rộng bằng chiều rộng của container
              child: ElevatedButton(
                onPressed: _login, // Gọi hàm đăng nhập
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0), // Điều chỉnh chiều cao
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bo góc nhẹ
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF166FB1),
                ),
                child: const Text('Đăng nhập'),
              ),
            ),
            if (errorMessage != null) // Hiển thị thông báo lỗi dưới các trường nhập liệu
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}