import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_bg_remover/service/adservice.dart';

Future<String?> backGroundRemove({
  required String startImagePath,
  required String targetImagePath,
  required Completer<void> cancelCompleter,
}) async {
  final headers = {
    'authority': 'restapi.cutout.pro',
    'accept': 'application/json, text/plain, */*',
    'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
    'content-type':
        'multipart/form-data; boundary=----WebKitFormBoundaryxEwynLnV45QNG0MG',
    'cookie':
        'ClientFlag=c61c4dcec4984f058fa22dfe0bffb8bc; i18n_redirected=en; token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJhdXRoMCIsImp0aSI6IjQ5MDI4OTc3NjYyMzg3NyJ9.E-kKpJR4GeQemiQn32JaRRUUiFSpjAMMxCRmeNE0Q9bri_R91Ii7w0mvTWgTEaL_3NIIE8E5_MuvhgK46V9iuw',
    'origin': 'https://www.cutout.pro',
    'referer': 'https://www.cutout.pro/',
    'token':
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJhdXRoMCIsImp0aSI6IjQ5MDI4OTc3NjYyMzg3NyJ9.E-kKpJR4GeQemiQn32JaRRUUiFSpjAMMxCRmeNE0Q9bri_R91Ii7w0mvTWgTEaL_3NIIE8E5_MuvhgK46V9iuw',
    'user-agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
    'Accept-Encoding': 'gzip',
  };

  final url = Uri.parse('https://restapi.cutout.pro/webMatting/matting2');

  final request = MultipartRequest('POST', url)
    ..headers.addAll(headers)
    ..files.add(await MultipartFile.fromPath('file', startImagePath))
    ..fields['mattingType'] = '6'
    ..fields['notShowMsg'] = 'true';

  if (cancelCompleter.isCompleted) {
    Fluttertoast.showToast(msg: "Editing canceled");
    return null;
  }

  try {
    Response response = await Response.fromStream(await request.send());

    if (cancelCompleter.isCompleted) {
      Fluttertoast.showToast(msg: "Editing canceled");
      return null;
    }

    if (response.statusCode == 200) {
      final imageUrl = jsonDecode(response.body)["data"]["bgRemoved"];

      await get(Uri.parse(imageUrl)).then((value) {
        if (!cancelCompleter.isCompleted) {
          File(targetImagePath).writeAsBytesSync(
            value.bodyBytes,
          );
        }
      });
      Fluttertoast.showToast(msg: "Removed successfully");
      AdServices().showInterstitialAd(() {
        AdServices().interstitialAdLoad();
      });
      return targetImagePath;
    } else {
      Fluttertoast.showToast(msg: "Error");
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error");
    return null;
  }
}
