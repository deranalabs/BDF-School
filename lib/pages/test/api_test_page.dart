import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String _result = 'Test results will appear here...';
  bool _isLoading = false;

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing login...';
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        body: jsonEncode({'username': 'admin', 'password': 'admin123'}),
        headers: {'Content-Type': 'application/json'},
      );

      setState(() {
        _result = 'Login Response:\n'
            'Status: ${response.statusCode}\n'
            'Body: ${response.body}';
      });
    } catch (e) {
      setState(() {
        _result = 'Login Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testVerify() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing token verification...';
    });

    try {
      // First get a token
      final loginResponse = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        body: jsonEncode({'username': 'admin', 'password': 'admin123'}),
        headers: {'Content-Type': 'application/json'},
      );

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(loginResponse.body);
        final token = loginData['token'];

        // Now verify the token
        final verifyResponse = await http.get(
          Uri.parse('http://localhost:3000/api/auth/verify'),
          headers: {'Authorization': 'Bearer $token'},
        );

        setState(() {
          _result = 'Token Verification Response:\n'
              'Status: ${verifyResponse.statusCode}\n'
              'Body: ${verifyResponse.body}';
        });
      } else {
        setState(() {
          _result = 'Failed to get token for verification';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Verification Error: $e';
      });
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
        title: const Text('API Integration Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testLogin,
                    child: const Text('Test Login'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testVerify,
                    child: const Text('Test Verify'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _result,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
