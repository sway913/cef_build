# docker下进行编译

## 系统环境设置

1、Windows平台
在管理员权限的PowerShell下执行下面的命令安装好windows的Containers功能
```bash
Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V", "Containers") -All

### 安装docker

1、Windows平台
(官网)(https://github.com/sway913/cef_build/tree/main/docker)安装好docker

参考：
[windows下docker容器配置](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/manage-docker/configure-docker-daemon)

[容器中的持久性存储](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/manage-containers/persistent-storage)

[开发环境](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/samples?tabs=Application-frameworks)

修改windows容器保存位置:
修改"C:\ProgramData\Docker\config\daemon.json"文件:
增加"data-root": "F:\\docker",(注意:目录必须不存在，得由docker来创建)
或者在设置界面修改docker镜像保存位置(推荐)(C盘足够大的可以忽略)

### 安装编译环境的容器

#### windows

若使用tap虚拟网卡的vpn网络需要单独设置NAT网络配置(建议直连使用自由的网络环境)

执行下面的命令安装好容器和配置开发环境
```bash
build_win.bat
```

启动现有容器(容器已启动)
```shell
# 使用id
docker exec -it b82ceb44fe3b cmd.exe
# 使用容器名称
docker exec -it win_dev cmd.exe
```

```
若你上次使用了linux容器，这次需要windows容器需要执行，反之亦然。
```bash
"C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchWindowsEngine
```

或者

```bash
"C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon
```


[docker数据保存的方式](https://blog.csdn.net/qq_58804301/article/details/129843130)
### 编译cef

把当前仓库clone到docker可以访问的位置，执行脚本里面的bat进行下载和编译几口

