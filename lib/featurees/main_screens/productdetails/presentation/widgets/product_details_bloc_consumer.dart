// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// import '../cubit/product_details_cubit.dart';
// import '../cubit/product_details_state.dart';
// import 'product_details_view_body.dart';

// class ProductDetailsBlocConsumer extends StatelessWidget {
//   const ProductDetailsBlocConsumer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return 
    
    
//      BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
//       listener: (context, state) {
//         // يمكن إضافة SnackBars لاحقاً 
      
//       },
//       builder: (context, state) {
//         final isLoading = state is ProductDetailsInitial;
//         return ModalProgressHUD(
//           inAsyncCall: isLoading,
//           child: const ProductDetailsViewBody(),
//         );
//       },
//     );
//   }
// }
