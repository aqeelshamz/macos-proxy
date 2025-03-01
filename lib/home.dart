import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isProxyOn = false;
  TextEditingController urlController = TextEditingController();
  TextEditingController portController = TextEditingController();

  @override
  void initState() {
    checkProxyState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("@aqeelshamz")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isProxyOn ? "Proxy is On" : "Proxy is Off",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isProxyOn ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              isProxyOn
                  ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FeatherIcons.link2),
                          const SizedBox(width: 10),
                          Text(
                            "URL: ${urlController.text}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FeatherIcons.hash),
                          const SizedBox(width: 10),
                          Text(
                            "Port: ${portController.text}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  : const SizedBox.shrink(),
              isProxyOn
                  ? const SizedBox.shrink()
                  : Column(
                    children: [
                      TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          hintText: "URL",
                          prefixIcon: Icon(FeatherIcons.link2),
                        ),
                      ),
                      TextField(
                        controller: portController,
                        decoration: InputDecoration(
                          hintText: "Port",
                          prefixIcon: Icon(FeatherIcons.hash),
                        ),
                      ),
                    ],
                  ),
              const SizedBox(height: 40),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(20),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed:
                    () => {
                      if (isProxyOn) {turnOffProxy()} else {turnOnProxy()},
                    },
                child: Text(isProxyOn ? "Turn Off Proxy" : "Turn On Proxy"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkProxyState() async {
    Process.run('networksetup', [
      '-getsecurewebproxy',
      'Wi-Fi',
    ], runInShell: true).then((ProcessResult results) {
      print(results.stdout.toString());
      Map<String, String> result = {};

      results.stdout.toString().split("\n").forEach((element) {
        if (element.contains(":")) {
          List<String> temp = element.split(":");
          result[temp[0].trim()] = temp[1].trim();
        }
      });

      print(result);

      if (result.containsKey("Enabled") && result["Enabled"] == "Yes") {
        setState(() {
          isProxyOn = true;
        });
      } else {
        setState(() {
          isProxyOn = false;
        });
      }

      if (result.containsKey("Server") && result.containsKey("Port")) {
        urlController.text = result["Server"]!;
        portController.text = result["Port"]!;
      }
    });
  }

  void turnOnProxy() async {
    Process.run('networksetup', [
      '-setsecurewebproxy',
      'Wi-Fi',
      urlController.text,
      portController.text,
    ], runInShell: true).then((ProcessResult results) {
      setState(() {
        isProxyOn = true;
      });
    });
  }

  void turnOffProxy() async {
    Process.run('networksetup', [
      '-setsecurewebproxystate',
      'Wi-Fi',
      'off',
    ], runInShell: true).then((ProcessResult results) {
      setState(() {
        isProxyOn = false;
      });
    });
  }
}
