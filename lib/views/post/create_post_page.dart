import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/post_provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isPublic = true;

  String? _selectedFilePath;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final content = _contentController.text.trim();
      Provider.of<PostProvider>(context, listen: false).addPost(
        content: content,
        filePath: _selectedFilePath,
// Simulated — we'll skip file handling for now
        author: "user@example.com",
        isPublic: _isPublic,
      );
      Navigator.pop(context); // go back to Home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Post Content",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Post content cannot be empty" : null,
              ),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text("Attach File"),
              ),
              if (_selectedFilePath != null)
                Text("Selected: ${_selectedFilePath!.split('/').last}"),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Visibility: "),
                  DropdownButton<bool>(
                    value: _isPublic,
                    items: const [
                      DropdownMenuItem(value: true, child: Text("Public")),
                      DropdownMenuItem(value: false, child: Text("Private")),
                    ],
                    onChanged: (value) {
                      setState(() => _isPublic = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
