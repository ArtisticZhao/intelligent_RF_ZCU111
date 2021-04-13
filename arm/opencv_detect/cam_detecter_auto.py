# coding: utf-8
import cv2
import numpy as np


def detect(img, hsv, i):
    '''
    @ 卫星模型的颜色有三种: 绿 蓝 白, 分别检测三种颜色 之后合成mask
    '''
    blue_h_high = 125
    blue_h_low = 100
    green_h_high = 93
    green_h_low = 48
    white_h_high = 57
    white_h_low = 11

    lower_blue = np.array([blue_h_low, 130, 0])
    upper_blue = np.array([blue_h_high, 255, 255])

    lower_green = np.array([green_h_low, 0, 0])
    upper_green = np.array([green_h_high, 255, 255])

    lower_white = np.array([white_h_low, 10, 148])
    upper_white = np.array([white_h_high, 80, 255])

    blue_mask = cv2.inRange(hsv, lower_blue, upper_blue)
    green_mask = cv2.inRange(hsv, lower_green, upper_green)
    white_mask = cv2.inRange(hsv, lower_white, upper_white)
    res_green = cv2.bitwise_and(img, img, mask=green_mask)
    res_white = cv2.bitwise_and(img, img, mask=white_mask)
    res_blue = cv2.bitwise_and(img, img, mask=blue_mask)
    res = cv2.bitwise_or(res_green, res_white)
    res = cv2.bitwise_or(res, res_blue)

    # 通过形态学腐蚀 去掉亮点
    kernel = np.ones((5, 5), np.uint8)
    closing = cv2.morphologyEx(res, cv2.MORPH_CLOSE, kernel)
    # opening = cv2.morphologyEx(res, cv2.MORPH_OPEN, kernel)
    # cv2.imshow('image', closing)
    gray = cv2.cvtColor(closing, cv2.COLOR_BGR2GRAY)
    ret, binary = cv2.threshold(gray, 10, 255, cv2.THRESH_BINARY)
    # 轮廓检测
    _, contours, hierarchy = cv2.findContours(binary, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
    mx = 0
    my = 0
    mh = 0
    mw = 0
    for each in contours:
        x, y, h, w = cv2.boundingRect(each)
        if(h+w > mh+mw):
            mx = x
            my = y
            mh = h
            mw = w
    cv2.rectangle(img, (mx, my), (mx + mw, my + mh), (0, 255, 0), 2)
    cv2.putText(img, "satellite", (mx, my), cv2.FONT_HERSHEY_PLAIN, 1.2, (0, 255, 0), 1)
    cv2.imwrite("ov_out" + str(i) + ".bmp",img)
    print("save file to ov_out" + str(i) + ".bmp")
    # cv2.imshow("image", img)


if __name__ == "__main__":
    index = 0
    # cv2.namedWindow('image')
    cap = cv2.VideoCapture(0)

    key = 0
    # while key != ord('q'):
    #     if key == ord("c"):
    for i in range(5):
        start = time.time()
        print("capture from /dev/video0")
        _, img = cap.read()
        sleep(5)
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        detect(img, hsv, i)
        end = time.time()
        print(1, " ", end-start, "sec")
        
        print("Please change pic")
        sleep(5)
    #     key = cv2.waitKey(0)
    cap.release()
    # cv2.destroyAllWindows()
