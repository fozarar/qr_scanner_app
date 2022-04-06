import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/asd.dart';
import 'package:flutter_application_1/screens/qr_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Controller _controller = Get.put(Controller());
  final TextEditingController _textcontroller = TextEditingController();

  void updateText() {
    _textcontroller.text = _controller.res.string;
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  void dispose() {
    _textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Qr Code Readaer'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Obx(
            (() => Column(
                  children: [
                    ElevatedButton(
                      onPressed: _textcontroller.text.isEmpty
                          ? () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QrCodeScanner(),
                                ),
                              )
                                  .then((_) => setState(() {
                                        updateText();
                                      }))
                                  .then(
                                      (_) => _launchURL(_textcontroller.text));
                            }
                          : () {
                              _textcontroller.clear();
                              setState(() {});
                            },
                      child: _textcontroller.text.isEmpty
                          ? const Text('Press to Scan')
                          : const Text('Clear'),
                    ),
                    Column(
                      children: [
                        Text(_controller.res.string),
                        TextField(
                          controller: _textcontroller,
                          onChanged: (val) {
                            setState(() {
                              val = _textcontroller.text;
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () => _launchURL(_textcontroller.text),
                          child: const Text('Launch URL'),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
