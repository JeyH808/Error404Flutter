import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/BottomNavBarWidget.dart';
import '../widgets/GridHomePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 10) {
      return 'Chào buổi sáng';
    } else if (hour < 13) {
      return 'Chào buổi trưa';
    } else if (hour < 18) {
      return 'Chào buổi chiều';
    } else {
      return 'Chào buổi tối';
    }
  }

  LinearGradient _getGradient() {
    final hour = DateTime.now().hour;
    if (hour < 10) {
      return const LinearGradient(
        colors: [
          Color(0xFF87CEEB),
          Color(0xFF4682B4),
          Color(0xFF1E90FF),
          Color(0xFF4169E1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (hour < 13) {
      return const LinearGradient(
        colors: [
          Color(0xFFFF8C00),
          Color(0xFFFFA500),
          Color(0xFFFF8C00),
          Color(0xFFFF4500),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (hour < 18) {
      return const LinearGradient(
        colors: [
          Color(0xFF6A5ACD),
          Color(0xFF7B68EE),
          Color(0xFF8470FF),
          Color(0xFF4169E1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [
          Color(0xFF220E53),
          Color(0xFF403883),
          Color(0xFF4D4898),
          Color(0xFF3A335F),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đặt chế độ toàn màn hình ngay khi khởi chạy
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: _getBackgroundColor(), // Màu nền thay đổi theo thời gian
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < 0) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              } else if (details.delta.dy > 0) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
              }
            },
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser?.uid) // Sử dụng UID của tài khoản đang đăng nhập
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text(
                      'Không tìm thấy dữ liệu người dùng',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  children: [
                    // Phần trên với nền gradient và nội dung
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: _getGradient(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: userData['profileImage'] != null
                                      ? MemoryImage(
                                    Uint8List.fromList(
                                        List<int>.from(userData['profileImage'])),
                                  )
                                      : const AssetImage('lib/img/avt1.jpg') as ImageProvider,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData['name'] ?? 'Không có tên',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        userData['department'] ?? 'Không có bộ phận',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Center(
                              child: Text(
                                'Chúc bạn một ngày làm việc hiệu quả',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Phần giữa với các hộp tuý chọn
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 16, // Giảm khoảng cách phía trên
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          // Thêm nút chấm công vào đây
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6C4CF7),
                                  Color(0xFF3D54D6),
                                  Color(0xFF115EAD),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage('lib/img/click.png'),
                                    backgroundColor: Color(0xFFFFFFF),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chấm công',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Để bắt đầu công việc thôi nào!',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Thêm khoảng cách dưới nút
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            shrinkWrap: true,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: [
                              GridItem(
                                icon: Icons.calendar_today,
                                title: 'Lịch làm việc',
                                subtitle: 'Ca làm việc và thay ca',
                                onTap: () {},
                              ),
                              GridItem(
                                icon: Icons.beach_access,
                                title: 'Đăng ký nghỉ',
                                subtitle: 'Nghỉ ngày, nghỉ ca',
                                onTap: () {},
                              ),
                              GridItem(
                                icon: Icons.access_time,
                                title: 'Số giờ làm việc',
                                subtitle: '89 giờ',
                                onTap: () {},
                              ),
                              GridItem(
                                icon: Icons.announcement,
                                title: 'Bảng tin',
                                subtitle: '0 tin tức',
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Công việc cần làm',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Xem lịch sử'),
                              ),
                            ],
                          ),
                          const Center(
                            child: Text(
                              'Không có công việc cần làm',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(currentIndex: 0),
    );
  }
}

Color _getBackgroundColor() {
  final hour = DateTime.now().hour;
  if (hour < 10) {
    return const Color(0xFF4169E1); // Màu sáng cho buổi sáng
  } else if (hour < 13) {
    return const Color(0xFFFF4700); // Màu vàng cho buổi trưa
  } else if (hour < 18) {
    return const Color(0xFF4169E1); // Màu tím cho buổi chiều
  } else {
    return const Color(0xFF3A335F); // Màu tối cho buổi tối
  }
}