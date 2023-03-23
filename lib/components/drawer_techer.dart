import 'package:flutter/material.dart';
import 'package:universita_flutter/services/jwt_service.dart';

import '../main.dart';

class DrawerTeacher extends StatelessWidget {
  final ValueChanged<String> onScreenSelected;

  const DrawerTeacher({
    Key? key,
    required this.onScreenSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: JwtService().decodeJwt(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final name = snapshot.data!['name'] as String;
                    final surname = snapshot.data!['surname'] as String;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$name $surname',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('Name and Surname not available');
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              onScreenSelected('home');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('I miei corsi'),
            onTap: () {
              onScreenSelected('teacherCourses');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('I miei esami'),
            onTap: () {
              onScreenSelected('teacherExams');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await JwtService().deleteJwt();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            },
          ),
        ],
      ),
    );
  }
}
