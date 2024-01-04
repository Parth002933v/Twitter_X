import 'package:appwrite/appwrite.dart' as ap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_x_three/constants/constants.dart';

final clientProvider = Provider<ap.Client>((ref) {
  ap.Client client = ap.Client();
  client
      .setEndpoint(AppWriteConstants.endPoint)
      .setProject(AppWriteConstants.projectID)
      .setSelfSigned(status: true);
  return client;
});

final accountProvider = Provider<ap.Account>((ref) {
  final client = ref.watch(clientProvider);
  final account = ap.Account(client);
  return account;
});

final databaseProvider = Provider<ap.Databases>((ref) {
  final client = ref.watch(clientProvider);
  final databases = ap.Databases(client);
  return databases;
});
final storageProvider = Provider<ap.Storage>((ref) {
  final client = ref.watch(clientProvider);
  final storage = ap.Storage(client);
  return storage;
});
// final userProvider = Provider<ap.Storage>((ref) {
//   final client = ref.watch(clientProvider);
//   final storage = ap.Account;
//   return storage;
// });
