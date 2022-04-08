import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinterest/pages/prifile_page.dart';
import 'package:pinterest/pages/search_page.dart';
import 'package:pinterest/services/photo_api.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pinterest/services/show_midd_screen.dart';
import 'package:http/http.dart' as http;
import 'message.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<String>? listPhotos;
  List<int>? listLikes;
  List<String>? listDownload;
  int count = 10;
  bool isLoading = false;

  List<String> addList = [];

  double loadingProsres = 0;
  bool inWay = true;
  bool toDown = true;
  double dowIconSize = 100;
  int countProg = 0;
  bool succes = false;
  double downloadX = 0;
  double downloadY = 0;

  final textStyle = const TextStyle(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);

  @override
  void initState() {
    PhotoApi.GET("/photos/random?count=12").then((value) {
      if (value != null) {
        listLikes =
            List.generate(value.length, (index) => value[index]["likes"]);
      }
      print(listLikes);
      setState(() {});
    });
    PhotoApi.GET("/photos/random?count=12").then((value) {
      if (value != null) {
        listPhotos = List.generate(
            value.length, (index) => value[index]["urls"]["small"]);
      }
      print(listPhotos);

      setState(() {});
    });

    super.initState();
  }

  _loadAddPhotos() async {
    await PhotoApi.GET("/photos/random?count=12").then((value) {
      if (value != null) {
        for (int i = 0; i < 12; i++) {
          listLikes!.add(value[i]["likes"]);
        }
      }
      print(listLikes);
    });

    PhotoApi.GET("/photos/random?count=12").then((value) {
      if (value != null) {
        for (int i = 0; i < 12; i++) {
          listPhotos!.add(value[i]["urls"]["small"]);
        }
        print(listPhotos!.length);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            body:
                TabBarView(physics: NeverScrollableScrollPhysics(), children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          width: 140,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Все пины",
                            style: textStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 60),
                      child: Stack(
                        children: [
                          listPhotos != null && listLikes != null
                              ? LazyLoadScrollView(
                                  isLoading: false,
                                  onEndOfPage: _loadAddPhotos,
                                  scrollOffset: 100,
                                  child: SingleChildScrollView(
                                    child: StaggeredGrid.count(
                                      crossAxisCount: 2,
                                      children: List.generate(
                                          listPhotos!.length, (index) {
                                        return _item(index);
                                      }),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: SpinKitChasingDots(
                                    itemBuilder: (context, index) {
                                      final colors = [
                                        Colors.blue,
                                        Colors.purpleAccent,
                                      ];

                                      final color =
                                          colors[index % colors.length];

                                      return DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle));
                                    },
                                  ),
                                ),
                          isLoading
                              ? Container(
                                  alignment: Alignment(downloadX, downloadY),
                                  child: inWay
                                      ? Icon(
                                          Icons.download_rounded,
                                          color: Colors.greenAccent.shade700,
                                          size: dowIconSize,
                                        )
                                      : succes
                                          ? Container(
                                              alignment: Alignment(-0.9, 1.2),
                                              child: Icon(
                                                Icons.check_circle,
                                                color:
                                                    Colors.greenAccent.shade700,
                                                size: 45,
                                              ),
                                            )
                                          : Stack(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              children: [
                                                SizedBox(
                                                  width: 45,
                                                  height: 45,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProsres,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.greenAccent
                                                                .shade700),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    "$countProg%",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ))
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SearchPage(),
              MessagePage(),
              ProfilePage(),
            ]),
            bottomNavigationBar: TabBar(
                indicatorColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade600,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      size: 35,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.search,
                      size: 35,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.messenger,
                      size: 35,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.person,
                      size: 35,
                    ),
                  ),
                ])),
      ),
    );
  }

  _isLoad(String uri, String name) {
    setState(() {
      isLoading = true;
    });
    Timer.periodic(Duration(milliseconds: 10), (t) {
      setState(() {
        if (toDown) {
          downloadY -= 0.05;
          if (downloadY < -0.35) {
            toDown = false;
          }
        } else {
          dowIconSize -= 2;
          downloadX -= 0.055;
          downloadY += 0.1;
        }
        if (downloadY >= 1.19) {
          inWay = false;
          downloadX = -0.9;
          downloadY = 1.21;
          t.cancel();
          downloadFile(uri, name);
        }
      });
    });
  }

  _showFullScreen(String uri, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            maxChildSize: 1,
            minChildSize: 0.7,
            initialChildSize: 0.965,
            builder: (_, scrollController) {
              return Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: SpinKitChasingDots(
                        itemBuilder: (context, index) {
                          final colors = [
                            Colors.blue,
                            Colors.purpleAccent,
                          ];

                          final color = colors[index % colors.length];

                          return DecoratedBox(
                              decoration: BoxDecoration(
                                  color: color, shape: BoxShape.circle));
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              uri,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.8),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 74,
                        color: Colors.white70.withOpacity(0.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              iconSize: 35,
                              onPressed: () {},
                              icon: Icon(
                                Icons.messenger_sharp,
                                color: Colors.black,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              shape: StadiumBorder(),
                              color: Colors.grey.shade200,
                              minWidth: 120,
                              height: 50,
                              child: Text("Прочитать",
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _statusDialog(uri, name);
                              },
                              shape: StadiumBorder(),
                              minWidth: 120,
                              height: 50,
                              color: Colors.red,
                              child: Text("Сохранить",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                            IconButton(
                              iconSize: 35,
                              onPressed: () {
                                Navigator.pop(context);
                                _shareImage(uri, name);
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  _item(index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            _showFullScreen(
                listPhotos![index], "${Random().nextInt(10000)}.jpg");
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: listPhotos![index],
                height: index % 3 == 0 || index % 7 == 0 ? 170 : 250,
                width: 3000,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    decoration: BoxDecoration(
                        color: index % 3 == 0 || index % 7 == 0
                            ? index % 5 == 0
                                ? Colors.red.shade400
                                : Colors.lime.shade900
                            : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(15)),
                    height: index % 3 == 0 || index % 7 == 0 ? 170 : 250,
                    width: 3000,
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    decoration: BoxDecoration(
                        color: index % 3 == 0 || index % 7 == 0
                            ? index % 5 == 0
                                ? Colors.red.shade400
                                : Colors.lime.shade900
                            : Colors.blueGrey,
                        borderRadius: BorderRadius.circular(15)),
                    height: index % 3 == 0 || index % 7 == 0 ? 170 : 250,
                    width: 3000,
                  );
                },
              ),
            ),
            margin: EdgeInsets.only(top: 10, right: 5, left: 5),
            height:
                index % 2 == 0 || index % 3 == 0 || index % 7 == 0 ? 170 : 250,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  Text(listLikes![index].toString()),
                ],
              ),
            ),
            IconButton(
                splashRadius: 20,
                iconSize: 24,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _showMiddScrenn(
                      listPhotos![index], "${Random().nextInt(10000)}.jpg");
                },
                icon: Icon(Icons.more_horiz))
          ],
        )
      ],
    );
  }

  Future<void> downloadFile(String uri, String name) async {
    Directory? directory;
    try {
      _getPermission(Permission.storage).then((value) async {
        if (value != false) {
          directory = await getExternalStorageDirectory();
          print(directory!.path);

          String newPath = "";

          List<String> folders = directory!.path.split("/");
          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];

            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }

          newPath += "/Pinterest/images";

          final file = File('$newPath/$name');

          Dio dio = Dio();

          await dio.download(uri, file.path, onReceiveProgress: (res, total) {
            setState(() {
              loadingProsres = (res / total);
              List<String> str = ((res / total) * 100).toString().split(".");
              countProg = int.parse(str[0]);
            });
            print((res / total) * 100);
          });

          setState(() {
            succes = true;
          });

          await Future.delayed(Duration(milliseconds: 2000));

          setState(() {
            isLoading = false;
            double loadingProsres = 0;
            inWay = true;
            toDown = true;
            dowIconSize = 100;
            countProg = 0;
            succes = false;

            downloadX = 0;
            downloadY = 0;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _showMiddScrenn(String uri, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          maxChildSize: 1,
          minChildSize: 0.3,
          initialChildSize: 0.7,
          builder: (_, scrollController) {
            return Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconSize: 40,
                            icon: Icon(
                              Icons.transit_enterexit_rounded,
                              color: Colors.black,
                            )),
                        Text(
                          "Поделиться",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _shareImage(uri, name);
                            },
                            child: Mass(
                                iconSize: 25,
                                iconColor: Colors.white,
                                color: Colors.red,
                                icon: Icons.send,
                                title: "Отправить"),
                          ),
                          Mass(
                              iconSize: 40,
                              iconColor: Colors.blue,
                              color: Colors.blueGrey.shade100,
                              icon: Icons.g_mobiledata,
                              title: "Gmail"),
                          Mass(
                              iconSize: 40,
                              iconColor: Colors.red,
                              color: Colors.grey.shade100,
                              icon: Icons.e_mobiledata_outlined,
                              title: "Эл. почта"),
                          Mass(
                              iconSize: 25,
                              iconColor: Colors.white,
                              color: Colors.blue,
                              icon: Icons.message,
                              title: "Сообщения"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _statusDialog(uri, name);
                          },
                          child: Text(
                            "Скачать изображение",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Скрить пин",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Жалоба на пин",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                        "Не соответствует правилам сообщества\nPinterest",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _statusDialog(String uri, String name) async {
    final response = await http.get(Uri.parse(uri));
    double sizeMG = response.contentLength! / (1024);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          title: Text(
            "Скачать изображение⚠️",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "$sizeMG".substring(0, 4) + "  KB\nВы можете скачать его❓",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  _isLoad(uri, name);
                },
                child: Text("📥Скачать")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("❌Отмена")),
          ],
        );
      },
    );
  }

  Future<bool> _getPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();

      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> _shareImage(String uri, String name) async {
    Directory? directory;
    try {
      _getPermission(Permission.storage).then((value) async {
        if (value != false) {
          directory = await getExternalStorageDirectory();
          print(directory!.path);

          String newPath = "";

          List<String> folders = directory!.path.split("/");
          for (int i = 1; i < folders.length; i++) {
            String folder = folders[i];

            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }

          newPath += "/Pinterest/images";

          final file = File('$newPath/$name');

          Dio dio = Dio();

          await dio.download(uri, file.path,
              onReceiveProgress: (res, total) {});

          await FlutterShare.shareFile(title: name, filePath: file.path);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
