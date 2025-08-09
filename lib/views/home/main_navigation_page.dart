import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_page.dart';
import '../home/home_page.dart';
import '../post/archive_page.dart';
import '../settings/profilePage_page.dart';

import '../post/create_post_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(), // Public posts
    ArchivesPage(), // Private posts saved by user
    ProfilePage(), // User profile
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? "Blog Posts"
              : _selectedIndex == 1
                  ? "Archives"
                  : "Profile",
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          if (_selectedIndex == 2) // Only show logout in Profile tab
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archives"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: _selectedIndex != 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostPage()),
                );
              },
              child: const Icon(Icons.add),
              tooltip: "Create Post",
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}
