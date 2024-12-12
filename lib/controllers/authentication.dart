import 'package:error404project/views/WelcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/CompleteProfilePage.dart';
import '../views/RegisPage.dart';
import '../views/HomePage.dart';
import 'package:error404project/views/LoginPage.dart'; // Import the LoginPage

class NavigateController {
  // Điều hướng đến trang Đăng ký
  void navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  // Điều hướng đến trang Đăng nhập
  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Điều hướng trở lại trang Welcome
  void navigateToWelcome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
  // Điều hươớng tới trang Hoàn thiện thông tin
  void navigateToComplete(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CompleteProfilePage()),
          (Route<dynamic> route) => false,
    );
  }

  // Điều hướng tới trang HomePage
  void navigateToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
    );
  }
}


class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký người dùng với email và mật khẩu
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      // Thử đăng ký người dùng
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Nếu email đã tồn tại, bạn có thể xử lý như sau
        print("Email đã tồn tại");
        return null;
      } else {
        // Các lỗi khác
        print("Error during sign up: $e");
        return null;
      }
    } catch (e) {
      // Lỗi ngoài Firebase Auth
      print("Error: $e");
      return null;
    }
  }


  // Đăng nhập người dùng với email và mật khẩu
  Future<User?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error during sign in: $e");
    }
    return null;
  }

  // Đăng xuất người dùng và điều hướng đến trang WelcomePage
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();  // Gọi phương thức đăng xuất từ Firebase
    // Điều hướng đến trang WelcomePage và loại bỏ tất cả các trang trước đó trong ngăn xếp
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()), // Trang chào mừng
          (Route<dynamic> route) => false,  // Loại bỏ tất cả các trang trước đó
    );
  }



}