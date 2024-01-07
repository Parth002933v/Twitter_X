import 'package:appwrite/appwrite.dart' as ap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_x/constants/constants.dart';

final AppwriteClientProvider = Provider<ap.Client>((ref) {
  ap.Client client = ap.Client();
  client
      .setEndpoint(AppWriteConstants.endPoint)
      .setProject(AppWriteConstants.projectID)
      .setSelfSigned(status: true);
  return client;
});

final appwriteAccountProvider = Provider<ap.Account>((ref) {
  final client = ref.watch(AppwriteClientProvider);
  final account = ap.Account(client);
  return account;
});

final appwriteDatabaseProvider = Provider<ap.Databases>((ref) {
  final client = ref.watch(AppwriteClientProvider);
  final databases = ap.Databases(client);
  return databases;
});

final appwriteStorageProvider = Provider<ap.Storage>((ref) {
  final client = ref.watch(AppwriteClientProvider);
  final storage = ap.Storage(client);
  return storage;
});

final appwriteRealtimeProvider = Provider((ref) {
  final client = ref.watch(AppwriteClientProvider);
  return ap.Realtime(client);
});
