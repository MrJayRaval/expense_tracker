import '../../../../../linux/lib/features/auth/data/repository/auth_repository_impl.dart';
import '../../../../../linux/lib/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  // Sign in test
  test('Shoud call signIn on remote data source', () async {
    const email = 'example@gmail.com';
    const password = 'Example@123';

    when(
      () => mockRemoteDataSource.signIn(email, password),
    ).thenAnswer((_) async {});

    // act
    repository.signIn(email, password);

    verify(() => mockRemoteDataSource.signIn(email, password)).called(1);
    verifyNoMoreInteractions(mockRemoteDataSource);
  });

  test(
    'should throw exception when signIn on remote data source fails',
    () async {
      when(
        () => mockRemoteDataSource.signIn(any(), any()),
      ).thenThrow(Exception('login failed'));

      expectLater(() => repository.signIn('a', 'b'), throwsA(isA<Exception>()));
    },
  );

  // signUp test
  test('Shoud call signUp on remote data source', () async {
    const email = 'example@gmail.com';
    const password = 'Example@123';

    when(
      () => mockRemoteDataSource.signUp(email, password),
    ).thenAnswer((_) async {});

    // act
    repository.signUp(email, password);

    verify(() => mockRemoteDataSource.signUp(email, password)).called(1);
    verifyNoMoreInteractions(mockRemoteDataSource);
  });

  // reset password test
  test(
    'should throw exception when signUp on remote data source fails',
    () async {
      when(
        () => mockRemoteDataSource.signUp(any(), any()),
      ).thenThrow(Exception('login failed'));

      expectLater(() => repository.signUp('a', 'b'), throwsA(isA<Exception>()));
    },
  );

  test('Shoud call resetPassword on remote data source', () async {
    const email = 'example@gmail.com';

    when(
      () => mockRemoteDataSource.resetPassword(email),
    ).thenAnswer((_) async {});

    // act
    repository.resetPassword(email);

    verify(() => mockRemoteDataSource.resetPassword(email)).called(1);
    verifyNoMoreInteractions(mockRemoteDataSource);
  });

  test(
    'should throw exception when resetPassword on remote data source fails',
    () async {
      when(
        () => mockRemoteDataSource.resetPassword(any()),
      ).thenThrow(Exception('reset password failed'));

      expectLater(() => repository.resetPassword('a'), throwsA(isA<Exception>()));
    },
  );
}
