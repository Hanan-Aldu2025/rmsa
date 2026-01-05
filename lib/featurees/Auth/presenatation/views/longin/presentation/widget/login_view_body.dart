import 'package:appp/core/constans/constans_kword.dart';
import 'package:appp/featurees/Auth/presenatation/views/goole_fun.dart';
import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/login_cubit/login_cubit.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/login_cubit/login_state.dart';
import 'package:appp/featurees/Auth/presenatation/views/forgot_pass/presentation/views/forgot_pass_view.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/widget/custom_dont_have_account.dart';
import 'package:appp/core/widget/custom_text_filed.dart';
import 'package:appp/featurees/Auth/presenatation/views/longin/presentation/widget/custom_social_login_button.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/custom_password_filed.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/Auth_validators.dart';
import 'package:appp/featurees/main_Screens/product_screen/dummy_proudect.dart';
import 'package:appp/generated/l10n.dart';
import 'package:appp/utils/app_images.dart';
import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, FakeProductsPage.routeName);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              children: [
                SizedBox(height: 24),

                CustomTextFormFiled(
                  onSaved: (value) => email = value,
                  hinttext: S.of(context).enterEmail,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) => AuthValidators.email(value, context),
                ),
                SizedBox(height: 16),

                passwordFiled(onSaved: (value) => password = value),
                SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ForgotPasswordView()),
                    );
                  },
                  child: Align(
                    alignment: Directionality.of(context) == TextDirection.rtl
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: Text(
                      S.of(context).forgetPassword,
                      style: AppStyles.InriaSerif_16,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                CustomButton(
                  onpressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();

context
                          .read<LoginCubit>()
                          .signIn(email!, password!);
                    } else {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  text: S.of(context).login,
                ),
                SizedBox(height: 15),
                dontHaveAccount(context),
                SizedBox(height: 16),

                CustomSocialLoginButton(
                  title: S.of(context).loginwithGoogle,
                  image: Image.asset(Assets.imagesGoogle),
                  onPressed: () async {
                    try {
                      final userCredential = await signInWithGoogle();
                      if (userCredential != null) {
                        Navigator.pushReplacementNamed(
                          context,
                          FakeProductsPage.routeName,
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("حدث خطأ أثناء تسجيل الدخول"),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 16),

                CustomSocialLoginButton(
                  title: S.of(context).loginwithIphone,
                  image: Image.asset(Assets.imagesIphon),
                  onPressed: () {},
                ),
                SizedBox(height: 16),

                CustomSocialLoginButton(
                  title: S.of(context).loginwithFacebook,
                  image: Image.asset(Assets.imagesFacebook),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}