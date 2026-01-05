import 'package:flutter/material.dart';

class myAdaptivelayout extends StatelessWidget {
  const myAdaptivelayout(
      {super.key,
      required this.mobillayout,
      required this.tablayout,
      required this.desktoplayout});
  final WidgetBuilder mobillayout, tablayout, desktoplayout;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      if (Constraints.maxWidth < 600) {
        return mobillayout(context);
      } else if (Constraints.maxWidth < 900) {
        return tablayout(context);
      } else {
        return desktoplayout(context);
      }
    });
  }
}
