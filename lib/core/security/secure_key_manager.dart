import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureKeyManager {
  final FlutterSecureStorage _storage;

  SecureKeyManager(this._storage);

  Future<void> saveKey(String videoId, String key) async {
    await _storage.write(key: 'video_key_$videoId', value: key);
  }

  Future<String?> getKey(String videoId) async {
    return await _storage.read(key: 'video_key_$videoId');
  }

  Future<void> deleteKey(String videoId) async {
    await _storage.delete(key: 'video_key_$videoId');
  }
}
