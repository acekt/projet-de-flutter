import 'package:flutter/material.dart';
import 'package:frontend/app/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:frontend/app/models/user.dart';

class CreatePostScreen extends StatefulWidget {
  final User user;

  const CreatePostScreen({super.key, required this.user});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.post(
        'post',
        {
          'body': _bodyController.text,
          'image': _image != null ? _image!.path : null,
        },
        token: 'YOUR_TOKEN_HERE',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du post')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: widget.user.image != null
                        ? NetworkImage(widget.user.image!)
                        : null,
                    child: widget.user.image == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Contenu du post'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un contenu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              if (_image != null)
                Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Choisir une image'),
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _createPost,
                child: const Text('Publier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}