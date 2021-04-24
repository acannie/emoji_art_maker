import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view/emoji_art_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

import 'emoji_art_model.dart';
import 'pick_image.dart';

// 画像ファイルを POST request でサーバに送信
class ImageUploadController with ChangeNotifier {
  Future<EmojiArtData>? _emojiArtDataFuture;

  Future<EmojiArtData>? get emojiArtDataFuture => _emojiArtDataFuture;

  static final String uploadEndPoint =
      // 'https://pup9ceo6uc.execute-api.ap-northeast-1.amazonaws.com/Prod/ac_mydesign';
      'http://localhost:5000/';

  Future<EmojiArtData> upload(MemoryImage image) async {
    var url = Uri.parse(uploadEndPoint);
    var request = new http.MultipartRequest("POST", url);
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      image.bytes,
      contentType: new MediaType('application', 'octet-stream'),
      filename: "file_up.jpg",
    ));

    // notify before
    _emojiArtDataFuture = request.send().then((response) => response.stream
        .bytesToString()
        .then((body) => EmojiArtData.fromJson(json.decode(body))));
    notifyListeners();
    return _emojiArtDataFuture!;
  }
}

// 画像ファイルをアップロード
class ImageUploadButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PickedImageController imageController =
        Provider.of<PickedImageController>(context);

    final ImageUploadController uploadController =
        Provider.of<ImageUploadController>(context);

    return FutureBuilder<MemoryImage>(
        future: imageController.imageFuture,
        builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            final MemoryImage image = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  uploadController.upload(image);
                },
                child: Text('Upload Image'),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
