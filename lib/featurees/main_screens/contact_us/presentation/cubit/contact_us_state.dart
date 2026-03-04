import 'package:equatable/equatable.dart';

/// حالات صفحة تواصل معنا
abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class ContactInitial extends ContactState {}

/// حالة الخطأ
class ContactError extends ContactState {
  final String message;

  const ContactError({required this.message});

  @override
  List<Object?> get props => [message];
}
