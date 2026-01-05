import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgotpass_state.dart';
import 'package:appp/featurees/Auth/domain/use_case/forgot_pass_usecase.dart';
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordCubit({required this.forgotPasswordUseCase})
    : super(ForgotPasswordInitial());

  void sendResetEmail(String email) async {
    try {
      emit(ForgotPasswordLoading());
      final result = await forgotPasswordUseCase.sendResetEmail(email: email);
      
      // التأكد من أن الكيوبت لا يتم إغلاقه قبل أن تكتمل العملية
      result.fold(
        (failure) => emit(ForgotPasswordError(failure.errorMessage)),
        (_) => emit(ForgotPasswordSuccess()),
      );
    } catch (e) {
      // التعامل مع أي خطأ قد يحدث في الكود
      emit(ForgotPasswordError('حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<void> close() {
    // تأكد من أنه يتم إغلاق الكيوبت بشكل صحيح فقط عندما تنتهي العمليات
    return super.close();
  }
}