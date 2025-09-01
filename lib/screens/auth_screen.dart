import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool agree = false;
  bool remember = true;

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  String? gender;
  final heightC = TextEditingController();
  final dobC = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    heightC.dispose();
    dobC.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration({required IconData icon, required String hint}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.purple),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[900],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.purple, width: 2),
      ),
    );
  }

  ButtonStyle filledButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.purple),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevation: MaterialStateProperty.all(4),
    );
  }

  CheckboxThemeData checkboxTheme() {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) return Colors.purple;
        return Colors.grey;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Theme(
      data: ThemeData.dark().copyWith(
        checkboxTheme: checkboxTheme(),
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('HabitZen')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isLogin ? 'Login' : 'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 12),

                      if (!isLogin)
                        TextFormField(
                          controller: nameC,
                          decoration: fieldDecoration(icon: Icons.person, hint: 'Enter your name'),
                          style: const TextStyle(color: Colors.white),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                        ),
                      if (!isLogin) const SizedBox(height: 8),

                      TextFormField(
                        controller: emailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: fieldDecoration(icon: Icons.email, hint: 'Enter your email'),
                        style: const TextStyle(color: Colors.white),
                        validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: passC,
                        obscureText: _obscurePassword,
                        decoration: fieldDecoration(icon: Icons.lock, hint: 'Create a strong password').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.purple),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter a password';
                          if (!isLogin) {
                            if (v.length < 8) return 'Password must be at least 8 characters';
                            if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include at least one uppercase letter';
                            if (!RegExp(r'[a-z]').hasMatch(v)) return 'Include at least one lowercase letter';
                            if (!RegExp(r'\d').hasMatch(v)) return 'Include at least one number';
                          }
                          return null;
                        },
                      ),
                      if (!isLogin) const SizedBox(height: 8),

                      if (!isLogin)
                        DropdownButtonFormField<String?>(
                          value: gender,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Select gender')),
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                          ],
                          onChanged: (v) => setState(() => gender = v),
                          decoration: fieldDecoration(icon: Icons.transgender, hint: 'Select gender'),
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white),
                        ),
                      if (!isLogin) const SizedBox(height: 8),

                      if (!isLogin)
                        TextFormField(
                          controller: heightC,
                          keyboardType: TextInputType.number,
                          decoration: fieldDecoration(icon: Icons.height, hint: 'Enter your height'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      if (!isLogin) const SizedBox(height: 8),

                      if (!isLogin)
                        TextFormField(
                          controller: dobC,
                          readOnly: true,
                          decoration: fieldDecoration(icon: Icons.cake, hint: 'Select your birth date'),
                          style: const TextStyle(color: Colors.white),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000, 1, 1),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                dobC.text = DateFormat('dd MMM yyyy').format(picked);
                              });
                            }
                          },
                        ),
                      if (!isLogin) const SizedBox(height: 8),

                      if (!isLogin)
                        Row(
                          children: [
                            Checkbox(value: agree, onChanged: (v) => setState(() => agree = v ?? false)),
                            const Expanded(child: Text('I agree to the Terms & Conditions')),
                          ],
                        ),

                      Row(
                        children: [
                          Checkbox(value: remember, onChanged: (v) => setState(() => remember = v ?? true)),
                          const Text('Remember me'),
                        ],
                      ),
                      const SizedBox(height: 8),

                      FilledButton(
                        style: filledButtonStyle(),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (!isLogin && !agree) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please agree to Terms & Conditions')),
                            );
                            return;
                          }
                          final ok = isLogin
                              ? await auth.login(emailC.text.trim(), passC.text, remember: remember)
                              : await auth.register(emailC.text.trim(), passC.text);

                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(auth.error ?? 'Failed')),
                            );
                            return;
                          }

                          if (!isLogin) {
                            final user = auth.user!;
                            await context.read<ProfileProvider>().createInitial(
                              user,
                              displayName: nameC.text.trim(),
                              gender: gender,
                              heightCm: double.tryParse(heightC.text),
                              dob: dobC.text.isNotEmpty
                                  ? DateFormat('dd MMM yyyy').parse(dobC.text)
                                  : null,
                            );
                          }
                        },
                        child: Text(isLogin ? 'Login' : 'Register', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(isLogin ? 'No account? Register' : 'Have an account? Login', style: const TextStyle(color: Colors.purple)),
                      ),
                      if (auth.error != null)
                        Text(auth.error!, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
