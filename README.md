[Chromium Embedded Framework Home Page](https://bitbucket.org/chromiumembedded/cef/wiki/Home)
====

# cef在各平台的编译

##推荐环境

推荐使用docker进行编译

### 系统环境设置
1、安装好python3.9并且设置到系统path环境

2、把系统语言设置为英文

![qysz](https://github.com/sway913/cef_build/assets/9814915/1735e05f-469d-4e29-a831-95144cf555ef)


在英文环境下编译才不会报错

3、代码内文件路径不能太长，建议在磁盘根目录创建1个文件夹，推荐如下目录

D:\\code\\scripts\\*.bat

4、PC硬件资源

至少220 GB空闲磁盘空间，8 GB RAM内存


### 一、源码下载
执行01.win.prepare_env.bat下载好相关工具，然后执行02.win.download_source.bat下载源码(大概要下载50GB的数据)
若下载源码过程出现任何问题，不用怀疑，就是你的网络问题，请更换好点的网络环境。

在这里下载cef的5414版本，使用vs2019进行编译。

vs2019安装需要勾选atl组件或者在vs安装程序传入以下参数进行安装
```bash
VisualStudioSetup.exe --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended
```
环境配置文档：https://bitbucket.org/chromiumembedded/cef/wiki/AutomatedBuildSetup.md#markdown-header-platform-build-configurations

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
执行03.win.build_cef.bat进行编译(若同时编译debug和release总共需要11个小时)，可以修改里面相关参数匹配好你实际安装好的环境(可以修改为vs2022的安装目录，实测可以用vs2022编译)。

### 三、验收成果
在chromium\src\out目录下，打开 cefclient.exe 文件，访问http://html5test.com 可简单查看功能编译情况。访问[HTML5 audio/video tester](https://tools.woolyss.com/html5-audio-video-tester) 来判断各种视频格式的支持情况

在G:\cef_build\chromium_git\chromium\src\cef\binary_distrib目录是发布包，里面有发布二进制文件和相关pdb符号文件。

### 四、源码修改

可以修改源码进行自定义功能开发

1、调试环境
编译debug版本后把"G:\cef_build\chromium_git\chromium\src\cef\binary_distrib\cef_binary_109.1.18+gf1c41e4+chromium-109.0.5414.120_windows64_debug_symbols\libcef.dll.pdb" 文件放到你G:\cef_build\chromium_git\chromium\src\cef\binary_distrib\cef_binary_109.1.18+gf1c41e4+chromium-109.0.5414.120_windows64的CMake工程下的pdb加载目录，VS2022安装好[多进程调试工具](https://marketplace.visualstudio.com/items?itemName=vsdbgplat.MicrosoftChildProcessDebuggingPowerTool2022)  (为了懒得去判断该附加哪个进程)后把cef的源码拖进vs编辑器打上断点就行

2、修改源码后增量编译

执行命令进行单独的增量编译(10分钟)
```bash
cd G:\cef_build\chromium_git\chromium\src

"G:\cef_build\chromium_git\chromium\src\third_party\ninja\ninja.exe" -v -C out\Debug_GN_x64 cefclient
```
或者修改03.win.build_cef.bat的编译参数，改成仅编译debug并且不打包,走完整的增量编译流程(20分钟)。
编译后的文件在G:\cef_build\chromium_git\chromium\src\out\Debug_GN_x64目录，把libcef.dll和libcef.dll.pdb它们拷贝到你tests工程相关的引用目录去(G:\cef_build\chromium_git\chromium\src\cef\binary_distrib\cef_binary_109.1.18+gf1c41e4+chromium-109.0.5414.120_windows64\build\tests\cefclient\Debug)。

### 五、遇到的问题
1、RuntimeError: requested profile "D:\code\chromium_git\chromium\src\chrome\build\pgo_profiles\chrome-win64-5414-1673458358-5348276ff887eb95bb837c1dd06e9efed673b8e4.profdata" doesn't exist, please make sure "checkout_pgo_profiles" is set to True in the "custom_vars" section of your .gclient file, e.g

出现这个报错需要设置chrome_pgo_phase=0

参考:[PGO profiles needed for is_official_build = true (google.com)](https://groups.google.com/a/chromium.org/g/chromium-dev/c/-0t4s0RlmOI)

2、UnicodeDecodeError: 'utf-8' codec can't decode byte 0xd2 in position 738: invalid continuation byte

需要把文件从UTF-8转为UTF-8-BOM编码，推荐用英文版系统编译，中文版要改的代码太多。

3、网络问题
RPC failed; curl 56 Recv failure: Connection was reset

early EOF
这些都是网络问题，建议使用稳定点的科学上网工具并且使用网线接入网络。



