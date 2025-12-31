import 'package:expense_tracker/config/themes.dart';
import 'package:expense_tracker/features/auth/data/data/auth_repository_impl.dart';
import 'package:expense_tracker/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/screens/dashboard.dart';
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
    ChangeNotifierProvider(
      create: (_) => AuthProviderr(
        signUp: SignUpUseCase(
          AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance)),
        ),
        signIn: SignInUseCase(
          AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance)),
        ),
        resetPassword: ResetPasswordUseCase(
          AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance)),
        ),
      ),
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
