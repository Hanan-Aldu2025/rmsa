// lib/featurees/main_screens/contact_us/presentation/cubit/contact_cubit.dart

import 'package:appp/featurees/main_screens/contact_us/domain/repositories/contact_repository.dart';
import 'package:appp/featurees/main_screens/contact_us/presentation/cubit/contact_us_state.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit المسؤول عن منطق صفحة تواصل معنا
class ContactCubit extends Cubit<ContactState> {
  final ContactRepository _repository;
  final BranchEntity branch;

  ContactCubit({required ContactRepository repository, required this.branch})
    : _repository = repository,
      super(ContactInitial());

  /// فتح رابط التواصل الاجتماعي
  Future<void> launchSocial(String url, String errorMessage) async {
    if (url.isNotEmpty) {
      try {
        await _repository.launchUrl(url);
      } catch (e) {
        emit(ContactError(message: errorMessage));
      }
    }
  }

  /// إجراء مكالمة هاتفية
  Future<void> callBranch() async {
    try {
      await _repository.makePhoneCall(branch.phone);
    } catch (e) {
      emit(ContactError(message: 'حدث خطأ في الاتصال'));
    }
  }
}
