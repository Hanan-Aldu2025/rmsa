import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaymentMethodOption {
  final String id; // "COD", "CARD", "MOBILE"
  final String title;
  final IconData icon;

  PaymentMethodOption({
    required this.id,
    required this.title,
    required this.icon,
  });
}

final List<PaymentMethodOption> paymentMethods = [
  PaymentMethodOption(id: "COD", title: "Cash ", icon: LucideIcons.landmark),
  PaymentMethodOption(
    id: "CARD",
    title: "Credit/Debit Cart",
    icon: Icons.credit_card,
  ),
  PaymentMethodOption(
    id: "MOBILE",
    title: "Mobile Wallet",
    icon: LucideIcons.wallet,
  ),
];
