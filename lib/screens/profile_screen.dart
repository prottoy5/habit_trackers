import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final heightC = TextEditingController();
  final dobC = TextEditingController();
  final passC = TextEditingController();

  String? gender;
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameC.dispose();
    heightC.dispose();
    dobC.dispose();
    passC.dispose();
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
    final pp = context.watch<ProfileProvider>();
    final auth = context.watch<AuthProvider>();
    final p = pp.profile;

    if (p == null) return const Center(child: CircularProgressIndicator());

    // Prefill values
    nameC.text = p.displayName;
    gender = p.gender;
    heightC.text = p.heightCm?.toString() ?? '';
    dobC.text = (p.dob != null) ? DateFormat('dd MMM yyyy').format(p.dob!) : '';

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
        appBar: AppBar(title: const Text('Profile')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name
                        TextFormField(
                          controller: nameC,
                          decoration: fieldDecoration(icon: Icons.person, hint: 'Enter your name'),
                          style: const TextStyle(color: Colors.white),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 8),

                        // Email (read-only)
                        TextFormField(
                          initialValue: p.email,
                          readOnly: true,
                          decoration: fieldDecoration(icon: Icons.email, hint: 'Email'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),

                        // Gender
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
                        const SizedBox(height: 8),

                        // Height
                        TextFormField(
                          controller: heightC,
                          keyboardType: TextInputType.number,
                          decoration: fieldDecoration(icon: Icons.height, hint: 'Enter your height'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),

                        // Date of Birth
                        TextFormField(
                          controller: dobC,
                          readOnly: true,
                          decoration: fieldDecoration(icon: Icons.cake, hint: 'Select your birth date'),
                          style: const TextStyle(color: Colors.white),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: p.dob ?? DateTime(2000, 1, 1),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                dobC.text = DateFormat('dd MMM yyyy').format(picked);
                                p.dob = picked;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 8),

                        // Password
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
                            if (v == null || v.isEmpty) return null;
                            if (v.length < 8) return 'Password must be at least 8 characters';
                            if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include at least one uppercase letter';
                            if (!RegExp(r'[a-z]').hasMatch(v)) return 'Include at least one lowercase letter';
                            if (!RegExp(r'\d').hasMatch(v)) return 'Include at least one number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Save Button
                        FilledButton(
                          style: filledButtonStyle(),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            p.displayName = nameC.text.trim();
                            p.gender = gender;
                            p.heightCm = double.tryParse(heightC.text);

                            if (dobC.text.isNotEmpty) {
                              try {
                                p.dob = DateFormat('dd MMM yyyy').parse(dobC.text);
                              } catch (_) {
                                p.dob = null;
                              }
                            } else {
                              p.dob = null;
                            }

                            await context.read<ProfileProvider>().save(p);
                            final profileError = context.read<ProfileProvider>().error;
                            if (profileError != null) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $profileError')),
                                );
                              }
                              return;
                            }

                            if (passC.text.isNotEmpty) {
                              await context.read<AuthProvider>().updatePassword(passC.text);
                              final passError = context.read<AuthProvider>().error;
                              if (passError != null) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Password Error: $passError')),
                                  );
                                }
                                return;
                              }
                              passC.clear();
                            }

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile updated')),
                              );
                            }
                          },
                          child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
