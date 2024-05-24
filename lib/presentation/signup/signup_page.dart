import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_viewer/presentation/signup/signup_view_model.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final GlobalKey _emailKey = GlobalKey<FormState>();
  final GlobalKey _passwordKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 150.h),
                ),
                Image.asset(
                    'assets/logos/logo-banner.png',
                    width: 200.w,
                    height: 100.h
                ),
                Padding(
                    padding: EdgeInsets.only(top: 75.h)
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Form(
                        key: _emailKey,
                        child: Consumer<SignupViewModel>(
                          builder: (context, loginViewModel, _) {
                            return TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (email) {
                                return loginViewModel.validateEmail(email);
                              },
                              controller: _emailController,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                              onChanged: (value) async {
                                await loginViewModel.isEmailTaken(value);
                                if (loginViewModel.validEmail) {
                                  loginViewModel.setEmail(value);
                                }
                              },
                              cursorColor:  Colors.white,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.5.h),
                                hintText: "이메일",
                                filled: true,
                                isDense: true,
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white
                                  ),
                                ),
                                // helperText: _emailController.text.isEmpty
                                //     ? ""
                                //     : "사용 가능한 이메일이에요",
                                // helperStyle: TextStyle(
                                //   fontWeight: FontWeight.w400,
                                //   fontSize: 12.sp,
                                // ),
                                // errorStyle: TextStyle(
                                //     fontWeight: FontWeight.w400,
                                //     fontSize: 12.sp),
                                // counterText: '',
                                suffixIcon: _emailController.text.isEmpty
                                    ? null
                                    : IconButton(
                                  icon: Image.asset(
                                    'assets/icons/delete.png',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  onPressed: () {
                                    _emailController.clear();
                                    setState(() {});
                                  },
                                ),
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     width: 1.w,
                                //     color: const Color(0xFFF4F5F7),
                                //   ),
                                //   borderRadius: BorderRadius.circular(10.r),
                                // ),
                                // focusedBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: const Color(0xFF23D77D),
                                //         width: 1.w),
                                //     borderRadius: BorderRadius.circular(10.r)),
                                // focusedErrorBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: const Color(0xFFFF717C),
                                //         width: 1.w),
                                //     borderRadius: BorderRadius.circular(10.r)),
                                // errorBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         color: const Color(0xFFFF717C),
                                //         width: 1.w),
                                //     borderRadius: BorderRadius.circular(10.r)),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 8.h)),
                      Form(
                        key: _passwordKey,
                        child: Consumer<SignupViewModel>(
                          builder: (context, loginViewModel, _) {
                            return TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _passwordController,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp),
                              onChanged: (value) async {
                                loginViewModel.setPassword(value);
                              },
                              obscureText: true,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.5.h),
                                hintText: "비밀번호",
                                filled: true,
                                isDense: true,
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white
                                  ),
                                ),
                                suffixIcon: _passwordController.text.isEmpty
                                    ? null
                                    : IconButton(
                                  icon: Image.asset(
                                    'assets/icons/delete.png',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  onPressed: () {
                                    _passwordController.clear();
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
        bottomNavigationBar:  Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 40.h),
            child: Consumer<SignupViewModel>(
                builder: (context, viewModel, _) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 17.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        backgroundColor: !viewModel.validEmail || _passwordController.text.isEmpty
                            ? Colors.black45
                            : Colors.white30
                    ),
                    onPressed: () async {
                      if (!viewModel.validEmail || _passwordController.text.isEmpty) {
                        return;
                      }

                      await viewModel.signUp();

                      Navigator.pop(context);
                    },
                    child: Text(
                      "가입하기",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  );
                }
            )
        ),
      ),
    );
  }
}