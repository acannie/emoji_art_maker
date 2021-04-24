import 'package:flutter/material.dart';

import 'upload_image.dart';
import 'create_emoji_art.dart';
import 'pick_image.dart';

// ページ全体のレイアウトを生成
class EmojiArtMaker extends StatelessWidget {
  Widget appBarMain() {
    return AppBar(
      leading: Icon(Icons.menu),
      // title: const Text('Emoji Art Maker'),
      backgroundColor: Colors.orange,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.face,
            color: Colors.white,
          ),
          onPressed: () => {
            print("debug"),
          },
        ),
        IconButton(
          icon: Icon(
            Icons.email,
            color: Colors.white,
          ),
          onPressed: () => {
            print("debug"),
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          onPressed: () => {
            print("debug"),
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
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
                              PickedImageWidget(),
                              ImageUploadButtonWidget(),
                              Wrap(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: EmojiArt(),
                                  ),
                                ],
                              ),
                            ]))))));
  }
}
