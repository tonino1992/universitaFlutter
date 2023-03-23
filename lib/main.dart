import 'package:flutter/material.dart';
import 'package:universita_flutter/pages/home_page.dart';
import 'package:universita_flutter/pages/login.dart';
import 'package:universita_flutter/services/jwt_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final JwtService jwtService = JwtService();
    return MaterialApp(
      title: 'Università',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Map<String, dynamic>?>(
        future: jwtService.decodeJwt(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final exp = snapshot.data!['exp'] as int;
              final expiryDate =
                  DateTime.fromMillisecondsSinceEpoch(exp * 1000);
              if (expiryDate.isBefore(DateTime.now())) {
                jwtService.deleteJwt();
                return const LoginPage();
              }
              return const HomePage();
            } else {
              return const LoginPage();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
