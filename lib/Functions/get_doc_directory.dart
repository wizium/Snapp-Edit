import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<Directory> getDocDirectory() async {
  Directory? directory;
  directory = await getApplicationDocumentsDirectory();
  return directory;
}
