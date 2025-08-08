import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/post_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';
import 'views/auth/login_page.dart';
import 'views/home/home_page.dart';
import 'views/home/main_navigation_page.dart';
import 'views/post/create_post_page.dart';
import 'models/post_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PostModelAdapter());
  Hive.registerAdapter(CommentAdapter());
  Hive.registerAdapter(ReplyAdapter());

  await Hive.openBox<PostModel>('posts');
  await Hive.openBox('settings');

  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Flutter Blog App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.login,
            routes: {
              AppRoutes.login: (context) => const LoginPage(),
              AppRoutes.home: (context) => const MainNavigationPage(),
              AppRoutes.createPost: (context) => const CreatePostPage(),
            },
          );
        },
      ),
    );
  }
}
