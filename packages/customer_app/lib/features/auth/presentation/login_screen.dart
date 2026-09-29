import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../packages/presentation/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.flight_takeoff, size: 40, color: AppColors.primaryNavyDark),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  _isSignUp ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'مجموعة النخبة للخدمات السياحية (LY-Elite)',
                  style: TextStyle(color: AppColors.goldLight.withOpacity(0.9), fontSize: 13),
                ),
              ),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    if (_isSignUp) ...[
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'الاسم الكامل',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف (+218)',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    if (!_isSignUp) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            if (_emailController.text.isNotEmpty) {
                              authRepo.sendPasswordResetEmail(_emailController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم إرسال رابط استعادة كلمة المرور لبريدك')),
                              );
                            }
                          },
                          child: const Text('نسيت كلمة المرور؟', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          foregroundColor: AppColors.primaryNavyDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _isLoading ? null : () async {
                          setState(() => _isLoading = true);
                          try {
                            if (_isSignUp) {
                              await authRepo.signUpWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                                fullName: _nameController.text,
                                phoneNumber: _phoneController.text,
                              );
                            } else {
                              await authRepo.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            }
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const HomeScreen()),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('خطأ: $e')),
                            );
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                        child: Text(
                          _isSignUp ? 'تسجيل حساب جديد' : 'دخول',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Google Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: AppColors.lightDividers),
                        ),
                        icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                        label: const Text('تسجيل الدخول بجوجل', style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          try {
                            await authRepo.signInWithGoogle();
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const HomeScreen()),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextButton(
                      onPressed: () => setState(() => _isSignUp = !_isSignUp),
                      child: Text(
                        _isSignUp ? 'لديك حساب بالفعل؟ سجّل دخولك' : 'ليس لديك حساب؟ أنشئ حساباً جديداً',
                        style: const TextStyle(color: AppColors.primaryNavy, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
