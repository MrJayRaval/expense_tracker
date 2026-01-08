import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/themes.dart';
import 'package:expense_tracker/features/auth/data/data/auth_repository_impl.dart';
import 'package:expense_tracker/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:expense_tracker/features/auth/presentation/pages/registration.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/features/category/data/datasources/category_local_datasource.dart';
import 'package:expense_tracker/features/category/data/datasources/category_remote_datasource.dart';
import 'package:expense_tracker/features/category/data/repository/category_repository_impl.dart';
import 'package:expense_tracker/features/category/domain/usecases/add_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_category_usecase.dart';
import 'package:expense_tracker/features/category/presenation/Screens/category_page.dart';
import 'package:expense_tracker/features/category/presenation/providers/category_provider.dart';
import 'package:expense_tracker/features/dashboard/data/data/user_repository.dart';
import 'package:expense_tracker/features/dashboard/data/datasources/user_remote_data_source.dart';
import 'package:expense_tracker/features/dashboard/domain/usecases/fetch_user_details_usecase.dart';
import 'package:expense_tracker/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/screens/homepage.dart';
import 'package:expense_tracker/features/create_profile/data/datasources/profile_remote_data_sources.dart';
import 'package:expense_tracker/features/create_profile/presentation/provider/profile_provider.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/features/auth/presentation/pages/login.dart';
import 'package:expense_tracker/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
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

        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            addCategoryUsecase: AddCategoryUsecase(
              CategoryRepositoryImpl(
                local: CategoryLocalDatasource(),
                remote: CategoryRemoteDatasource(
                  FirebaseFirestore.instance,
                  FirebaseAuth.instance,
                ),
              ),
            ),
            getCategoryUsecase: GetCategoryUsecase(
              CategoryRepositoryImpl(
                local: CategoryLocalDatasource(),
                remote: CategoryRemoteDatasource(
                  FirebaseFirestore.instance,
                  FirebaseAuth.instance,
                ),
              ),
            ),
            deleteCategoryUsecase: DeleteCategoryUsecase(
              CategoryRepositoryImpl(
                local: CategoryLocalDatasource(),
                remote: CategoryRemoteDatasource(
                  FirebaseFirestore.instance,
                  FirebaseAuth.instance,
                ),
              ),
            ),
          ),
        ),
      ],

      child: MaterialApp(
        routes: {
          // AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.register: (_) => const RegistrationPage(),
          AppRoutes.forgotPassword: (_) => const ForgotPassword(),
          AppRoutes.dashboard: (_) => const HomePage(),
          AppRoutes.category: (_) => const CategoryPage(),
        },
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return const HomePage();
            }
            return LoginPage();
          },
        ),
      ),
    ),
  );
}
