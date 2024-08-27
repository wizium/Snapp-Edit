import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/cutout.dart';
import '../widget/tool_showcase.dart';
import '../widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.8),
        gradient: const LinearGradient(
          colors: [
            Color(0XFFFFF9D2),
            Color(0XFFFF8473),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 40,
          sigmaY: 40,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const HomeDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.black.withOpacity(.1),
            title: const Text("Snapp Edit"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(2.5),
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: CutoutPro.features.length,
                  itemBuilder: (context, index) {
                    return ToolShowCase(
                      feature: CutoutPro.features[index],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
