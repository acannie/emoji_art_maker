import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// テキストフィールドの値の変更を通知
class PickMaxSizeController with ChangeNotifier {
  int _maxSize = 30;
  int get maxSize => _maxSize;

  String _artSize = "<100";
  String get artSize => _artSize;

  Future<int> pickMaxSize(String? n) async {
    if (n == null || n == "0") {
      n = "1";
    }

    _maxSize = int.parse(n);
    _artSize = n;
    return _maxSize;
  }

  void reloader() async {
    notifyListeners();
  }
}

// 絵文字アート長辺の絵文字数を指定
class PickedMaxSizeWidget extends StatelessWidget {
  final PickMaxSizeController controller = PickMaxSizeController();

  @override
  Widget build(BuildContext context) {
    final PickMaxSizeController controller =
        Provider.of<PickMaxSizeController>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("長辺の絵文字数"),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          alignment: Alignment.center,
          width: 100,
          child: TextFormField(
            textAlign: TextAlign.center,
            enabled: true,
            maxLength: 2,
            keyboardType: TextInputType.number,
            maxLines: 1,
            onChanged: controller.pickMaxSize,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            enableSuggestions: true,
            decoration: InputDecoration.collapsed(hintText: ''),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
          ),
        ),
      ],
    );
  }
}
