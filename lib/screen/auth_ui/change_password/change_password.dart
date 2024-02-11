import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class PasswordResetScreen extends StatefulWidget {
  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AppProvider>(context);

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
            "Reset Password",
            style:TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
        ),
      ),
      body: ListView(

        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
         const SizedBox(height: 36.0),
          TextFormField(
            controller: _emailController,
            obscureText: isShowPassword,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon:  Icon(
                Icons.email_outlined,
              ),
            ),
          ),
          const SizedBox(height:36.0),
          ElevatedButton(
            onPressed: () {
              final email = _emailController.text.trim();
              if (email.isNotEmpty) {
                // authProvider.forgotPassword(email);
              }
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }
}
