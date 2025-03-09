import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/app/screens/auth/login_screen.dart';
import 'package:frontend/app/screens/auth/register_screen.dart';
import 'package:frontend/app/screens/home_screen.dart';
import 'package:frontend/app/screens/create_post_screen.dart';
import 'package:frontend/app/screens/post_detail_screen.dart';
import 'package:frontend/app/screens/user_profile_screen.dart';
import 'package:frontend/app/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
          return HomeScreen(
            user: args['user'] as User,
            token: args['token'] as String,
          );
        },
        '/create-post': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          if (args == null || args['user'] == null || args['token'] == null) {
            return const LoginScreen();
          }
          return CreatePostScreen(
            user: args['user'] as User,
            token: args['token'] as String,
          );
        },
        '/post-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          if (args == null || args['postId'] == null || args['token'] == null) {
            return const LoginScreen();
          }
          return PostDetailScreen(
            postId: args['postId'] as int,
            token: args['token'] as String,
          );
        },
        '/user-profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          if (args == null || args['userId'] == null || args['token'] == null) {
            return const LoginScreen();
          }
          return UserProfileScreen(
            userId: args['userId'] as int,
            token: args['token'] as String,
          );
        },
      },
    );
  }
}