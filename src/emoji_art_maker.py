from PIL import Image
import numpy as np
import sys


class EmojiArtMaker:
    # 定数
    R = 0
    G = 1
    B = 2

    # 出力フォーマット
    ART_WH = 100
    EMOJIS = {"red": {"rgb": [255, 0, 0], "emoji": "🟥"}, "orange": {"rgb": [255, 165, 0], "emoji": "🟧"}, "yellow": {"rgb": [255, 255, 0], "emoji": "🟨"},
              "green": {"rgb": [0, 255, 0], "emoji": "🟩"}, "blue": {"rgb": [0, 0, 255], "emoji": "🟦"}, "purple": {"rgb": [128, 0, 128], "emoji": "🟪"},
              "brown": {"rgb": [128, 0, 0], "emoji": "🟫"}, "black": {"rgb": [0, 0, 0], "emoji": "⬛️"}, "white": {"rgb": [255, 255, 255], "emoji": "⬜️"}}

    # 画像を正方形にトリミング

    def image_preparation(im):
        cv_im = im
        pil_im = EmojiArtMaker.cv_to_pil(im)
        pil_im = EmojiArtMaker.crop_max_square(pil_im)
        pil_im = pil_im.resize((EmojiArtMaker.ART_WH, EmojiArtMaker.ART_WH))
        cv_im = EmojiArtMaker.pil_to_cv(pil_im)
        return cv_im

    def cv_to_pil(image):
        new_image = image.copy()
        if new_image.ndim == 2:  # モノクロ
            pass
        elif new_image.shape[2] == 3:  # カラー
            new_image = new_image[:, :, ::-1]
        elif new_image.shape[2] == 4:  # 透過
            new_image = new_image[:, :, [2, 1, 0, 3]]
        new_image = Image.fromarray(new_image)
        return new_image

    def crop_max_square(pil_img):
        img_width, img_height = pil_img.size
        crop_width = min(pil_img.size)
        crop_height = min(pil_img.size)

        return pil_img.crop(((img_width - crop_width) // 2,
                             (img_height - crop_height) // 2,
                             (img_width + crop_width) // 2,
                             (img_height + crop_height) // 2))

    def pil_to_cv(image):
        new_image = np.array(image, dtype=np.uint8)
        if new_image.ndim == 2:  # モノクロ
            pass
        elif new_image.shape[2] == 3:  # カラー
            new_image = new_image[:, :, ::-1]
        elif new_image.shape[2] == 4:  # 透過
            new_image = new_image[:, :, [2, 1, 0, 3]]
        return new_image

    def __init__(self, im, ART_PANEL_NUMBER_WIDTH=1, ART_PANEL_NUMBER_HEIGHT=1):
        self.ART_PANEL_NUMBER_WIDTH = ART_PANEL_NUMBER_WIDTH
        self.ART_PANEL_NUMBER_HEIGHT = ART_PANEL_NUMBER_HEIGHT

        self.im = EmojiArtMaker.image_preparation(im)

    # メイン処理
    def design(self):

        # 画像のサイズを取得 (縦横比1:1)
        IMG_HEIGHT = self.im.shape[0]
        IMG_WIDTH = self.im.shape[1]
        COLOR_VARIETY = self.im.shape[2]

        for r in range(EmojiArtMaker.ART_WH):
            for c in range(EmojiArtMaker.ART_WH):
                _rgb = [self.im[r][c][0], self.im[r][c][1], self.im[r][c][2]]
                similar_emoji_name = self.__similar_emoji(_rgb)
                print(
                    EmojiArtMaker.EMOJIS[similar_emoji_name]["emoji"], end="")
            print()

    def __similar_emoji(self, rgb):
        rgb = np.array(rgb)
        smallest_distance = 255**2 * 3
        target_color = str()
        for emoji_name, emoji_item in EmojiArtMaker.EMOJIS.items():
            emoji_rgb = np.array(emoji_item["rgb"])
            u = emoji_rgb - rgb
            distance = np.linalg.norm(u)
            if distance < smallest_distance:
                smallest_distance = distance
                target_color = emoji_name
        return target_color


def main():
    args = sys.argv
    if len(args) != 2:
        print("Please specify the input file.")
        sys.exit()
    input_file = args[1]
    content = Image.open(input_file)
    content = np.array(content)
    emoji_art_maker = EmojiArtMaker(content, 1, 1)
    emoji_art_maker.design()


if __name__ == "__main__":
    main()
