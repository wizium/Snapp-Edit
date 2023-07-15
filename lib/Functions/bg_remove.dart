import 'dart:io';
import 'package:http/http.dart';
Future<String?> backGroundRemove({
  required String startImagePath,
  required String targetImagePath,
}) async {
  MultipartRequest request = MultipartRequest(
    'POST',
    Uri.parse(
      "https://clipdrop-api.co/remove-background/v1",
    ),
  );
  request.headers["accept"] = "image/webp";
  request.headers["x-api-key"] =
      "abb480860755da5826505f2f1baa7a0b9b500d8549d8d01ee3778c7c3aea814f65fbdc72ce1f0e9315eabb4a42121ae1";
  request.files.add(
    MultipartFile.fromBytes(
      "image_file",
      File(startImagePath).readAsBytesSync(),
      filename: startImagePath.split("/").last,
    ),
  );
  StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    await response.stream.pipe(
      File(targetImagePath).openWrite(),
    );
    return targetImagePath;
  } else {
    return null;
  }
}