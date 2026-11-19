import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickedVaultFile {
  const PickedVaultFile(this.name, this.bytes);
  final String name;
  final Uint8List bytes;
}

class VaultFileGateway {
  Future<PickedVaultFile?> pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'txt'],
      withData: false,
    );
    if (result == null) return null;
    final file = result.files.single;
    if (file.size == 0 || file.size > 5 * 1024 * 1024) {
      throw StateError('Choose a nonempty file up to 5 MiB.');
    }
    final bytes = await file.xFile.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw StateError('File exceeds the 5 MiB limit.');
    }
    return PickedVaultFile(file.name, bytes);
  }

  Future<bool> save(String name, Uint8List bytes) async =>
      await FilePicker.platform.saveFile(fileName: name, bytes: bytes) != null;
}

final vaultFileGatewayProvider = Provider<VaultFileGateway>(
  (ref) => VaultFileGateway(),
);
