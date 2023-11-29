[Chromium Embedded Framework Home Page](https://bitbucket.org/chromiumembedded/cef/wiki/Home)
====

# cef在各平台的编译

### 系统环境设置
1、安装好python3.9并且设置到系统path环境

2、把系统语言设置为英文

![qysz](https://github.com/sway913/cef_build/assets/9814915/1735e05f-469d-4e29-a831-95144cf555ef)


在英文环境下编译才不会报错

3、代码内文件路径不能太长，建议在根磁盘目录创建1个文件夹，推荐如下目录

D:\\code\\scripts\\*.bat

### 一、源码下载
执行01.win.prepare_env.bat下载好相关工具，然后执行02.win.download_source.bat下载源码(大概要下载50GB的内容)

在这里下载cef的5414版本，使用vs2019进行编译。

参考:https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding.md

vs2019安装需要勾选atl组件或者:
$ PATH_TO_INSTALLER.EXE ^
--add Microsoft.VisualStudio.Workload.NativeDesktop ^
--add Microsoft.VisualStudio.Component.VC.ATLMFC ^
--includeRecommended


参数说明：

download-dir: 代码下载目录

depot-tools-dir: 工具目录

branch: 要编译的分支，可以参考:[branches-supported](https://bitbucket.org/chromiumembedded/cef/wiki/BranchesAndBuilding.md#markdown-header-current-release-branches-supported)

–no-update：不更新Chromium或CEF

–no-depot-tools-update：不更新depot-tools

–no-distrib：不打包

–no-build：不编译

–force-clean：强制清理Chromium和CEF，这将触发一个新的更新、构建和发布

更多参数可以使用命令python automate-git.py --help查看


### 二、编译
执行03.win.build_cef.bat进行编译(若同时编译debug和release总共需要11个小时)，可以修改里面相关参数匹配好你的安装好的环境。

### 三、验收成果
在chromium\src\out目录下，打开 cefclient.exe 文件，访问http://html5test.com 可简单查看功能编译情况。访问[HTML5 audio/video tester](https://tools.woolyss.com/html5-audio-video-tester) 来判断各种视频格式的支持情况
在G:\cef_build\chromium_git\chromium\src\cef\binary_distrib目录是发布包，里面有发布二进制文件和相关pdb符号文件。

### 四、遇到的问题
1、RuntimeError: requested profile "D:\code\chromium_git\chromium\src\chrome\build\pgo_profiles\chrome-win64-5414-1673458358-5348276ff887eb95bb837c1dd06e9efed673b8e4.profdata" doesn't exist, please make sure "checkout_pgo_profiles" is set to True in the "custom_vars" section of your .gclient file, e.g

出现这个报错需要设置chrome_pgo_phase=0

参考:[PGO profiles needed for is_official_build = true (google.com)](https://groups.google.com/a/chromium.org/g/chromium-dev/c/-0t4s0RlmOI)

2、UnicodeDecodeError: 'utf-8' codec can't decode byte 0xd2 in position 738: invalid continuation byte

需要把文件从UTF-8转为UTF-8-BOM编码，推荐用英文版系统编译，中文版要改的代码太多。
