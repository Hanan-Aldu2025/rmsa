// lib/featurees/main_screens/location/data/repositories/location_repository_impl.dart

import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/location_branches/data/datasources/location_remote_data_source.dart';
import 'package:appp/featurees/main_screens/location_branches/domain/repositories/location_repository.dart';

/// تنفيذ LocationRepository - يربط بين الـ Domain والـ Data Source
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BranchEntity>> getAllBranches() async {
    final models = await remoteDataSource.getAllBranches();
    return models.map((model) => model.toEntity()).toList();
  }
}
