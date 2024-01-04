import 'package:appwrite/models.dart' as model;
import 'package:fpdart/fpdart.dart';
import 'faliure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = Future<Either<Failure, void>>;
