import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrchat/services/auth_storage_service.dart';

// 認証情報ストレージのプロバイダー
final authStorageProvider = Provider<AuthStorageService>((ref) {
  return AuthStorageService();
});
