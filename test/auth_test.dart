import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:maids_task_manager_app_test/core/network/network_info.dart';
import 'package:maids_task_manager_app_test/features/auth/models/user_model.dart';
import 'package:maids_task_manager_app_test/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:maids_task_manager_app_test/features/auth/data/datasource/remote/auth_remote_data_source.dart';
import 'package:maids_task_manager_app_test/features/auth/repository/auth_repository_impl.dart';

import 'auth_test.mocks.dart';

@GenerateMocks([AuthLocalDataSource, AuthRemoteDataSource, NetworkInfo])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockNetworkInfo,
    );
  });

  group('login', () {
    const tUsername = 'kminchelle';
    const tPassword = '0lelplR';
    final tUserModel = UserModel(
      id: 1,
      email: 'kminchelle@qq.com"',
      firstName: 'Jeanne',
      lastName: 'Halvorson',
      gender: 'female',
      username: tUsername,
      token:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInVzZXJuYW1lIjoia21pbmNoZWxsZSIsImVtYWlsIjoia21pbmNoZWxsZUBxcS5jb20iLCJmaXJzdE5hbWUiOiJKZWFubmUiLCJsYXN0TmFtZSI6IkhhbHZvcnNvbiIsImdlbmRlciI6ImZlbWFsZSIsImltYWdlIjoiaHR0cHM6Ly9yb2JvaGFzaC5vcmcvSmVhbm5lLnBuZz9zZXQ9c2V0NCIsImlhdCI6MTcxMTIwOTAwMSwiZXhwIjoxNzExMjEyNjAxfQ.F_ZCpi2qdv97grmWiT3h7HcT1prRJasQXjUR4Nk1yo8',
      image: 'https://robohash.org/Jeanne.png?set=set4',
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.login(
                username: anyNamed('username'), password: anyNamed('password')))
            .thenAnswer((_) async => right(tUserModel));

        final result =
            await repository.login(username: tUsername, password: tPassword);

        verify(mockRemoteDataSource.login(
            username: tUsername, password: tPassword));

        expect(result, equals(right(tUserModel)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.login(
                username: anyNamed('username'), password: anyNamed('password')))
            .thenAnswer((_) async => right(tUserModel));

        await repository.login(username: tUsername, password: tPassword);

        verify(mockRemoteDataSource.login(
            username: tUsername, password: tPassword));
        verify(mockLocalDataSource.setUserId(tUserModel.id.toString()));
        verify(mockLocalDataSource.setUserToken(tUserModel.token));
        verify(mockLocalDataSource.setUserName(tUserModel.username));
        verify(mockLocalDataSource.setUserImage(tUserModel.image));
      });
    });
  });
}
