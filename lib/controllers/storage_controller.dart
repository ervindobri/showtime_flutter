import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageController {
  final FlutterSecureStorage storage;

  const StorageController({required this.storage});

  // Save email & info
  Future<void> saveInfo(Map<String, dynamic> data) async{
    data.forEach((key, value) async {
      await storage.write(key: key, value: value);
    });
  }

  Future<String?> read({required String key}) async {
    return await storage.read(key: key);
  }
}
