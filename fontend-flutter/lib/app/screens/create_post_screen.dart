import 'dart:convert'; // Ajoutez cette importation pour utiliser base64Encode
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/app/models/user.dart';
import 'package:frontend/app/services/api_service.dart';

class CreatePostScreen extends StatefulWidget {
  final User user;
  final String token;

  const CreatePostScreen({super.key, required this.user, required this.token});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _postController = TextEditingController();
  File? _image;
  String? _imageUrl; // Ajoutez cette variable pour stocker l'URL de l'image
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final imageUrl = 'data:image/png;base64,$base64Image';

      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = imageUrl; // Stockez l'URL de l'image
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
          'body': _postController.text,
          if (_imageUrl != null) 'image': _imageUrl,
        },
        token: widget.token,
      );

      if (response['post'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post créé avec succès !')),
        );
        Navigator.pop(context); // Retour à l'écran précédent
      } else {
        throw Exception('Échec de la création du post');
      }
    } catch (e) {
      print("Erreur lors de la création du post: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _createPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _postController,
                decoration: const InputDecoration(
                  labelText: 'Quoi de neuf ?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer du texte';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              if (_imageUrl != null)
                Image.network(_imageUrl!), // Utilisez Image.network pour afficher l'image
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Ajouter une image'),
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