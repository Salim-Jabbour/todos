import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/network_info.dart';

Future<void> globalInjection() async {
  // core
  GetIt.I
      .registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(GetIt.I.get()));

  //Extenal
  final sharedPreferences = await SharedPreferences.getInstance();
  GetIt.I.registerLazySingleton(() => sharedPreferences);
  //  GetIt.I..registerLazySingleton(() => http.Client());
  GetIt.I.registerLazySingleton(() => Connectivity());
}
