import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static Future<Directory> createDirectory(String directoryName) async {
    final directory = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/$directoryName');
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}
