// widgets/user_info.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
          child: user.image == null ? const Icon(Icons.person) : null,
        ),
        const SizedBox(width: 8.0),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}