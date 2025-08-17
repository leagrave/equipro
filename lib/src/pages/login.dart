import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class MyLoginPage extends StatefulWidget {
  final http.Client? httpClient;

    MyLoginPage({this.httpClient});

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    
    });


  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    setState(() {
      _errorMessage = "Email et mot de passe requis";
      _isLoading = false;
    });
    return;
  }


  try {

    final client = widget.httpClient ?? http.Client();


    final response = await client.post(
      Uri.parse('${Constants.apiBaseUrl}/login'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = data['user'];

      await storage.write(key: 'authToken', value: token);
      await storage.write(key: 'userData', value: jsonEncode(user));
      await storage.write(key: 'lastEmail', value: email);

      if (user['pro_id'] != null) {
        await storage.write(key: 'pro_id', value: user['pro_id']);
      }
      if (user['id'] != null) {
        await storage.write(key: 'user_id', value: user['id'].toString());
      }
      if (user['first_name'] != null) {
        await storage.write(key: 'first_name', value: user['first_name'].toString());
      }
      if (user['last_name'] != null) {
        await storage.write(key: 'last_name', value: user['last_name'].toString());
      }

      context.go('/', extra: {
        'initialPageIndex': 2,
      });
    } else {
      final errorData = jsonDecode(response.body);
      setState(() {
        _errorMessage = errorData['error'] ?? "Erreur lors de la connexion";
      });
      print("_errorMessage set to: $_errorMessage");
    }
  } catch (e) {
    setState(() {
      _errorMessage = "Erreur réseau ou serveur";
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _loadSavedEmail() async {
    String? savedEmail = await storage.read(key: 'lastEmail');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: Constants.gradientLoginBackground,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(Constants.logo),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenue sur EquiPro',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Connectez-vous à votre compte',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    key: Key('emailField'), 
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      hintText: 'Adresse e-mail',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    key: Key('passwordField'),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      hintText: 'Mot de passe',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      key: Key('errorMessage'),
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    key: Key('loginButton'),
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF28313E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF28313E),
                          )
                        : const Text(
                            'Se connecter',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print('Mot de passe oublié ?');
                    },
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Pas encore inscrit ? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/signup');
                        },
                        child: const Text(
                          'Créer un compte',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}