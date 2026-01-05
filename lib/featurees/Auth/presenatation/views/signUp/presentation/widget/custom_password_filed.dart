import 'package:appp/core/widget/custom_text_filed.dart';
import 'package:appp/featurees/Auth/presenatation/views/signUp/presentation/widget/Auth_validators.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';

class passwordFiled extends StatefulWidget {
  const passwordFiled({super.key, this.onSaved});
  final void Function(String?)? onSaved;

  @override
  State<passwordFiled> createState() => _passwordFiledState();
}

class _passwordFiledState extends State<passwordFiled> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormFiled(
      obscureText: obscureText,
      onSaved: widget.onSaved, ////////////////////////////////////
      hinttext: S.of(context).enterPassword,
      textInputType: TextInputType.visiblePassword,
      validator: (value) => AuthValidators.password(value, context),

      suffixIcon: GestureDetector(
        onTap: () {
          obscureText = !obscureText;
          setState(() {});
        },
        child: obscureText
            ? Icon(Icons.visibility_off, color: Color(0xFFCBCBD4))
            : Icon(Icons.remove_red_eye_rounded, color: Color(0xFFCBCBD4)),
      ),
    );
  }
}
