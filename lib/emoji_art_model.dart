import 'dart:convert';

// サーバから受け取る JSON のモデル
class EmojiArtData {
  final String? emojiArt;

  EmojiArtData({
    this.emojiArt,
  });

  factory EmojiArtData.fromJson(Map<String, dynamic> json) => EmojiArtData(
        emojiArt: json["emoji_art"],
      );

  Map<String, dynamic> toJson() => {
        "emoji_art": emojiArt,
      };

  static String serialize(EmojiArtData mat) {
    return jsonEncode(mat);
  }

  static EmojiArtData deserialize(String jsonString) {
    Map<String, String> jsonStr = jsonDecode(jsonString);
    EmojiArtData result = EmojiArtData.fromJson(jsonStr);
    return result;
  }
}
