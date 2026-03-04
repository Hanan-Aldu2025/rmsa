import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit التنقل بين التابات
class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void changeTab(int index) => emit(index);
}
