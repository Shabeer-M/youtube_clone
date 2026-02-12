import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dio_client.dart';
import '../storage/session_manager.dart';
import '../storage/hive_service.dart';
import '../security/secure_key_manager.dart';
import '../security/aes_encryption_service.dart';

// Auth Imports
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_email_usecase.dart';
import '../../domain/usecases/login_phone_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/splash/bloc/splash_bloc.dart';
import '../../domain/usecases/login_google_usecase.dart';
import '../../domain/usecases/register_email_usecase.dart';

// Video Imports
import '../../data/datasources/remote/video_remote_datasource.dart';
import '../../data/datasources/remote/video_remote_datasource_impl.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/usecases/fetch_videos_usecase.dart';
import '../../presentation/home/bloc/home_bloc.dart';
import '../../presentation/player/bloc/player_bloc.dart';
import '../../core/utils/file_integrity_checker.dart';
import '../../data/datasources/local/download_local_datasource.dart';
import '../../data/repositories/download_repository_impl.dart';
import '../../domain/repositories/download_repository.dart';
import '../../presentation/downloads/bloc/download_bloc.dart';
import '../../core/network/connectivity_service.dart';
import '../../core/services/local_notification_service.dart';
import '../../core/theme/bloc/theme_bloc.dart';
import '../../data/datasources/local/search_history_local_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../presentation/search/bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // 2. Core Services
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton<SessionManager>(() => SessionManager(sl()));
  sl.registerLazySingleton(() => SecureKeyManager(sl()));
  sl.registerLazySingleton(() => AESEncryptionService());
  sl.registerLazySingleton(() => LocalNotificationService());

  final hiveService = HiveService();
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);

  // 3. Data Sources (Remote/Local)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(sl()),
  );

  // 4. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), sessionManager: sl()),
  );
  sl.registerLazySingleton<VideoRepository>(() => VideoRepositoryImpl(sl()));

  // 5. Use Cases
  sl.registerLazySingleton(() => LoginEmailUseCase(sl()));
  sl.registerLazySingleton(() => LoginPhoneUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => LoginGoogleUseCase(sl()));
  sl.registerLazySingleton(() => RegisterEmailUseCase(sl()));
  sl.registerLazySingleton(() => FetchVideosUseCase(sl()));

  // 6. BLoCs
  sl.registerFactory(() => SplashBloc(sl()));
  sl.registerLazySingleton(
    () => AuthBloc(
      loginEmailUseCase: sl(),
      loginPhoneUseCase: sl(),
      verifyOtpUseCase: sl(),
      resetPasswordUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      logoutUseCase: sl(),
      loginGoogleUseCase: sl(),
      registerEmailUseCase: sl(),
    ),
  );
  sl.registerFactory(() => HomeBloc(fetchVideosUseCase: sl()));
  sl.registerFactory(() => PlayerBloc());

  // 7. Downloads & Security
  sl.registerLazySingleton(() => FileIntegrityChecker());

  final downloadLocalDataSource = DownloadLocalDataSource();
  await downloadLocalDataSource.init();
  sl.registerLazySingleton(() => downloadLocalDataSource);
  // Call init() for Hive somewhere, preferably in main or slash screen, but here we just register
  // Note: DownloadLocalDataSource.init(sl()) needs to be called.

  sl.registerLazySingleton<DownloadRepository>(
    () => DownloadRepositoryImpl(
      dio: sl(),
      encryptionService: sl(),
      keyManager: sl(),
      localDataSource: sl(),
      integrityChecker: sl(),
      notificationService: sl(),
    ),
  );

  sl.registerFactory(() => DownloadBloc(repository: sl()));

  // 8. Theme & Network
  sl.registerFactory(() => ThemeBloc());
  sl.registerLazySingleton(() => ConnectivityService());

  // 9. Search
  final searchHistoryLocalDataSource = SearchHistoryLocalDataSource();
  await searchHistoryLocalDataSource.init();
  sl.registerLazySingleton(() => searchHistoryLocalDataSource);

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(videoRepository: sl(), localDataSource: sl()),
  );

  sl.registerFactory(() => SearchBloc(repository: sl()));
}
