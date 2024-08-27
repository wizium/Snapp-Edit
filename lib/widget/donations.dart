import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentsBottomSheet extends StatefulWidget {
  const PaymentsBottomSheet({super.key});

  @override
  PaymentsBottomSheetState createState() => PaymentsBottomSheetState();
}

class PaymentsBottomSheetState extends State<PaymentsBottomSheet> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(),
    )
    ..loadRequest(
      Uri.parse(
        'https://wizium.lemonsqueezy.com/buy/85b89701-45eb-4659-8a4c-9c333cedea99?embed=1',
      ),
    );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate Us!"),
        leading: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                CupertinoIcons.chevron_back,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
