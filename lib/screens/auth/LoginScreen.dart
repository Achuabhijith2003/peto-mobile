import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peto/color.dart';
import 'package:peto/image.dart';
import 'package:peto/providers/auth_provider.dart';
import 'package:peto/screens/auth/SignupScreen.dart';
import 'package:peto/screens/auth/forgot_password_screen.dart';
import 'package:peto/screens/components/button.dart';
import 'package:peto/screens/navbar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // submit the login form
    Future<void> submit() async {
      setState(() {
        _isLoading = true;
      });

      String errorMessage = "";
      print("Login button pressed");
      try {
        if (emailC.text.isEmpty || passwordC.text.isEmpty) {
          errorMessage = 'Please fill in all fields';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await authProvider.signIn(emailC.text.trim(), passwordC.text);
        if (authProvider.isAuth) {
          // Navigate to the home screen or dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const CustomNavBarCurved()),
          );
        } else {
          errorMessage = 'Authentication failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        errorMessage = 'Authentication failed';

        if (error.toString().contains('email-already-in-use')) {
          errorMessage = 'This email is already in use';
        } else if (error.toString().contains('invalid-email')) {
          errorMessage = 'Invalid email address';
        } else if (error.toString().contains('user-not-found')) {
          errorMessage = 'User not found';
        } else if (error.toString().contains('wrong-password')) {
          errorMessage = 'Incorrect password';
        } else if (error.toString().contains('weak-password')) {
          errorMessage = 'Password is too weak';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    Future<void> _signInWithGoogle() async {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.signInWithGoogle();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign-in failed: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {}
    }

    return Scaffold(
      backgroundColor: AppColor.kWhite,
      // appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
          child: SizedBox(
            width: 327,
            child: Column(
              children: [
                Image.asset(ImagesPath.kappicon, width: 327, height: 200),
                const SizedBox(height: 10),
                Text(
                  'Hi, Welcome Back! 👋',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: AppColor.kGrayscaleDark100, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'We happy to see you. Sign In to your account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite,
                  ).copyWith(color: AppColor.kGrayscale40, fontSize: 14),
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.kWhite,
                      ).copyWith(
                        color: AppColor.kGrayscaleDark100,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PrimaryTextFormField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'example@gmail.com',
                      controller: emailC,
                      width: 327,
                      height: 52,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.kWhite,
                      ).copyWith(
                        color: AppColor.kGrayscaleDark100,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PasswordTextField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'Password',
                      controller: passwordC,
                      width: 327,
                      height: 52,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryTextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      title: 'Forgot Password?',
                      textStyle: const TextStyle(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    PrimaryButton(
                      elevation: 0,
                      onTap: () {
                        _isLoading ? null : submit();
                      },
                      text: 'LogIn',
                      bgColor: AppColor.kPrimary,
                      borderRadius: 20,
                      height: 46,
                      width: 327,
                      textColor: AppColor.kWhite,
                      fontSize: 14,
                      isloading: _isLoading,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CustomRichText(
                        title: 'Don’t have an account?',
                        subtitle: ' Create here',
                        onTab: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => SignUpScreen()),
                          );
                        },
                        subtitleTextStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kWhite,
                        ).copyWith(
                          color: AppColor.kPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Column(
                    children: [
                      const DividerRow(title: 'Or Sign In with'),
                      const SizedBox(height: 20),
                      SecondaryButton(
                        height: 56,
                        textColor: AppColor.kGrayscaleDark100,
                        width: 280,
                        onTap: () {
                          _signInWithGoogle();
                        },
                        borderRadius: 24,
                        bgColor: AppColor.kBackground2,
                        text: 'Continue with Google',
                        icons: ImagesPath.kGoogleIcon,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TermsAndPrivacyText(
                    title1: '  By signing up you agree to our',
                    title2: ' Terms ',
                    title3: '  and',
                    title4: ' Conditions of Use',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
    this.color2,
    required this.title4,
  });
  final Color? color2;
  final String title1, title2, title3, title4;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.kWhite,
        ).copyWith(
          color: AppColor.kGrayscale40,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        children: [
          TextSpan(text: title1),
          TextSpan(
            text: title2,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.kWhite,
            ).copyWith(
              color: color2 ?? AppColor.kGrayscaleDark100,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: title3,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.kWhite,
            ).copyWith(
              color: AppColor.kGrayscale40,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: title4,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.kWhite,
            ).copyWith(
              color: AppColor.kGrayscaleDark100,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class DividerRow extends StatelessWidget {
  final String title;
  const DividerRow({required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Divider(color: AppColor.kLine)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.kWhite,
            ).copyWith(
              color: AppColor.kGrayscale40,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(flex: 2, child: Divider(color: AppColor.kLine)),
      ],
    );
  }
}

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTab,
    required this.subtitleTextStyle,
  });
  final String title, subtitle;
  final TextStyle subtitleTextStyle;
  final VoidCallback onTab;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.kWhite,
          ).copyWith(
            color: AppColor.kGrayscale40,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          children: <TextSpan>[
            TextSpan(text: subtitle, style: subtitleTextStyle),
          ],
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String hintText;

  final double width, height;
  final TextEditingController controller;
  final BorderRadiusGeometry borderRadius;
  const PasswordTextField({
    Key? key,
    required this.hintText,
    required this.height,
    required this.controller,
    required this.width,
    required this.borderRadius,
  }) : super(key: key);
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = false;
  @override
  Widget build(BuildContext context) {
    InputBorder enabledBorder = InputBorder.none;
    InputBorder focusedErrorBorder = InputBorder.none;
    InputBorder errorBorder = InputBorder.none;
    InputBorder focusedBorder = InputBorder.none;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: AppColor.kBackground2,
        border: Border.all(color: AppColor.kLine),
      ),
      child: TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.kWhite,
        ).copyWith(color: AppColor.kGrayscaleDark100),
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColor.kGrayscaleDark100,
              size: 17,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.kWhite,
          ).copyWith(
            color: AppColor.kGrayscale40,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PrimaryTextFormField extends StatelessWidget {
  PrimaryTextFormField({
    super.key,
    required this.hintText,
    this.keyboardType,
    required this.controller,
    required this.width,
    required this.height,
    this.hintTextColor,
    this.onChanged,
    this.onTapOutside,
    this.prefixIcon,
    this.prefixIconColor,
    this.inputFormatters,
    this.maxLines,
    this.borderRadius,
  });
  final BorderRadiusGeometry? borderRadius;

  final String hintText;

  final List<TextInputFormatter>? inputFormatters;
  Widget? prefixIcon;
  Function(PointerDownEvent)? onTapOutside;
  final Function(String)? onChanged;
  final double width, height;
  TextEditingController controller;
  final Color? hintTextColor, prefixIconColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    InputBorder enabledBorder = InputBorder.none;
    InputBorder focusedErrorBorder = InputBorder.none;
    InputBorder errorBorder = InputBorder.none;
    InputBorder focusedBorder = InputBorder.none;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColor.kBackground,
        border: Border.all(color: AppColor.kLine),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.kWhite,
        ).copyWith(color: AppColor.kGrayscaleDark100),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.kWhite,
          ).copyWith(
            color: AppColor.kGrayscaleDark100,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
        ),
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        onTapOutside: onTapOutside,
      ),
    );
  }
}
