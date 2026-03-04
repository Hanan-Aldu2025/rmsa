import 'package:appp/featurees/main_screens/home/presentation/views/home_view.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/branch_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

// class HomeReposImp extends HomeRepos {
//   final HomeRemoteDataSource remoteDataSource;

//   HomeReposImp({required this.remoteDataSource});

//   @override
//   Future<List<BranchModel>> fetchBranches() => remoteDataSource.getBranches();

//   @override
//   Future<List<CategoryModel>> fetchCategoriesForBranch(String branchId) =>
//       remoteDataSource.getCategories(branchId);

//   @override
//   Stream<List<ProductModel>> watchProducts({
//     required String branchId,
//     String? categoryId,
//   }) => remoteDataSource.watchProducts(branchId, categoryId: categoryId);

//   @override
//   Future<List<ProductModel>> searchProducts({
//     required String branchId,
//     required String queryText,
//   }) => remoteDataSource.searchProducts(branchId, queryText);
// }
