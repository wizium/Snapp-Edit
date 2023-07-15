import 'package:image_picker/image_picker.dart';

Future<String?> pickImage() async {
  ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    return image.path;
  } else {
    return null;
  }
}
