import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_well_app/screen/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InAppWebViewController? webViewController;
  PullToRefreshController? rcontroller;
  TextEditingController? txtUrl = TextEditingController();
  HomeProvider? providerR;
  HomeProvider? providerW;

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().checkinternet();
    rcontroller = PullToRefreshController(onRefresh: () {
      webViewController!.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    providerR = context.read<HomeProvider>();
    providerW = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Browser App"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    providerR!.getData();
                    showsheet(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_add),
                      Text("BookMark"),
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: providerW!.isOn == false
          ? Center(
              child: Image.asset(
                "assets/image/wifi.png",
                width: 150,
                height: 150,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: WebUri("https://www.google.com/search?q="),),
                    onProgressChanged: (controller, progress) {
                      providerR!.changeProgress(progress / 100);
                      webViewController = controller;
                      if (progress == 100) {
                        rcontroller!.endRefreshing();
                      }
                    },
                    onLoadStart: (controller, url) {
                      webViewController = controller;
                    },
                    onLoadStop: (controller, url) {
                      rcontroller!.endRefreshing();
                      webViewController = controller;
                    },
                    pullToRefreshController: rcontroller,
                  ),
                ),
                LinearProgressIndicator(
                  value: providerW!.progress,
                ),
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    controller: txtUrl,
                    decoration: InputDecoration(
                      hintText: "Search Here ",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            webViewController?.loadUrl(
                              urlRequest: URLRequest(
                                url: WebUri(
                                    "https://www.google.com/search?q=${txtUrl!.text}"),
                              ),
                            );
                          },
                          icon: const Icon(Icons.search_rounded)),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          webViewController?.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri("https://www.google.com/search?q="),
                            ),
                          );
                          txtUrl!.clear();
                        },
                        icon: const Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: () async {
                          String url =
                              (await webViewController!.getUrl()).toString();
                          providerR!.setData(url);
                        },
                        icon: const Icon(Icons.bookmark_add_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          webViewController!.goBack();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          webViewController!.reload();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      IconButton(
                        onPressed: () {
                          webViewController!.goForward();
                        },
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void showsheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: providerR!.book.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: InkWell(
                      onTap: () {
                        webViewController?.loadUrl(
                          urlRequest: URLRequest(
                            url: WebUri(providerW!.book[index]),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Text(providerR!.book[index]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
