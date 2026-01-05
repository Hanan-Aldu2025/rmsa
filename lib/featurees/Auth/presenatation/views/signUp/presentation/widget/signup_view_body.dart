import 'package:appp/core/widget/custom_button.dart';
import 'package:appp/core/widget/custom_text_filed.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/signup_cubit/signup_cubit.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/conditaions_widget.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/custom_password_filed.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/Auth_validators.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/EmailVerificationChecker.dart';
import 'package:appp/featurees/main_Screens/product_screen/dummy_proudect.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'have_account.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool isTermsAccepted = false;

  String? email;
  String? userName;
  String? password;
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
  listener: (context, state) {
    if (state is SignupFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is SignupEmailNotVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تحقق من بريدك لتفعيل الحساب!")),
      );
    } else if (state is SignupSuccese) {
      Navigator.pushReplacementNamed(context, FakeProductsPage.routeName);
    } else if (state is SignupEmailAlreadyExists) {
      // حالة البريد مستخدم مسبقًا → ننتقل مباشرة لصفحة المنتجات
      Navigator.pushReplacementNamed(context, FakeProductsPage.routeName);
    }
  
  
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: [
              const SizedBox(height: 24),

              // الاسم
              CustomTextFormFiled(
                onSaved: (value) => userName = value,
                hinttext: S.of(context).enterFullName,
                textInputType: TextInputType.name,
                validator: (value) => AuthValidators.name(value, context),
              ),
              const SizedBox(height: 16),

              // البريد (اختياري)
              CustomTextFormFiled(
                onSaved: (value) => email = value,
                hinttext: S.of(context).enterEmail,
                textInputType: TextInputType.emailAddress,
                validator: (value) => AuthValidators.email(value, context),
                // if (value == null || value.isEmpty) return null; // اختياري
                // return AuthValidators.email(value, context);
                //},
              ),
              const SizedBox(height: 16),

              // // رقم الهاتف
              // CustomTextFormFiled(
              //   onSaved: (value) => phoneNumber = value,
              //   hinttext:" S.of(context).enterPhoneNumber",
              //   textInputType: TextInputType.phone,
              //   validator: (value) {  if (value == null || value.isEmpty) return null; // اختياري
              //     return AuthValidators.phone(value, context); }
              //   // => AuthValidators.phone(value, context),
              // ),
              const SizedBox(height: 16),

              // كلمة السر
              passwordFiled(onSaved: (value) => password = value),
              const SizedBox(height: 16),

              // شروط الاستخدام
              ConditionsWidget(
                onChanged: (value) {
                  setState(() {
                    isTermsAccepted = value;
                  });
                },
                value: isTermsAccepted,
              ),
              const SizedBox(height: 16),

              // زر إنشاء الحساب → يرسل OTP للهاتف
              CustomButton(
                text: S.of(context).create_new_account,
                
                onpressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();

                    if (!isTermsAccepted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "You must accept terms and conditions.",
                          ),
                        ),
                      );
                      return;
                    }

                    // =========================إرسال OTP for phone==============================//
                    //await context.read<SignupCubit>();
                    // .sendOtpToPhone(phoneNumber!);
                    await context.read<SignupCubit>().signupWithEmail(
                      name: userName!,
                      email: email!,
                      password: password!, phoneNumber: '',
                    );
                  } else {
                    setState(() => _autovalidateMode = AutovalidateMode.always);
                  }
                },
              ),

              const SizedBox(height: 16),

              // ===================حقل OTP وزر تحقق يظهر فقط بعد إرسال OTP============================//
              // BlocBuilder<SignupCubit, SignupState>(
              //   builder: (context, state) {
              //     if (-+-p['6wiol;.,pOtpSent) {
              //       return Column(
              //         children: [
              //           CustomTextFormFiled(
              //             controller: otpController,
              //             hinttext: "Enter OTP",
              //             textInputType: TextInputType.number,
              //             validator: (value) =>
              //                 value == null || value.isEmpty
              //                     ? "Please enter OTP"
              //                     : null,
              //           ),
              //           const SizedBox(height: 16),
              //           CustomButton(
              //             text: "Verify OTP",
              //             onpressed: () async {
              //               if (otpController.text.isEmpty) return;
              //               await context
              //                   .read<SignupCubit>()
              //                   .verifyOtpCode(otpController.text);
              //             },
              //           ),
              //         ],
              //       );
              //     }
              //     return const SizedBox.shrink();
              //   },
              // ),
              //====================================================================================================//
              const SizedBox(height: 16),
              HaveAccount(context),
            ],
          ),
        ),
      ),
    );
  }
}
