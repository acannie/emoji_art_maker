import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as imageUtil;

// FEに画像がアップロードされたことを通知
class PickedImageController with ChangeNotifier {
  Future<MemoryImage>? _imageFuture;
  Future<MemoryImage>? get imageFuture => _imageFuture;

  Future<MemoryImage> pickImage() async {
    _imageFuture = ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((file) => file!.readAsBytes())
        .then((bytes) => new MemoryImage(bytes));

    // For other components
    notifyListeners();
    return _imageFuture!;
  }
}

// 画像を FE にアップロード
class PickedImageWidget extends StatelessWidget {
  final PickedImageController controller = PickedImageController();

  Future<MemoryImage>? _future;

  @override
  Widget build(BuildContext context) {
    final PickedImageController controller =
        Provider.of<PickedImageController>(context);

    // https://qiita.com/beeeyan/items/8f39120501b6334350ed
    return Padding(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<MemoryImage>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return CircularProgressIndicator();
            if (snapshot.connectionState == ConnectionState.done &&
                null != snapshot.data) {
              MemoryImage? image = snapshot.data;

              if (image != null) {
                return Column(children: <Widget>[
                  InkWell(
                    onTap: () {
                      _future = controller.pickImage();
                    },
                    child: Container(
                      width: 400,
                      height: 300,
                      child: Flexible(
                        child: Image.memory(image.bytes),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('mark_arrow_up.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text("クリックして画像選択"),
                      ],
                    ),
                  ),
                ]);
              }
            } else if (null != snapshot.error) {
              return CircularProgressIndicator();
            }
            return Column(
              children: <Widget>[
                InkWell(
                  child: Container(
                    child: Text(
                      '画像を選択してね',
                      textAlign: TextAlign.center,
                    ),
                    height: 300,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    _future = controller.pickImage();
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('mark_arrow_down.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
