import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageForm(),
    );
  }
}

class ImageForm extends StatefulWidget {
  static const String routePath = "/album";

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  String trangThai = "Thư viện";
  List<AssetEntity>? assets;
  List<AssetEntity>? asset_images;
  List<AssetEntity>? asset_videos;
  int? selected = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAssets();
    loadAssets_image();
    loadAssets_video();
  }

  void loadAssets_image() async {
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.image);
    List<AssetEntity> allAssets = await albums[0].getAssetListRange(
      start: 0,
      end: 10000,
    );
    setState(() {
      if (allAssets != null) asset_images = allAssets;
    });
  }

  void loadAssets_video() async {
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.video);
    List<AssetEntity> allAssets = await albums[0].getAssetListRange(
      start: 0,
      end: 10000,
    );
    setState(() {
      asset_videos = allAssets;
    });
  }

  void loadAssets() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    List<AssetEntity> allAssets =
        await albums[0].getAssetListRange(start: 0, end: 10000);
    setState(() {
      assets = allAssets;
    });
  }

  void navigateToAssetScreen(AssetEntity asset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageForm(),
      ),
    );
  }

  Widget buildAssetWidget(AssetEntity asset) {
    if (asset.type == AssetType.image) {
      return GestureDetector(
        onTap: () {
          navigateToAssetScreen(asset);
        },
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            } else {
              isLoading = false;
              return Container();
            }
          },
        ),
      );
    } else if (asset.type == AssetType.video) {
      return GestureDetector(
        onTap: () {
          navigateToAssetScreen(asset);
        },
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Icon(
                    Icons.play_circle_fill,
                    size: 40,
                    color: Color.fromARGB(255, 177, 177, 177),
                  ),
                ],
              );
            } else {
              return Center(child: Container());
            }
          },
        ),
      );
    } else {
      return Container();
      // CircularProgressIndicator();
    }
  }

  Widget video(AssetEntity asset) {
    if (asset.type == AssetType.video) {
      return GestureDetector(
        onTap: () {
          navigateToAssetScreen(asset);
        },
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Icon(
                    Icons.play_circle_fill,
                    size: 40,
                    color: Color.fromARGB(255, 177, 177, 177),
                  ),
                ],
              );
            } else {
              return Center(
                  child: Visibility(
                child: Container(),
                visible: true,
              ));
            }
          },
        ),
      );
    } else {
      return Text("aaa");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Align(
            child: Text(
              'Bài viết mới',
              style: TextStyle(color: Colors.blue[900]),
            ),
            alignment: Alignment.center,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.camera_alt, color: Colors.blue[900]),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text("Thư viện"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text("Ảnh"),
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text("Video"),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    setState(() {
                      if (value == 1) {
                        trangThai = "Thư viện";
                        selected = 1;
                        setState(() {});
                      } else if (value == 2) {
                        trangThai = "Ảnh";
                        selected = 2;
                      } else if (value == 3) {
                        trangThai = "Video";
                        selected = 3;
                      }
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 30,
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(5),
                    // ),
                    child: Row(
                      children: [
                        const Align(
                          alignment: Alignment.center,
                        ),
                        Padding(padding: EdgeInsets.only(left: 10, top: 8)),
                        Text(
                          trangThai,
                          style: TextStyle(fontSize: 18),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Icon(Icons.public),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                          onPressed: () => {}, child: Text("Chọn nhiều file"))
                    ],
                  ),
                ),
              ],
            ),
            if (assets == null)
              Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 215, 215, 215),
                highlightColor: Color.fromARGB(255, 225, 223, 223),
                child: GridView.count(
                  crossAxisCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(15, (index) {
                    return Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.all(8),
                      color: Colors.white,
                    );
                  }),
                ),
              )
            else
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 130,
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 2),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: assets!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (selected == 1) {
                      final asset = assets![index];
                      return buildAssetWidget(asset);
                    } else if (selected == 2) {
                      final asset = asset_images![index];
                      return buildAssetWidget(asset);
                    } else if (selected == 3) {
                      final asset = asset_videos![index];
                      return buildAssetWidget(asset);
                    }
                  },
                ),
              ),
          ],
        ));
  }
}
