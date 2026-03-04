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

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
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

  /// `Please Enter Full Name`
  String get enterFullName {
    return Intl.message(
      'Please Enter Full Name',
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

  /// `Forget the password?`
  String get forgetPassword {
    return Intl.message(
      'Forget the password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
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

  /// `Login with iPhone`
  String get loginwithIphone {
    return Intl.message(
      'Login with iPhone',
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

  /// `This field is required`
  String get validatorText {
    return Intl.message(
      'This field is required',
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

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Payment`
  String get Payment {
    return Intl.message('Payment', name: 'Payment', desc: '', args: []);
  }

  /// `Personal Information`
  String get personal {
    return Intl.message(
      'Personal Information',
      name: 'personal',
      desc: '',
      args: [],
    );
  }

  /// `Switch Account`
  String get changeAccount {
    return Intl.message(
      'Switch Account',
      name: 'changeAccount',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Branches`
  String get branches {
    return Intl.message('Branches', name: 'branches', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Complaint Submission`
  String get complaintSubmission {
    return Intl.message(
      'Complaint Submission',
      name: 'complaintSubmission',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Rmsa Cafe`
  String get ramsaCafe {
    return Intl.message('Rmsa Cafe', name: 'ramsaCafe', desc: '', args: []);
  }

  /// `Search for coffee or treats...`
  String get searchHint {
    return Intl.message(
      'Search for coffee or treats...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Explore Categories`
  String get exploreCategories {
    return Intl.message(
      'Explore Categories',
      name: 'exploreCategories',
      desc: '',
      args: [],
    );
  }

  /// `Featured Drinks`
  String get featuredDrinks {
    return Intl.message(
      'Featured Drinks',
      name: 'featuredDrinks',
      desc: '',
      args: [],
    );
  }

  /// `Extra Options`
  String get extraOptions {
    return Intl.message(
      'Extra Options',
      name: 'extraOptions',
      desc: '',
      args: [],
    );
  }

  /// `Select Size`
  String get selectSize {
    return Intl.message('Select Size', name: 'selectSize', desc: '', args: []);
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `Describe your issue...`
  String get describeIssue {
    return Intl.message(
      'Describe your issue...',
      name: 'describeIssue',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Complaint sent successfully!`
  String get complaintSentSuccess {
    return Intl.message(
      'Complaint sent successfully!',
      name: 'complaintSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your complaint first`
  String get enterComplaintError {
    return Intl.message(
      'Please enter your complaint first',
      name: 'enterComplaintError',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again`
  String get errorOccurred {
    return Intl.message(
      'An error occurred, please try again',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Theme Setting`
  String get themeSetting {
    return Intl.message(
      'Theme Setting',
      name: 'themeSetting',
      desc: '',
      args: [],
    );
  }

  /// `Choose Appearance`
  String get chooseAppearance {
    return Intl.message(
      'Choose Appearance',
      name: 'chooseAppearance',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Choose Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Our Locations`
  String get ourLocations {
    return Intl.message(
      'Our Locations',
      name: 'ourLocations',
      desc: '',
      args: [],
    );
  }

  /// `Search for a branch...`
  String get searchBranch {
    return Intl.message(
      'Search for a branch...',
      name: 'searchBranch',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Get Directions`
  String get getDirections {
    return Intl.message(
      'Get Directions',
      name: 'getDirections',
      desc: '',
      args: [],
    );
  }

  /// `Could not open TikTok`
  String get errorTikTok {
    return Intl.message(
      'Could not open TikTok',
      name: 'errorTikTok',
      desc: '',
      args: [],
    );
  }

  /// `Could not open Instagram`
  String get errorInstagram {
    return Intl.message(
      'Could not open Instagram',
      name: 'errorInstagram',
      desc: '',
      args: [],
    );
  }

  /// `Could not open WhatsApp`
  String get errorWhatsApp {
    return Intl.message(
      'Could not open WhatsApp',
      name: 'errorWhatsApp',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get errorGeneral {
    return Intl.message(
      'Something went wrong',
      name: 'errorGeneral',
      desc: '',
      args: [],
    );
  }

  /// `Please write your complaint first`
  String get pleaseWriteSomething {
    return Intl.message(
      'Please write your complaint first',
      name: 'pleaseWriteSomething',
      desc: '',
      args: [],
    );
  }

  /// `Sent successfully`
  String get sentSuccessfully {
    return Intl.message(
      'Sent successfully',
      name: 'sentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get noNotifications {
    return Intl.message(
      'No notifications yet',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get userName {
    return Intl.message('Full Name', name: 'userName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone {
    return Intl.message('Phone Number', name: 'phone', desc: '', args: []);
  }

  /// `Email Address`
  String get email {
    return Intl.message('Email Address', name: 'email', desc: '', args: []);
  }

  /// `New Password`
  String get password {
    return Intl.message('New Password', name: 'password', desc: '', args: []);
  }

  /// `Edit Profile`
  String get edit {
    return Intl.message('Edit Profile', name: 'edit', desc: '', args: []);
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Profile updated successfully!`
  String get updateSuccess {
    return Intl.message(
      'Profile updated successfully!',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Update failed, please try again`
  String get updateFailure {
    return Intl.message(
      'Update failed, please try again',
      name: 'updateFailure',
      desc: '',
      args: [],
    );
  }

  /// `Regular User`
  String get userRole {
    return Intl.message('Regular User', name: 'userRole', desc: '', args: []);
  }

  /// `Delivery Driver`
  String get deliveryRole {
    return Intl.message(
      'Delivery Driver',
      name: 'deliveryRole',
      desc: '',
      args: [],
    );
  }

  /// `Administrator`
  String get adminRole {
    return Intl.message('Administrator', name: 'adminRole', desc: '', args: []);
  }

  /// `Current Password`
  String get oldPassword {
    return Intl.message(
      'Current Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password (Optional)`
  String get newPassword {
    return Intl.message(
      'New Password (Optional)',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Current password is required to verify`
  String get oldPasswordRequired {
    return Intl.message(
      'Current password is required to verify',
      name: 'oldPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Current password is incorrect`
  String get wrongPassword {
    return Intl.message(
      'Current password is incorrect',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Choose the account type you want to log in with:`
  String get chooseAccountType {
    return Intl.message(
      'Choose the account type you want to log in with:',
      name: 'chooseAccountType',
      desc: '',
      args: [],
    );
  }

  /// `Browse dishes and order your favorite meal`
  String get userSubtitle {
    return Intl.message(
      'Browse dishes and order your favorite meal',
      name: 'userSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage delivery orders and update status`
  String get deliverySubtitle {
    return Intl.message(
      'Manage delivery orders and update status',
      name: 'deliverySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Control panel, branch and user management`
  String get adminSubtitle {
    return Intl.message(
      'Control panel, branch and user management',
      name: 'adminSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, you don't have permission to access this account`
  String get accessDenied {
    return Intl.message(
      'Sorry, you don\'t have permission to access this account',
      name: 'accessDenied',
      desc: '',
      args: [],
    );
  }

  /// `Error: `
  String get errorPrefix {
    return Intl.message('Error: ', name: 'errorPrefix', desc: '', args: []);
  }

  /// `Admin Dashboard`
  String get adminHomeTitle {
    return Intl.message(
      'Admin Dashboard',
      name: 'adminHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Admin Interface`
  String get adminWelcome {
    return Intl.message(
      'Welcome to the Admin Interface',
      name: 'adminWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Interface`
  String get deliveryHomeTitle {
    return Intl.message(
      'Delivery Interface',
      name: 'deliveryHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Delivery Interface`
  String get deliveryWelcome {
    return Intl.message(
      'Welcome to the Delivery Interface',
      name: 'deliveryWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Featured Products`
  String get featuredProducts {
    return Intl.message(
      'Featured Products',
      name: 'featuredProducts',
      desc: '',
      args: [],
    );
  }

  /// `Select Branch`
  String get selectBranch {
    return Intl.message(
      'Select Branch',
      name: 'selectBranch',
      desc: '',
      args: [],
    );
  }

  /// `No products found`
  String get noProducts {
    return Intl.message(
      'No products found',
      name: 'noProducts',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `SAR`
  String get sar {
    return Intl.message('SAR', name: 'sar', desc: '', args: []);
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message('Total Price', name: 'totalPrice', desc: '', args: []);
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message('Add to Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Your favorites list is empty`
  String get noFavorites {
    return Intl.message(
      'Your favorites list is empty',
      name: 'noFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Search in favorites...`
  String get searchInFavorites {
    return Intl.message(
      'Search in favorites...',
      name: 'searchInFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Added to favorites`
  String get addedToFavorites {
    return Intl.message(
      'Added to favorites',
      name: 'addedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Error loading favorites`
  String get errorLoadingFavorites {
    return Intl.message(
      'Error loading favorites',
      name: 'errorLoadingFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message('Guest', name: 'guest', desc: '', args: []);
  }

  /// `Developed By`
  String get developedBy {
    return Intl.message(
      'Developed By',
      name: 'developedBy',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this item?`
  String get deleteMessage {
    return Intl.message(
      'Are you sure you want to remove this item?',
      name: 'deleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Removed from favorites`
  String get removedFromFavorites {
    return Intl.message(
      'Removed from favorites',
      name: 'removedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `No products found`
  String get noProductsFound {
    return Intl.message(
      'No products found',
      name: 'noProductsFound',
      desc: '',
      args: [],
    );
  }

  /// `Mark All As Read `
  String get markAllAsRead {
    return Intl.message(
      'Mark All As Read ',
      name: 'markAllAsRead',
      desc: '',
      args: [],
    );
  }

  /// `To access your profile, please log in or create a new account`
  String get guestProfileMessage {
    return Intl.message(
      'To access your profile, please log in or create a new account',
      name: 'guestProfileMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
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
