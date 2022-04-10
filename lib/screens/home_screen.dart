import 'package:flutter/material.dart';
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
          title: const Text('Qr Code Scanner'),
        ),
        body: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _textcontroller.text.isEmpty
                      ? () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QrCodeScanner(),
                            ),
                          )
                              .then((_) => setState(() {
                                    updateText();
                                  }))
                              .then((_) {
                            if (_textcontroller.text.isURL) {
                              _launchURL(_textcontroller.text);
                            }
                          });
                        }
                      : () {
                          _textcontroller.clear();
                          setState(() {});
                        },
                  child: _textcontroller.text.isEmpty
                      ? const Text(
                          'Press to Scan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text('Clear'),
                ),
                TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      fillColor: Colors.white70),
                  controller: _textcontroller,
                  onChanged: (val) {
                    setState(() {
                      val = _textcontroller.text;
                    });
                  },
                ),
                const SizedBox(height: 32),
              ],
            )),
      ),
    );
  }
}
