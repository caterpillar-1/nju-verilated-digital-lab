# 南京大学数电实验（Verilator 版） NJU Verilated Digital Lab

## 说明

本项目还未开发完成。

## 演示

<iframe src="//player.bilibili.com/player.html?bvid=BV1Lk4y1c7j4&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

## 背景

当前，南京大学的数电实验是在 Vivado 上，使用 nexysa7 开发板进行的。然而，Vivado 软件磁盘占用较大，不利于学生在自己的电脑上进行实验~~（不少同学忍痛删除了许多游戏）~~。

[NJU-ProjectN](https://github.com/NJU-ProjectN) 项目的子项目 [nvboard](https://github.com/NJU-ProjectN/nvboard) 提供了一个虚拟的开发板。

[Verilator](https://github.com/verilator/verilator) 是一个快速的（lab01 10 秒从源码到开发板写入完成、启动，Vivado 需要至少 1 分钟），广泛使用的，社区驱动的，开放授权的 Verilog/SystemVerilog 仿真器（编译器），通过将 Verilog 代码描述的行为编译成二进制文件，然后执行二进制文件进行仿真。

[GTKwave](https://gtkwave.sourceforge.net/) 是一个波形查看器。详见项目主页。

组合以上工具，可得一个轻量级、快速的 Verilog 开发、验证平台。

## 简介 / 目标

本项目旨在提供一个能够同时支持 Vivado 及相关开发板和 verilator + nvboard 实验环境的开箱即用的脚本和目录结构，支持自动配置 verilator, nvboard, gtkwave，使得学生可以在两套环境中**无缝切换**。

这里，无缝是指：一条命令配置好 verilator + nvboard。使用 Vivado 在本目录中建立项目，然后手动修改少量配置（Vivado 项目名称等），即可使用 verilator + nvboard 自动仿真 / 启动开发板进行上板验证。可以使用 VSCode 等编辑器在本地进行编辑。

## 特性 / 路线

1. [x] 支持用 verilator 编译 Vivado 创建的项目；
2. [x] 支持用 nvboard 验证设计；
3. [ ] 支持自动追踪，使 verilator 编译的二进制文件自动输出波形；
4. [ ] 支持自动打开 gtkwave 查看波形；
5. [ ] 支持自动安装配置 verilator / nvboard / gtkwave (on GNU/Linux)；
6. [ ] 自动安装的跨平台支持；

## 使用

#TODO

## 致谢

本项目组合使用了 [nvboard](https://github.com/NJU-ProjectN/nvboard) 和 [Verilator](https://github.com/verilator/verilator) 
