import 'package:flutter/material.dart';
import 'package:universita_flutter/services/jwt_service.dart';

class HomeBody extends StatefulWidget {
  final ValueChanged<String> onScreenSelected;

  const HomeBody({
    Key? key,
    required this.onScreenSelected,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  JwtService jwtService = JwtService();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.blueGrey.shade800,
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
            future: jwtService.decodeJwt(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          "Benvenuto ${snapshot.data!['name']} ${snapshot.data!['surname']}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final decodedToken =
                                    await jwtService.decodeJwt();
                                final role = decodedToken!['role'] as String;
                                if (role == 'TEACHER') {
                                  widget.onScreenSelected('teacherCourses');
                                } else {
                                  widget.onScreenSelected('studentCourses');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueGrey.shade800,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                textStyle: const TextStyle(fontSize: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('I miei corsi'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final decodedToken =
                                    await jwtService.decodeJwt();
                                final role = decodedToken!['role'] as String;
                                if (role == 'TEACHER') {
                                  widget.onScreenSelected('teacherExams');
                                } else {
                                  widget.onScreenSelected('studentExamsToDo');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueGrey.shade800,
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                textStyle: const TextStyle(fontSize: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('I miei esami'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
