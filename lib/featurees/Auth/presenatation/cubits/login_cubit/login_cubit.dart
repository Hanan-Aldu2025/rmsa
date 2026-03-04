import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:appp/featurees/Auth/presenatation/cubits/login_cubit/login_state.dart';
import 'package:bloc/bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepos authRepos;

  LoginCubit(this.authRepos) : super(LoginInitial());

  // دالة للتحقق إذا كان المدخل بريدًا إلكترونيًا
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    final regex = RegExp(r'^\+?[0-9]{10,15}$'); // تحقق من رقم الهاتف بشكل صحيح
    return regex.hasMatch(phone);
  }

  // ==================== تسجيل الدخول ====================
  Future<void> signIn(String emailOrPhone, String password) async {
    emit(LoginLoading());

    // التحقق من صحة المدخل
    if (!_isValidEmail(emailOrPhone) && !_isValidPhoneNumber(emailOrPhone)) {
      emit(
        LoginFailure(message: 'Please enter a valid email or phone number.'),
      );
      return;
    }

    // استدعاء الريبو لدالة تسجيل الدخول الموحدة
    final result = await authRepos.signInWithEmailOrPhone(
      emailOrPhone,
      password,
    );

    result.fold(
      (failure) {
        emit(LoginFailure(message: failure.errorMessage));
      },
      (userEntity) {
        emit(LoginSuccess(userEntity: userEntity, shouldResetFields: true));
      },
    );
  }
}
