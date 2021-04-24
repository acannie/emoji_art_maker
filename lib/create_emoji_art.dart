import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

// import 'utils.dart';
import 'upload_image.dart';
import 'emoji_art_model.dart';

// マイデザインのパレットを生成
class EmojiArt extends StatelessWidget {
  final List<String> columnTitles = ["色番号", "色相", "彩度", "明度"];

  @override
  Widget build(BuildContext context) {
    final ImageUploadController upload_controller =
        Provider.of<ImageUploadController>(context);

    return FutureBuilder<EmojiArtData>(
      future: upload_controller.emojiArtDataFuture,
      builder: (BuildContext context, AsyncSnapshot<EmojiArtData> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          EmojiArtData emojiArtData = snapshot.data!;
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Container(
              child:
                  // for (var i = 0; i < emojiArtData.emojiArt!.length; i++)
                  Text(emojiArtData.emojiArt!),
            ),
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
