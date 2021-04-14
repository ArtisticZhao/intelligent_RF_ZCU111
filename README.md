# intelligent_RF_ZCU111

本科毕设: 智能射频模块, 数据处理与SDR融合项目

## 任务目标

- 从图像传感器中获取一幅较大分辨率的图片
- 目标检测程序，识别图像中的目标区域，并标记
- 对标记后的图像，通过射频通道，使用BPSK调制发送
- 接收机接收，并显示图像

## 效果演示

结题验收时，制作了一个[演示小视频](https://www.bilibili.com/video/BV1nK4y1K7CV/)。

## 硬件平台

- [ZCU111](https://www.xilinx.com/products/boards-and-kits/zcu111.html)
- USB图像传感器（Linux下免驱）

## 实现方案

### 目标识别方案

基于OpenCV的目标检测。

### SDR实现方案

详情参看[毕业设计文档第5章](./doc/BPSK调制的实现与验证.pdf)

## 代码说明

### fpga

该文件夹下保存了fpga设计的相关源码

#### 文件树

- **ip_repo** 这里保存这用户自定义的ip核文件
- **user_code** 这里保存用户的文件，如约束文件、Verilog源文件、仿真文件等
- **xxx.tcl** 这是创建工程用的tcl脚本
- **system.tcl** 这是创建block design的tcl脚本
- **verilog_4_bpsk_mod** 这个文件夹保存了自定义ip核中所有的verilog源码（与fpga工程无关）

#### 创建Vivado工程

tcl脚本采用Vivado 2019.1 创建

```shell
vivado -source axi_bpsk.tcl
```

Vivado 会根据tcl脚本自动在当前目录下创建`axi_bpsk`工程

### arm

该文件夹下保存了linux系统下运行需要的文件

在本项目中，采用了Pynq系统进行操作。

#### 文件树

- **data_sender** 是C语言编写的将二进制文件通过PS-PL间AXI4总线发送到PL端的BPSK发射机的发射缓存中
- **opencv_detect** 是python语言编写的基于OpenCV的目标检测程序，该程序可以自动从USB图像传感器中读取图像并识别

**注：**C语言程序既可以用xsdk的`linux os`模式编译并上传，也可以直接在pynq系统中直接`gcc`编译

#### FPGA镜像的加载

Pynq系统中，将FPGA镜像与Linux系统镜像分离，通过overlay的方式动态加载，因此使用上述程序之前，需要加载fpga镜像，才能拥有正确的功能。
假定fpga镜像保存在pynq的home目录下，文件名为`system.bit`，执行如下python指令即可加载fpga镜像。

```Python
from pynq import Overlay
overlay = Overlay('/home/xilinx/system.bit')
```

### host

这里保存了上位机的全部程序。

上位机需要解决两个问题，一是bpsk的接收与解调，二是基带数据的解码。

#### BPSK接收与解码

通过GNU Radio使用USRP B210软件无线电收发信机来实现接收与解码，GNU Radio程序在grc文件中。

#### 基带数据的解码

为了解决GNU Radio的粘包问题，采用了[KISS编码](https://en.wikipedia.org/wiki/KISS_(TNC))。解码方法在`kiss.py`中。
