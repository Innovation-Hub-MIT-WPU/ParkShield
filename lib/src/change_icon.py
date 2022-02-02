import cv2
import os

FILE_NAME = "ic_launcher.png"
CURRENT_DIRECTORY = os.getcwd().replace('\\','/')

icon = cv2.imread("main_icon.png",  cv2.IMREAD_UNCHANGED)

icons =  {
            48 : {'img':cv2.resize(icon, (48,48)),'foldername':'mipmap-mdpi'},
            72 : {'img':cv2.resize(icon, (72,72)),'foldername':'mipmap-hdpi'},
            96 : {'img':cv2.resize(icon, (96,96)),'foldername':'mipmap-xhdpi'},
            144 : {'img':cv2.resize(icon, (144,144)),'foldername':'mipmap-xxhdpi'},
            192 : {'img':cv2.resize(icon, (192,192)),'foldername':'mipmap-xxxhdpi'}
        }

for size,icon in icons.items():
    os.chdir(f"{CURRENT_DIRECTORY}/android/app/src/main/res/{icon['foldername']}")
    cv2.imwrite(FILE_NAME,icon['img'])