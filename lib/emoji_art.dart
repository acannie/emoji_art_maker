import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as imageUtil;
import 'package:flutter/services.dart';
import 'package:image_size_getter/image_size_getter.dart';

import 'utils.dart';
import 'pick_image.dart';

// 絵文字アートのプレビューを生成
class EmojiArtPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PickedImageController pickedController =
        Provider.of<PickedImageController>(context);

    return FutureBuilder<MemoryImage>(
      future: pickedController.imageFuture,
      builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          MemoryImage image = snapshot.data!;

          // 縦横のマス数を決定
          final Size memoryImageSize =
              ImageSizeGetter.getSize(MemoryInput(image.bytes));
          final int maxSize = 30; // TODO 入力できるようにする
          final int imageWidth = memoryImageSize.width;
          final int imageHeight = memoryImageSize.height;

          final int emojiArtWidth =
              (imageWidth / max(imageWidth, imageHeight) * maxSize).round();
          final int emojiArtHeight =
              (imageHeight / max(imageWidth, imageHeight) * maxSize).round();

          imageUtil.Image shrinkedImage = imageUtil.copyResize(
            imageUtil.decodeImage(image.bytes)!,
            width: emojiArtWidth,
            height: emojiArtHeight,
          );

          String emojiArt = "";

          for (int i = 0; i < emojiArtHeight; i++) {
            for (int j = 0; j < emojiArtWidth; j++) {
              int abgr = shrinkedImage.getPixel(j, i); // #AABBGGRR
              int argb = Utils().abgrToArgb(abgr); // #AARRGGBB
              Color color = Color(argb);
              String emoji = Utils().similarEmoji(color);
              emojiArt += emoji;
            }
            emojiArt += "\n";
          }
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('mark_arrow_down.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Text("クリックしてクリップボードにコピー"),
                ],
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: emojiArt));
                },
                child: Text(emojiArt),
              ),
            ],
          );
        } else if (null != snapshot.error) {
          return Container(
            child: Text(
              'No Image Selected',
              textAlign: TextAlign.center,
            ),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
