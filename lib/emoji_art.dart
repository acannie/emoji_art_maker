import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as im;

import 'pick_image.dart';

// マイデザインのプレビューを生成
class EmojiArtPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PickedImageController upload_controller =
        Provider.of<PickedImageController>(context);

    return FutureBuilder<MemoryImage>(
      future: upload_controller.imageFuture,
      builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          MemoryImage image = snapshot.data!;
          // return Image.memory(image.bytes, fit: BoxFit.fill);
          var aaa =
              Image(image: ResizeImage(image, width: 100000, height: 100000));
          return Text(im.Image.rgb());
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
