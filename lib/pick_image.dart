import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as imageUtil;
import 'dart:ui';

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
            if (snapshot.connectionState == ConnectionState.done &&
                null != snapshot.data) {
              MemoryImage? image = snapshot.data;

              if (image != null) {
                imageUtil.Image im = imageUtil.copyResize(
                    imageUtil.decodeImage(image.bytes)!,
                    width: 10,
                    height: 10);

                return InkWell(
                  onTap: () {
                    _future = controller.pickImage();
                  },
                  child: Image.memory(
                      Uint8List.fromList(imageUtil.encodeJpg(im)),
                      width: 256,
                      height: 256,
                      fit: BoxFit.fill),
                );
              }
            }
            return Padding(
              padding: EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  _future = controller.pickImage();
                },
                child: Text('Choose Image'),
              ),
            );
          }),
    );
  }
}
