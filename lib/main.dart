import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/themes.dart';
import 'package:expense_tracker/features/auth/data/data/auth_repository_impl.dart';
import 'package:expense_tracker/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/features/dashboard/data/data/user_repository.dart';
import 'package:expense_tracker/features/dashboard/data/datasources/user_remote_data_source.dart';
import 'package:expense_tracker/features/dashboard/domain/usecases/fetch_user_details_usecase.dart';
import 'package:expense_tracker/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/screens/dashboard.dart';
import 'package:expense_tracker/features/create_profile/data/datasources/profile_remote_data_sources.dart';
import 'package:expense_tracker/features/create_profile/presentation/provider/profile_provider.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/features/auth/presentation/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProviderr(
            signUp: SignUpUseCase(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(FirebaseAuth.instance),
              ),
            ),
            signIn: SignInUseCase(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(FirebaseAuth.instance),
              ),
            ),
            resetPassword: ResetPasswordUseCase(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(FirebaseAuth.instance),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            ProfileRemoteDataSourceImpl(FirebaseFirestore.instance),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            fetchUserDetailsUsecase: FetchUserDetailsUsecase(
              UserDetailsRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(
                  firebaseAuth: FirebaseAuth.instance,
                  firestore: FirebaseFirestore.instance,
                ),
              ),
            ),
          ),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return const DashboardPage();
            }
            return LoginPage();
          },
        ),
      ),
    ),
  );
}
