import 'package:flutter/material.dart';

import 'emoji_art.dart';
import 'pick_image.dart';
import 'pick_max_size.dart';

// ページ全体のレイアウトを生成
class MyDesigner extends StatelessWidget {
  Widget appBarMain() {
    return AppBar(
      leading: Icon(Icons.menu),
      title: const Text('Emoji Art Maker'),
      backgroundColor: Colors.orange,
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    String greeting =
        "絵文字アートメーカーにようこそ！\n選択した画像を9つの絵文字\n🟥🟧🟨🟩🟦🟪🟫⬛️⬜️\nで再現するツールです。";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: appBarMain(),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Text(greeting),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  PickedImageWidget(),
                  PickedMaxSizeWidget(),
                  Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: EmojiArtPreviewWidget(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
