// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'face_evaluate.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   bool _isLoading = false;
//
//   Future<User?> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // 구글 로그인
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         // 로그인 취소
//         setState(() {
//           _isLoading = false;
//         });
//         return null;
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       // Firebase로 인증
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(credential);
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       return userCredential.user;
//     } catch (e) {
//       print('Google Sign-In Error: $e');
//       setState(() {
//         _isLoading = false;
//       });
//       return null;
//     }
//   }
//
//   void _login() async {
//     final user = await _signInWithGoogle();
//     if (user != null) {
//       // 로그인 성공 시 메인 화면으로 이동
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ImageUploadPage()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue.shade300, Colors.purple.shade300],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Google 로그인',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     GestureDetector(
//                       onTap: _login,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.pinkAccent, Colors.orangeAccent],
//                           ),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         padding: EdgeInsets.all(16),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.login, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               'Google 계정으로 로그인',
//                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (_isLoading)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16.0),
//                         child: CircularProgressIndicator(),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
