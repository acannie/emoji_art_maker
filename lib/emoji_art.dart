import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as imageUtil;
import 'package:flutter/services.dart';

import 'utils.dart';
import 'pick_image.dart';

// 絵文字アートのプレビューを生成
class EmojiArtPreviewWidget extends StatelessWidget {
  int emojiArtWidth = 100;
  int emojiArtHeight = 100;

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
          imageUtil.Image shrinkedImage = imageUtil.copyResize(
              imageUtil.decodeImage(image.bytes)!,
              width: emojiArtWidth,
              height: emojiArtHeight);

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
              // Image.memory(
              //   Uint8List.fromList(imageUtil.encodeJpg(shrinkedImage)),
              // )
            ],
          );

          // return Image.memory(
          //   Uint8List.fromList(imageUtil.encodeJpg(shrinkedImage)),
          //   width: 256,
          //   height: 256,
          //   fit: BoxFit.fill,
          // );
          // return Image.memory(image.bytes);
          // return ConstrainedBox(
          //   constraints: BoxConstraints(maxWidth: 600),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.black),
          //     ),
          //     child: GridView.count(
          //       shrinkWrap: true,
          //       primary: false,
          //       crossAxisSpacing: 0,
          //       mainAxisSpacing: 0,
          //       crossAxisCount: 32,
          //       children: <Widget>[
          //         for (var i = 0;
          //             i < image.myDesignColorTable.length;
          //             i++)
          //           for (var j = 0;
          //               j < image.myDesignColorTable.length;
          //               j++)
          //             Container(
          //               decoration: BoxDecoration(
          //                 color: Color.fromRGBO(
          //                   image.palette[
          //                       image.myDesignColorTable[i][j]][0],
          //                   image.palette[
          //                       image.myDesignColorTable[i][j]][1],
          //                   image.palette[
          //                       image.myDesignColorTable[i][j]][2],
          //                   1,
          //                 ),
          //                 border: Utils().markLineBorder(
          //                     i, j, image.myDesignColorTable.length),
          //               ),
          //               child: Text(
          //                 "${image.myDesignColorTable[i][j] + 1}",
          //                 maxLines: 1,
          //                 style: TextStyle(
          //                     color: Utils().fontColor(
          //                   Color.fromRGBO(
          //                     image.palette[
          //                         image.myDesignColorTable[i][j]][0],
          //                     image.palette[
          //                         image.myDesignColorTable[i][j]][1],
          //                     image.palette[
          //                         image.myDesignColorTable[i][j]][2],
          //                     1,
          //                   ),
          //                 )),
          //                 textAlign: TextAlign.center,
          //               ),
          //             ),
          //       ],
          //     ),
          //   ),
          // );
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
