import 'package:get_it/get_it.dart';

import '../../../core/storage/local_storage_service.dart';

extension GetItUtilsX on GetIt {
  LocalStorageService get sharedPrefs => this<LocalStorageService>(instanceName: "sharedPrefs");
  LocalStorageService get secureStorage => this<LocalStorageService>(instanceName: "secureStorage");
}