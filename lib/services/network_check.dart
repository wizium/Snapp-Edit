import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> checkNetworkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    Fluttertoast.showToast(msg: "No internet connection");
    return false;

  } else {
    
    return true;
  }
}
