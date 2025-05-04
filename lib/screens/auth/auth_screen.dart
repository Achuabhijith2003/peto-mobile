// import 'package:flutter/material.dart';
// import 'package:peto/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'forgot_password_screen.dart';

// enum AuthMode { signUp, signIn }

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final _formKey = GlobalKey<FormState>();
//   AuthMode _authMode = AuthMode.signIn;
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   void _switchAuthMode() {
//     setState(() {
//       _authMode =
//           _authMode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn;
//     });
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);

//       if (_authMode == AuthMode.signIn) {
//         await authProvider.signIn(
//           _emailController.text.trim(),
//           _passwordController.text,
//         );
//       } else {
//         await authProvider.signUp(
//           _emailController.text.trim(),
//           _passwordController.text,
//           _nameController.text.trim(),
//         );
//       }
//     } catch (error) {
//       String errorMessage = 'Authentication failed';

//       if (error.toString().contains('email-already-in-use')) {
//         errorMessage = 'This email is already in use';
//       } else if (error.toString().contains('invalid-email')) {
//         errorMessage = 'Invalid email address';
//       } else if (error.toString().contains('user-not-found')) {
//         errorMessage = 'User not found';
//       } else if (error.toString().contains('wrong-password')) {
//         errorMessage = 'Incorrect password';
//       } else if (error.toString().contains('weak-password')) {
//         errorMessage = 'Password is too weak';
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Theme.of(context).colorScheme.error,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.signInWithGoogle();
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Google sign-in failed: ${error.toString()}'),
//           backgroundColor: Theme.of(context).colorScheme.error,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // App logo
//                 Image.asset(
//                   'assets/images/app_logo.png',
//                   height: 100,
//                   width: 100,
//                 ),
//                 const SizedBox(height: 32),

//                 // Title
//                 Text(
//                   _authMode == AuthMode.signIn
//                       ? 'Welcome Back'
//                       : 'Create Account',
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),

//                 // Subtitle
//                 Text(
//                   _authMode == AuthMode.signIn
//                       ? 'Sign in to continue'
//                       : 'Sign up to get started',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),

//                 // Form
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       if (_authMode == AuthMode.signUp)
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: const InputDecoration(
//                             labelText: 'Full Name',
//                             border: OutlineInputBorder(),
//                             prefixIcon: Icon(Icons.person),
//                           ),
//                           textInputAction: TextInputAction.next,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your name';
//                             }
//                             return null;
//                           },
//                         ),
//                       if (_authMode == AuthMode.signUp)
//                         const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.email),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         textInputAction: TextInputAction.next,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           if (!value.contains('@')) {
//                             return 'Please enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           border: const OutlineInputBorder(),
//                           prefixIcon: const Icon(Icons.lock),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                         ),
//                         obscureText: _obscurePassword,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           if (_authMode == AuthMode.signUp &&
//                               value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Forgot password
//                 if (_authMode == AuthMode.signIn)
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (ctx) => const ForgotPasswordScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text('Forgot Password?'),
//                     ),
//                   ),

//                 // Sign in/up button
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _submit,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child:
//                       _isLoading
//                           ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                           : Text(
//                             _authMode == AuthMode.signIn
//                                 ? 'Sign In'
//                                 : 'Sign Up',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                 ),
//                 const SizedBox(height: 16),

//                 // OR divider
//                 Row(
//                   children: [
//                     Expanded(child: Divider(color: Colors.grey[400])),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         'OR',
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                     Expanded(child: Divider(color: Colors.grey[400])),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Google sign in button
//                 OutlinedButton.icon(
//                   onPressed: _isLoading ? null : _signInWithGoogle,
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     side: BorderSide(color: Colors.grey[300]!),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   icon: Image.asset(
//                     'assets/images/google_logo.png',
//                     height: 24,
//                   ),
//                   label: const Text('Continue with Google'),
//                 ),
//                 const SizedBox(height: 24),

//                 // Switch auth mode
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       _authMode == AuthMode.signIn
//                           ? 'Don\'t have an account?'
//                           : 'Already have an account?',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                     TextButton(
//                       onPressed: _switchAuthMode,
//                       child: Text(
//                         _authMode == AuthMode.signIn ? 'Sign Up' : 'Sign In',
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
