import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/config/themes.dart';
import 'package:expense_tracker/features/History/data/datasources/history_local_datasource_impl.dart';
import 'package:expense_tracker/features/History/data/datasources/history_remote_datasource_impl.dart';
import 'package:expense_tracker/features/History/data/repository/history_repository_impl.dart';
import 'package:expense_tracker/features/History/domain/usecases/delete_particular_income_usecase.dart';
import 'package:expense_tracker/features/History/domain/usecases/get_incomes_usecase.dart';
import 'package:expense_tracker/features/History/presenation/providers/history_provider.dart';
import 'package:expense_tracker/features/auth/data/data/auth_repository_impl.dart';
import 'package:expense_tracker/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:expense_tracker/features/auth/presentation/pages/registration_page.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/features/category/data/datasources/category_local_datasource.dart';
import 'package:expense_tracker/features/category/data/datasources/category_remote_datasource.dart';
import 'package:expense_tracker/features/category/data/repository/category_repository_impl.dart';
import 'package:expense_tracker/features/category/domain/usecases/add_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/is_category_duplicated.dart';
import 'package:expense_tracker/features/category/presenation/Screens/category_page.dart';
import 'package:expense_tracker/features/category/presenation/providers/category_provider.dart';
import 'package:expense_tracker/features/homepage/data/data/user_repository.dart';
import 'package:expense_tracker/features/homepage/data/datasources/user_remote_data_source.dart';
import 'package:expense_tracker/features/homepage/domain/usecases/fetch_user_details_usecase.dart';
import 'package:expense_tracker/features/homepage/presentation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/homepage/presentation/screens/homepage.dart';
import 'package:expense_tracker/features/create_profile/data/datasources/profile_remote_data_sources.dart';
import 'package:expense_tracker/features/create_profile/presentation/provider/profile_provider.dart';
import 'package:expense_tracker/features/income/data/datasource/add_income_datasource_impl.dart';
import 'package:expense_tracker/features/income/data/repository/income_repository_impl.dart';
import 'package:expense_tracker/features/income/domain/usecases/add_income_usecase.dart';
import 'package:expense_tracker/features/income/presentaion/provider/income_provider.dart';
import 'package:expense_tracker/features/income/presentaion/screens/add_income_page.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/features/auth/presentation/pages/login_page.dart';
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

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthRepositoryImpl _authRepository;
  late final CategoryRepositoryImpl _categoryRepository;
  late final UserDetailsRepositoryImpl _userRepository;
  late final IncomeRepositoryImpl _incomeRepositoryImpl;
  late final HistoryRepositoryImpl _historyRepositoryImpl;

  @override
  void initState() {
    super.initState();
    // Initialize repositories once to avoid duplicate instantiation
    _authRepository = AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(FirebaseAuth.instance),
    );

    _categoryRepository = CategoryRepositoryImpl(
      local: CategoryLocalDatasource(),
      remote: CategoryRemoteDatasource(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
      ),
    );

    _userRepository = UserDetailsRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );

    _incomeRepositoryImpl = IncomeRepositoryImpl(
      remote: AddIncomeDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );

    _historyRepositoryImpl = HistoryRepositoryImpl(
      local: HistoryLocalDatasourceImpl(),
      remote: HistoryRemoteDatasourceImpl(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ThemeHelper.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProviderr(
            signUp: SignUpUseCase(_authRepository),
            signIn: SignInUseCase(_authRepository),
            resetPassword: ResetPasswordUseCase(_authRepository),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            ProfileRemoteDataSourceImpl(FirebaseFirestore.instance),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            fetchUserDetailsUsecase: FetchUserDetailsUsecase(_userRepository),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            addCategoryUsecase: AddCategoryUsecase(_categoryRepository),
            getCategoryUsecase: GetCategoryUsecase(_categoryRepository),
            deleteCategoryUsecase: DeleteCategoryUsecase(_categoryRepository),
            isCategoryDuplicatedUseCase: IsCategoryDuplicatedUseCase(
              repository: _categoryRepository,
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => IncomeProvider(
            addIncomeUsecase: AddIncomeUsecase(
              repository: _incomeRepositoryImpl,
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => HistoryProvider(
            getIncomesUsecase: GetIncomesUsecase(_historyRepositoryImpl),
            deleteParticularIncomeUsecase: DeleteParticularIncomeUsecase(
              _historyRepositoryImpl,
            ),
          ),
        ),
      ],

      child: MaterialApp(
        builder: (context, child) {
          ThemeHelper.init(context);
          return child!;
        },
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.register: (_) => const RegistrationPage(),
          AppRoutes.forgotPassword: (_) => const ForgotPassword(),
          AppRoutes.dashboard: (_) => const HomePage(),
          AppRoutes.category: (_) => const CategoryPage(),
          AppRoutes.addIncome: (_) => const AddIncomePage(),

        },
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeAnimationDuration: const Duration(milliseconds: 300),
        themeMode: ThemeMode.system,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
