# intelligent_RF_ZCU111

本科毕设: 智能射频模块, 数据处理与SDR融合项目

## 任务目标

- 从图像传感器中获取一幅较大分辨率的图片
- 目标检测程序，识别图像中的目标区域，并标记
- 对标记后的图像，通过射频通道，使用BPSK调制发送
- 接收机接收，并显示图像

## 硬件平台

- [ZCU111](https://www.xilinx.com/products/boards-and-kits/zcu111.html)
- USB图像传感器（Linux下免驱）

## 目标识别方案

基于OpenCV的目标检测

## SDR实现方案

