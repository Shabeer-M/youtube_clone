import 'dart:io';
import 'package:crypto/crypto.dart';

class FileIntegrityChecker {
  Future<String> calculateFileHash(File file) async {
    if (!await file.exists()) {
      throw FileSystemException('File not found', file.path);
    }
    final stream = file.openRead();
    final digest = await sha256.bind(stream).first;
    return digest.toString();
  }

  Future<bool> verifyFileIntegrity(File file, String expectedHash) async {
    try {
      final actualHash = await calculateFileHash(file);
      return actualHash == expectedHash;
    } catch (e) {
      return false;
    }
  }
}
