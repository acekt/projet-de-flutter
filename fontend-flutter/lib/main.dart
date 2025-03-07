import 'package:flutter/material.dart';
import 'package:frontend/app/screens/auth/login_screen.dart';
import 'package:frontend/app/screens/auth/register_screen.dart';
import 'package:frontend/app/screens/home_screen.dart';
import 'package:frontend/app/screens/create_post_screen.dart';
import 'package:frontend/app/screens/post_detail_screen.dart';
import 'package:frontend/app/screens/user_profile_screen.dart';

import 'app/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion Flutter & Laravel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          if (args == null || args['user'] == null || args['token'] == null) {
            return const LoginScreen();
          }
          return HomeScreen(user: args['user'], token: args['token']);
        },
        '/create-post': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return CreatePostScreen(user: user);
        },
        '/post-detail': (context) {
          final postId = ModalRoute.of(context)!.settings.arguments as int;
          return PostDetailScreen(postId: postId);
        },
        '/user-profile': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as int;
          return UserProfileScreen(userId: userId);
        },
      },
    );
  }
}