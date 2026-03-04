import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// أنواع الأدوار المتاحة في التطبيق
enum UserRole { user, delivery, admin }

/// كيان الدور - يمثل بيانات الدور في طبقة التطبيق
class RoleEntity extends Equatable {
  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;

  const RoleEntity({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  List<Object?> get props => [role, title, subtitle, icon];
}
