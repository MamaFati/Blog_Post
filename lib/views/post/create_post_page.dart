import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/post_provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isPublic = true;
  String? _selectedFilePath;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> emojis = ["😊", "🚀", "📸", "🎉", "💬", "❤️"];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _contentController.dispose();
    super.dispose();
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Provider.of<PostProvider>(context, listen: false).addPost(
        content: _contentController.text.trim(),
        filePath: _selectedFilePath,
        author: "Fati",
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
      appBar: AppBar(
        title: const Text("Create Post"),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Floating Emojis Background
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final random = Random();
                  return Stack(
                    children: List.generate(15, (index) {
                      final emoji = emojis[random.nextInt(emojis.length)];
                      final top = random.nextDouble() *
                          MediaQuery.of(context).size.height;
                      final left = random.nextDouble() *
                          MediaQuery.of(context).size.width;
                      final opacity = (random.nextDouble() * 0.5) + 0.3;

                      return Positioned(
                        top: top,
                        left: left,
                        child: Opacity(
                          opacity: opacity,
                          child: Text(
                            emoji,
                            style: TextStyle(
                              fontSize: random.nextDouble() * 30 + 20,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),

          // Form
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text Field
                        TextFormField(
                          controller: _contentController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: "What's on your mind?",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? "Post content cannot be empty"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // File Picker Button
                        ElevatedButton.icon(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.attach_file),
                          label: const Text("Attach File"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        // File Preview
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _selectedFilePath != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: isImage
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 16),

                        // Visibility Toggle
                        Row(
                          children: [
                            const Text("Visibility: "),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text("Public"),
                              selected: _isPublic,
                              onSelected: (val) {
                                setState(() => _isPublic = true);
                              },
                              avatar: const Icon(Icons.public),
                            ),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text("Private"),
                              selected: !_isPublic,
                              onSelected: (val) {
                                setState(() => _isPublic = false);
                              },
                              avatar: const Icon(Icons.lock),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Post Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Post"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
