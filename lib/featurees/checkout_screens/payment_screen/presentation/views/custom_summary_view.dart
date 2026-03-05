import 'package:appp/core/widget/custom_border_container.dart';
import 'package:appp/core/widget/custom_divider.dart';
import 'package:appp/core/widget/custom_text_button.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_cart_stepper.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/widget/custom_edit_dialog.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/custom_header_cell.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/custom_summary_price_cell.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/widget/custom_summary_raw_cell.dart';
import 'package:appp/generated/l10n.dart';

import 'package:appp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSummaryView extends StatelessWidget {
  const CustomSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.watch<CartCubit>();

    return SafeArea(
      child: Column(
        children: [
          /// ===== Stepper =====
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CustomCartStepper(currentStep: 2),
          ),

          /// ===== Content =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  /// ===== Items Table =====
                  CustomBorderContainer(
                    mychild: Column(
                      children: [
                        Row(
                          children: [
                            HeaderCell(
                              text: S.of(context).items,
                              flex: 2,
                              align: TextAlign.start,
                            ),
                            HeaderCell(
                              text: S.of(context).quantity,
                              isHighlight: false,
                            ),
                            HeaderCell(text: S.of(context).price),
                            HeaderCell(
                              text: S.of(context).total,
                              align: TextAlign.end,
                            ),
                          ],
                        ),
                        my_divider(),

                        ...cartCubit.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                SummaryRowCell(
                                  text: item.product.name,
                                  flex: 2,
                                  align: TextAlign.start,
                                ),
                                SummaryRowCell(text: "${item.quantity}"),
                                SummaryRowCell(
                                  text: item.product.price.toStringAsFixed(2),
                                ),
                                SummaryRowCell(
                                  text: (item.product.price * item.quantity)
                                      .toStringAsFixed(2),
                                  align: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ===== Order Note =====
                  if (cartCubit.orderNote.isNotEmpty)
                    CustomBorderContainer(
                      mychild: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    cartCubit.orderNote.isEmpty
                                        ? S.of(context).noNote
                                        : cartCubit.orderNote,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.InriaSerif_14,
                                  ),
                                ),
                                CustomTextButton(
                                  text: S.of(context).editNote,
                                  onpressed: () async {
                                    final updatedNote =
                                        await showDialog<String>(
                                          context: context,
                                          builder: (_) => EditNoteDialog(
                                            initialNote: cartCubit.orderNote,
                                          ),
                                        );
                                    if (updatedNote != null &&
                                        updatedNote != cartCubit.orderNote) {
                                      cartCubit.updateOrderNote(updatedNote);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  /// ===== Price Summary =====
                  CustomBorderContainer(
                    mychild: Column(
                      children: [
                        PriceSummaryRow(
                          title: S.of(context).discount,
                          value: cartCubit.discountValue,
                        ),
                        PriceSummaryRow(
                          title: S.of(context).delivery,
                          value: cartCubit.deliveryCost,
                          type: cartCubit.deliveryMethod,
                        ),
                        PriceSummaryRow(
                          title: S.of(context).tax,
                          value: cartCubit.taxValue,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ===== Total =====
                  CustomBorderContainer(
                    mychild: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).orderTotal,
                          style: AppStyles.titleLora14,
                        ),
                        Text(
                          cartCubit.totalWithTaxAndDelivery.toStringAsFixed(2),
                          style: AppStyles.InriaSerif_14,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
