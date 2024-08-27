import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';
import '../models/feature_model.dart';

class CutoutPro {
  static List features = [
    Feature(
      title: "Image Background Remover",
      description:
          "Create a transparent background instantly and turn your images into art, stunning banners, visual presentations, product catalogs and graphics.",
      image: "backgroundRemover",
    ),
    Feature(
      title: "AI Image Enhancer",
      description:
          "Fix pixelated, blurry, and low-quality photos instantly with online image enhancer for printing, social media, marketing campaigns, presentations, and more.",
      image: "imageEnhancer",
    ),
    Feature(
      title: "Colorize B&W Photos",
      description:
          "By using AI image coloring algorithms trained on black and white photos, our image colorizer adds natural and realistic colors to your old photos.",
      image: "b&wToColor",
    ),
    Feature(
      title: "Ai Natural Color Blend",
      description:
          "Using AI-powered colorization algorithms trained on millions of photos, our image colorizer seamlessly blends natural and realistic colors into your images, enhancing them with vivid and lifelike hues.",
      image: "colorEnhancer",
    ),
  ];
  static String baseUrl = "https://restapi.cutout.pro";

  static Map<String, String> headers = {
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
  static Future<String?> backGroundRemover({
    required String startImagePath,
    required String targetImagePath,
    required Completer<void> cancelCompleter,
  }) async {
    final url = Uri.parse('$baseUrl/webMatting/matting2');
    final request = MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(await MultipartFile.fromPath('file', startImagePath))
      ..fields['mattingType'] = '6'
      ..fields['notShowMsg'] = 'true';
    if (cancelCompleter.isCompleted) {
      Fluttertoast.showToast(msg: "Process canceled");
      return null;
    }

    try {
      Response response = await Response.fromStream(await request.send());
      log(response.body);
      if (cancelCompleter.isCompleted) {
        Fluttertoast.showToast(msg: "Process canceled");
        return null;
      }

      if (response.statusCode == 200) {
        final imageUrl = jsonDecode(response.body)["data"]["bgRemoved"];
        log(imageUrl);

        final imageData = await get(Uri.parse(imageUrl));
        if (imageData.statusCode == 200) {
          if (!cancelCompleter.isCompleted) {
            final decodedImage = decodeImage(imageData.bodyBytes);

            if (decodedImage != null) {
              final pngBytes = encodePng(decodedImage);
              File(targetImagePath).writeAsBytesSync(pngBytes);
              log('Image saved as PNG at $targetImagePath');
            } else {
              log('Failed to decode image');
            }
          }
        } else {
          log('Failed to download image: ${imageData.statusCode}');
        }
        Fluttertoast.showToast(msg: "Processed successfully");
        return targetImagePath;
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      return null;
    }
  }

  static Future<String?> colorEnhancer({
    required String startImagePath,
    required String targetImagePath,
    required Completer<void> cancelCompleter,
  }) async {
    final url = Uri.parse('$baseUrl/webMatting/matting2');
    final request = MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(await MultipartFile.fromPath('file', startImagePath))
      ..fields['mattingType'] = '4'
      ..fields['notShowMsg'] = 'true';
    if (cancelCompleter.isCompleted) {
      Fluttertoast.showToast(msg: "Process canceled");
      return null;
    }

    try {
      Response response = await Response.fromStream(await request.send());
      log(response.body);
      if (cancelCompleter.isCompleted) {
        Fluttertoast.showToast(msg: "Process canceled");
        return null;
      }

      if (response.statusCode == 200) {
        final imageUrl = jsonDecode(response.body)["data"]["bgRemoved"];
        log(imageUrl);

        final imageData = await get(Uri.parse(imageUrl));
        if (imageData.statusCode == 200) {
          log(imageData.headers.toString());
          if (!cancelCompleter.isCompleted) {
            final decodedImage = decodeImage(imageData.bodyBytes);

            if (decodedImage != null) {
              final pngBytes = encodePng(decodedImage);
              File(targetImagePath).writeAsBytesSync(pngBytes);
              log('Image saved as PNG at $targetImagePath');
            } else {
              log('Failed to decode image');
            }
          }
        } else {
          log('Failed to download image: ${imageData.statusCode}');
        }
        Fluttertoast.showToast(msg: "Processed successfully");
        return targetImagePath;
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      return null;
    }
  }

  static Future<String?> bAndWToColor({
    required String startImagePath,
    required String targetImagePath,
    required Completer<void> cancelCompleter,
  }) async {
    final url = Uri.parse('$baseUrl/webMatting/matting2');

    final request = MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(await MultipartFile.fromPath('file', startImagePath))
      ..fields['mattingType'] = '19'
      ..fields['notShowMsg'] = 'true';
    if (cancelCompleter.isCompleted) {
      Fluttertoast.showToast(msg: "Process canceled");
      return null;
    }

    try {
      Response response = await Response.fromStream(await request.send());
      log(response.body);
      if (cancelCompleter.isCompleted) {
        Fluttertoast.showToast(msg: "Process canceled");
        return null;
      }

      if (response.statusCode == 200) {
        final imageUrl = jsonDecode(response.body)["data"]["bgRemoved"];
        log(imageUrl);

        final imageData = await get(Uri.parse(imageUrl));
        if (imageData.statusCode == 200) {
          if (!cancelCompleter.isCompleted) {
            final decodedImage = decodeImage(imageData.bodyBytes);

            if (decodedImage != null) {
              final pngBytes = encodePng(decodedImage);
              File(targetImagePath).writeAsBytesSync(pngBytes);
              log('Image saved as PNG at $targetImagePath');
            } else {
              log('Failed to decode image');
            }
          }
        } else {
          log('Failed to download image: ${imageData.statusCode}');
        }
        // Fluttertoast.showToast(msg: "Processed successfully");
        return targetImagePath;
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      return null;
    }
  }

  static Future<String?> photoEnhancer({
    required String startImagePath,
    required String targetImagePath,
    required Completer<void> cancelCompleter,
  }) async {
    final url = Uri.parse('$baseUrl/oss/upload');
    final request = MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(await MultipartFile.fromPath('file', startImagePath));

    if (cancelCompleter.isCompleted) {
      Fluttertoast.showToast(msg: "Process canceled");
      return null;
    }

    try {
      Response response = await Response.fromStream(await request.send());
      log(response.body);

      if (cancelCompleter.isCompleted) {
        Fluttertoast.showToast(msg: "Process canceled");
        return null;
      }

      if (response.statusCode == 200) {
        final params = {
          'imageUrl': jsonDecode(response.body)["data"],
          "faceModel": "gpen512"
        };
        final url =
            Uri.parse('$baseUrl/webMatting/photoEnhancer/submitTaskByUrl')
                .replace(queryParameters: params);
        final res = await get(url, headers: headers);
        log(res.body);

        if (res.statusCode == 200) {
          String taskId = (jsonDecode(res.body)["data"]).toString();

          // Polling loop
          while (true) {
            final response = await get(
              Uri.parse("$baseUrl/webMatting/photoEnhancer/getTaskInfo")
                  .replace(queryParameters: {"id": taskId}),
              headers: headers,
            );
            log(response.body);

            if (response.statusCode == 200) {
              final data = jsonDecode(response.body)["data"];
              final image = data["bgRemovedPreview"];

              if (image != null) {
                final imageUrl = data["bgRemovedPreview"];
                log(imageUrl);

                final imageData = await get(Uri.parse(imageUrl));
                if (imageData.statusCode == 200) {
                  if (!cancelCompleter.isCompleted) {
                    final decodedImage = decodeImage(imageData.bodyBytes);

                    if (decodedImage != null) {
                      final pngBytes = encodePng(decodedImage);
                      File(targetImagePath).writeAsBytesSync(pngBytes);
                      log('Image saved as PNG at $targetImagePath');
                    } else {
                      log('Failed to decode image');
                    }
                  }
                  break;
                } else {
                  log('Failed to download image: ${imageData.statusCode}');
                  return null;
                }
              } else {
                log("Processing... Waiting for completion.");
              }
            } else {
              log('Failed to get task info: ${response.statusCode}');
              return null;
            }

            if (cancelCompleter.isCompleted) {
              Fluttertoast.showToast(msg: "Process canceled");
              return null;
            }
          }
          Fluttertoast.showToast(msg: "Processed successfully");
          return targetImagePath;
        } else {
          Fluttertoast.showToast(msg: "Something went wrong");
          return null;
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      return null;
    }
  }
}
