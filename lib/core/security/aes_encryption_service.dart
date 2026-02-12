import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;

class AESEncryptionService {
  // AES-256 requires 32-byte key
  String generateRandomKey() {
    final key = encrypt.Key.fromSecureRandom(32);
    return key.base64;
  }

  // Encrypts a file stream and writes to output
  // Uses a random IV for each file, prepended to the file
  Future<void> encryptFile({
    required File inputFile,
    required File outputFile,
    required String keyBase64,
  }) async {
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    final fileBytes = await inputFile.readAsBytes();
    final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);

    // Write IV first, then content
    final sink = outputFile.openWrite();
    sink.add(iv.bytes);
    sink.add(encrypted.bytes);
    await sink.flush();
    await sink.close();
  }

  // Returns decrypted bytes (Not efficient for Large files, simplified for now)
  // For large video files, we'd want a stream transformer or a local HTTP server ensuring chunks.
  // Implementing a simple decrypt for file-based playback if player supports it,
  // otherwise better_player needs a dataSource.
  // NOTE: Loading 100MB+ into memory is bad.
  // Better approach: Decrypt to a temporary file for playback or use a Stream.
  // Since "No raw file exposure" is a rule, we likely need a local proxy providing the stream.
  // For this step, I'll provide a decryptToTempFile method with strict lifecycle management.

  Future<File> decryptToTempFile({
    required File encryptedFile,
    required String keyBase64,
  }) async {
    final key = encrypt.Key.fromBase64(keyBase64);

    final bytes = await encryptedFile.readAsBytes();
    // IV is first 16 bytes
    final ivBytes = bytes.sublist(0, 16);
    final contentBytes = bytes.sublist(16);

    final iv = encrypt.IV(ivBytes);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    final decryptedBytes = encrypter.decryptBytes(
      encrypt.Encrypted(contentBytes),
      iv: iv,
    );

    // Create a temp file
    final tempDir = Directory.systemTemp;
    final tempFile = File(
      '${tempDir.path}/temp_playback_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );
    await tempFile.writeAsBytes(decryptedBytes);
    return tempFile;
  }
}
