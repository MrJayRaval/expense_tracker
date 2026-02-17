import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/homepage/features/dashboard/presenation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/homepage/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:expense_tracker/features/homepage/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'ui/components/theme_provider.dart';
import 'config/theme_helper.dart';
import 'config/themes.dart';
import 'config/default_categories.dart';
import 'features/homepage/features/history/data/datasources/history_local_datasource_impl.dart';
import 'features/homepage/features/history/data/datasources/history_remote_datasource_impl.dart';
import 'features/homepage/features/history/data/repository/history_repository_impl.dart';
import 'features/homepage/features/history/domain/usecases/delete_particular_transaction_usecase.dart';
import 'features/homepage/features/history/domain/usecases/get_transaction_usecase.dart';
import 'features/homepage/features/history/domain/usecases/group_by_date_usecase.dart';
import 'features/homepage/features/history/domain/usecases/update_transaction_usecase.dart';
import 'features/homepage/features/history/presenation/providers/history_provider.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/domain/usecases/reset_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/screen/forget_password.dart';
import 'features/auth/presentation/screen/registration_page.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/homepage/features/category/data/datasources/category_local_datasource.dart';
import 'features/homepage/features/category/data/datasources/category_remote_datasource.dart';
import 'features/homepage/features/category/data/repository/category_repository_impl.dart';
import 'features/homepage/features/category/domain/usecases/add_category_usecase.dart';
import 'features/homepage/features/category/domain/usecases/delete_category_usecase.dart';
import 'features/homepage/features/category/domain/usecases/get_category_usecase.dart';
import 'features/homepage/features/category/domain/usecases/is_category_duplicated.dart';
import 'features/homepage/features/category/presenation/providers/category_provider.dart';
import 'features/homepage/data/data/user_repository.dart';
import 'features/homepage/data/datasources/user_remote_data_source.dart';
import 'features/homepage/domain/usecases/fetch_user_details_usecase.dart';
import 'features/homepage/presentation/providers/homepage_provider.dart';
import 'features/homepage/presentation/screens/homepage.dart';
import 'features/auth/features/create_profile/data/datasources/profile_remote_data_sources.dart';
import 'features/auth/features/create_profile/presentation/provider/profile_provider.dart';
import 'features/homepage/features/transaction/data/datasource/add_transaction_datasource_impl.dart';
import 'features/homepage/features/transaction/presentaion/provider/transaction_provider.dart';
import 'features/splash_screen.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/screen/login_page.dart';
import 'routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
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

  await Future.wait([
    Hive.openBox(TransactionType.expense.name),
    Hive.openBox(TransactionType.income.name),
    Hive.openBox('analysisOf${TransactionType.expense.name}'),
    Hive.openBox('analysisOf${TransactionType.income.name}'),
    Hive.openBox('expenseCategory'),
    Hive.openBox('incomeCategory'),
    Hive.openBox('sourceCategory'),
    Hive.openBox('settings'),
  ]);

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
  late final CategoryRepositoryImpl _incomeCategoryRepository;
  late final CategoryRepositoryImpl _sourceRepository;
  late final UserDetailsRepositoryImpl _userRepository;
  late final TransactionRepositoryImpl _transactionRepositoryImpl;
  late final HistoryRepositoryImpl _historyRepositoryImpl;

  @override
  void initState() {
    super.initState();
    // Initialize repositories once to avoid duplicate instantiation
    _authRepository = AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(FirebaseAuth.instance),
    );

    _categoryRepository = CategoryRepositoryImpl(
      local: CategoryLocalDatasource('expenseCategory'),
      remote: CategoryRemoteDatasource(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
        'categories',
      ),
      defaultCategories: defaultExpenseCategories,
    );

    _incomeCategoryRepository = CategoryRepositoryImpl(
      local: CategoryLocalDatasource('incomeCategory'),
      remote: CategoryRemoteDatasource(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
        'incomeCategories',
      ),
      defaultCategories: defaultIncomeCategories,
    );

    _sourceRepository = CategoryRepositoryImpl(
      local: CategoryLocalDatasource('sourceCategory'),
      remote: CategoryRemoteDatasource(
        FirebaseFirestore.instance,
        FirebaseAuth.instance,
        'sourceCategories',
      ),
      defaultCategories: defaultSourceCategories,
    );

    _userRepository = UserDetailsRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    );

    _transactionRepositoryImpl = TransactionRepositoryImpl(
      remote: TransactionDataSourceImpl(
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
          create: (_) => AuthProvider(
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
          create: (_) => HomePageProvider(
            fetchUserDetailsUsecase: FetchUserDetailsUsecase(_userRepository),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => ExpenseCategoryProvider(
            addCategoryUsecase: AddCategoryUsecase(_categoryRepository),
            getCategoryUsecase: GetCategoryUsecase(_categoryRepository),
            deleteCategoryUsecase: DeleteCategoryUsecase(_categoryRepository),
            isCategoryDuplicatedUseCase: IsCategoryDuplicatedUseCase(
              repository: _categoryRepository,
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => IncomeCategoryProvider(
            addCategoryUsecase: AddCategoryUsecase(_incomeCategoryRepository),
            getCategoryUsecase: GetCategoryUsecase(_incomeCategoryRepository),
            deleteCategoryUsecase: DeleteCategoryUsecase(
              _incomeCategoryRepository,
            ),
            isCategoryDuplicatedUseCase: IsCategoryDuplicatedUseCase(
              repository: _incomeCategoryRepository,
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => SourceProvider(
            addCategoryUsecase: AddCategoryUsecase(_sourceRepository),
            getCategoryUsecase: GetCategoryUsecase(_sourceRepository),
            deleteCategoryUsecase: DeleteCategoryUsecase(_sourceRepository),
            isCategoryDuplicatedUseCase: IsCategoryDuplicatedUseCase(
              repository: _sourceRepository,
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => TransactionProvider(
            addTransactionUsecase: AddTransactionUsecase(
              repository: _transactionRepositoryImpl,
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => HistoryProvider(
            historyLocalDataSource: HistoryLocalDatasourceImpl(),
            getTransactionUsecase: GetTransactionsUsecase(
              _historyRepositoryImpl,
            ),
            deleteParticularTransactionUsecase:
                DeleteParticularTransactionUsecase(_historyRepositoryImpl),
            updateTransactionUsecase: UpdateTransactionUsecase(
              repository: _historyRepositoryImpl,
            ),
            groupByDateUseCase: GroupByDateUseCase(
              repository: _historyRepositoryImpl,
            ),
          ),
        ),

        ChangeNotifierProxyProvider<HistoryProvider, DashboardProvider>(
          create: (_) => DashboardProvider(),
          update: (context, historyProvider, dashboardProvider) {
            dashboardProvider!.updateData(
              historyProvider.incomeTransactions,
              historyProvider.expenseTransactions,
            );
            return dashboardProvider;
          },
        ),

        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            builder: (context, child) {
              ThemeHelper.init(context);
              return child!;
            },
            routes: {
              AppRoutes.login: (_) => const LoginPage(),
              AppRoutes.register: (_) => const RegistrationPage(),
              AppRoutes.forgotPassword: (_) => const ForgotPassword(),
              AppRoutes.dashboard: (_) => const HomePage(),
            },
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeAnimationDuration: const Duration(milliseconds: 300),
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
