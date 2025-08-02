import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/post_provider.dart';
import 'routes/app_routes.dart';
import 'providers/auth_provider.dart';
import 'views/auth/login_page.dart';
import 'views/home/home_page.dart';
import 'views/post/create_post_page.dart';

void main() {
  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        // Add other providers here (e.g., PostProvider)
      ],
      child: MaterialApp(
        title: 'Flutter Blog App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.createPost: (context) => const CreatePostPage(),
        },
      ),
    );
  }
}
