import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/offers_screen/data/model/offer_model.dart';
import 'package:appp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersPage extends StatelessWidget {
  static const routeName ="OffersPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).availableoffers)),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartUpdated) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                // افترض أن هنا عروض موجودة، كنا نحتاج لجلبها من قاعدة البيانات
                return ListTile(
                  title: Text('Offer: ${state.items[index].product.name}'),
                  subtitle: Text('Discount: ${state.items[index].product.discount}%'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      // عندما يضغط المستخدم على الزر
                      _applyOfferToCart(context, state.items[index].product);
                    },
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // هذه الدالة لتطبيق العرض على المنتج
  void _applyOfferToCart(BuildContext context, ProductEntity product) {
    final cartCubit = BlocProvider.of<CartCubit>(context);

    // الحصول على العرض المناسب (تأكد من أنه يوجد عرض مرتبط بالمنتج)
    final offer = OfferModel(
      title: 'Buy 5 items, get the 6th free',
      description: 'Buy 5 items, get the 6th item free',
      discount: '100',  // مثال على خصم
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      applicableToAll: true,
      associatedProducts: ['product_id_123'],  // افترضنا أن هذا المنتج مرتبط بالعرض
    );

    // تطبيق العرض على المنتج في السلة
    cartCubit.addProduct(product);

    // هنا، يمكنك تحديث واجهة السلة
    cartCubit.emitUpdated();
  }
}