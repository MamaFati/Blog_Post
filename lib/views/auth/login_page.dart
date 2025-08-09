import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/main_navigation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = false;
  bool _showPassword = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    await Future.delayed(const Duration(seconds: 1));

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.login(_emailController.text.trim());

    if (_emailController.text.trim() == "abufati876@gmail.com" &&
        _passwordController.text.trim() == "24611") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
      );
    } else {
      setState(() {
        _error = "Invalid credentials";
      });
      authProvider.logout();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor.withOpacity(0.8),
                  Colors.blue.shade900,
                ],
              ),
            ),
          ),
          // Subtle Particle Effect
          AnimatedContainer(
            duration: const Duration(seconds: 10),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Animated Logo
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 30),
                          child: Icon(
                            Icons.article_rounded,
                            size: 100,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: theme.primaryColor.withOpacity(0.5),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Error Message
                      if (_error.isNotEmpty)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _error,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Login Form
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    prefixIcon: const Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Please enter your email"
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Password
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: theme.primaryColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Please enter your password"
                                      : null,
                                ),
                                const SizedBox(height: 24),

                                // Login Button
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: _isLoading
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(Icons.login),
                                      label: Text(
                                        _isLoading ? "Logging in..." : "Login",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      onPressed:
                                          _isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        backgroundColor: theme.primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: 5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Forgot Password
                                TextButton(
                                  onPressed: () {
                                    // TODO: Implement forgot password navigation
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: theme.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign Up Link
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: TextButton.icon(
                          onPressed: () {
                            // TODO: Navigate to Sign Up page
                          },
                          icon:
                              const Icon(Icons.person_add, color: Colors.white),
                          label: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
