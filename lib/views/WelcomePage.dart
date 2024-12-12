import 'package:flutter/material.dart';
import '../controllers/authentication.dart'; // Điều chỉnh lại tên package của bạn

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateController = NavigateController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(10), // Khoảng cách từ mép trên và phải
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!), // Đường viền màu xám
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_circle, color: Color(0xFFFFC013), size: 30),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_drop_down, size: 30),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'HRM',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Powered by iPOS.vn',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 120),
            const Center(
              child: Text(
                'Chào mừng bạn\nđến với iPOS HRM\ndành cho Nhân Viên',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                const Text("Bạn có tài khoản HRM Nhân Viên Chưa?"),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            navigateController.navigateToRegister(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF166FB1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Bo góc nhẹ
                            ),
                            side: const BorderSide(color: Color(0xFF166FB1)),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Đăng ký ngay'),
                        ),
                      ),
                      const SizedBox(width: 10), // Khoảng cách giữa hai nút
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            navigateController.navigateToLogin(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF166FB1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Bo góc nhẹ
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Đăng nhập'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
