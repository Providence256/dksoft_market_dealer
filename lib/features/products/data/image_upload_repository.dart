import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageUploadRepository {
  ImageUploadRepository(this._storage);
  final FirebaseStorage _storage;

  /// Uploads one local asset (e.g. a category thumbnail) to [storagePath]
  /// and returns its public download URL.
  Future<String> uploadImageFromAsset({
    required String assetPath,
    required String storagePath,
  }) async {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    final ref = _storage.ref(storagePath);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
    return ref.getDownloadURL();
  }

  Future<List<String>> uploadProductImageFromAsset(
    List<String> assetPaths,
    String productId,
  ) async {
    final downloadUrls = <String>[];

    for (var i = 0; i < assetPaths.length; i++) {
      final assetPath = assetPaths[i];
      final byteData = await rootBundle.load(assetPath);
      final components = assetPath.split('/');
      final filename = components.last;

      final url = await _uploadAsset(
        byteData: byteData,
        filename: filename,
        productId: productId,
        index: i,
      );

      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  Future<String> _uploadAsset({
    required ByteData byteData,
    required String filename,
    required String productId,
    required int index,
  }) async {
    final bytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    final ref = _storage.ref('products/$productId/$index-$filename');

    final uploadTask = await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return uploadTask.ref.getDownloadURL();
  }
}

final imageUploadRepositoryProvider = Provider<ImageUploadRepository>((ref) {
  return ImageUploadRepository(FirebaseStorage.instance);
});
