# 南京大学数电实验（Verilator 版） NJU Verilated Digital Lab

## 说明

本项目还未开发完成。

## 简介

当前，南京大学的数电实验是在 Vivado 上，使用 #TODO 开发板进行的。然而，Vivado 软件磁盘占用较大，不利于学生在自己的电脑上进行实验~~（不少同学忍痛删除了许多游戏）~~。

[NJU-ProjectN](https://github.com/NJU-ProjectN) 项目的子项目 [nvboard](https://github.com/NJU-ProjectN/nvboard) 提供了一个虚拟的 FPGA。

[Verilator](https://github.com/verilator/verilator) 是一个

本项目旨在提供一个能够同时支持 Vivado 及相关开发板和 verilator + nvboard 实验环境的开箱即用的目录结构，使得学生可以在两套环境中**无缝切换**。

这里，无缝是指：一条命令配置好 verilator + nvboard。使用 Vivado 在本目录中建立项目，然后手动修改少量配置（Vivado 项目名称等），即可使用 verilator + nvboard 自动仿真 / 启动开发板进行上板验证。可以使用 VSCode 等编辑器在本地进行编辑。

## 使用

#TODO

## 致谢

本项目组合使用了 [nvboard](https://github.com/NJU-ProjectN/nvboard) 和 [Verilator](https://github.com/verilator/verilator) 
