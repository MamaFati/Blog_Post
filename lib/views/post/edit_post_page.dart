import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/post_provider.dart';
import '../../models/post_model.dart';

class EditPostPage extends StatefulWidget {
  final PostModel post;
  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  late bool _isPublic;
  String? _selectedFilePath;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content);
    _isPublic = widget.post.isPublic;
    _selectedFilePath = widget.post.filePath;
  }

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

  void _updatePost() {
    if (_formKey.currentState!.validate()) {
      Provider.of<PostProvider>(context, listen: false).updatePost(
        widget.post.id,
        _contentController.text.trim(),
        newFilePath: _selectedFilePath,
        isPublic: _isPublic,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isImage = _selectedFilePath != null &&
        (_selectedFilePath!.endsWith('.jpg') ||
            _selectedFilePath!.endsWith('.png'));

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Change File"),
                ),
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: 10),
                  isImage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_selectedFilePath!),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          "📎 ${_selectedFilePath!.split('/').last}",
                          style: const TextStyle(fontSize: 14),
                        ),
                ],
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updatePost,
                    child: const Text("Update Post"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
