// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to Rmsa Cafe\nExperience the best coffee in town with fast delivery.`
  String get onBoardingTitle1 {
    return Intl.message(
      'Welcome to Rmsa Cafe\nExperience the best coffee in town with fast delivery.',
      name: 'onBoardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Discover Amazing Coffee\nFind your favorite coffee and desserts in one place.`
  String get onBoardingTitle2 {
    return Intl.message(
      'Discover Amazing Coffee\nFind your favorite coffee and desserts in one place.',
      name: 'onBoardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Order Easily & Enjoy\nPlace your order in seconds and enjoy it anywhere.`
  String get onBoardingTitle3 {
    return Intl.message(
      'Order Easily & Enjoy\nPlace your order in seconds and enjoy it anywhere.',
      name: 'onBoardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `start`
  String get start {
    return Intl.message('start', name: 'start', desc: '', args: []);
  }

  /// `Enter The Email`
  String get enterEmail {
    return Intl.message(
      'Enter The Email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// ` Please Enter Full Name`
  String get enterFullName {
    return Intl.message(
      ' Please Enter Full Name',
      name: 'enterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Password`
  String get enterPassword {
    return Intl.message(
      'Please enter your Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forget the password? `
  String get forgetPassword {
    return Intl.message(
      'Forget the password? ',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account ? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account ? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Login with Google`
  String get loginwithGoogle {
    return Intl.message(
      'Login with Google',
      name: 'loginwithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Login with Iphone `
  String get loginwithIphone {
    return Intl.message(
      'Login with Iphone ',
      name: 'loginwithIphone',
      desc: '',
      args: [],
    );
  }

  /// `Login with Facebook`
  String get loginwithFacebook {
    return Intl.message(
      'Login with Facebook',
      name: 'loginwithFacebook',
      desc: '',
      args: [],
    );
  }

  /// `By creating an account, you agree to our `
  String get agree_prefix {
    return Intl.message(
      'By creating an account, you agree to our ',
      name: 'agree_prefix',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get create_new_account {
    return Intl.message(
      'Create New Account',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get already_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `This filed is required `
  String get validatorText {
    return Intl.message(
      'This filed is required ',
      name: 'validatorText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get fillAllFields {
    return Intl.message(
      'Please fill all fields',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOtpEn {
    return Intl.message('Send OTP', name: 'sendOtpEn', desc: '', args: []);
  }

  /// `Back to Login`
  String get backToLoginEn {
    return Intl.message(
      'Back to Login',
      name: 'backToLoginEn',
      desc: '',
      args: [],
    );
  }

  /// `Please check your email to verify your account`
  String get check_email {
    return Intl.message(
      'Please check your email to verify your account',
      name: 'check_email',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get welcome {
    return Intl.message('Welcome back!', name: 'welcome', desc: '', args: []);
  }

  /// `Enter your email to reset password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Enter your email to reset password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Send Reset Email`
  String get sendResetEmail {
    return Intl.message(
      'Send Reset Email',
      name: 'sendResetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emptyEmailError {
    return Intl.message(
      'Please enter your email',
      name: 'emptyEmailError',
      desc: '',
      args: [],
    );
  }

  /// `cart`
  String get cart {
    return Intl.message('cart', name: 'cart', desc: '', args: []);
  }

  /// `Payment`
  String get Payment {
    return Intl.message('Payment', name: 'Payment', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
