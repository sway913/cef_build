# docker下进行编译

## 系统环境设置

1、Windows平台
在管理员权限的PowerShell下执行下面的命令安装好windows的Containers功能
```bash
Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V", "Containers") -All
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

### 安装docker

1、Windows平台
官网安装好docker

参考[docker配置](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/manage-docker/configure-docker-daemon)

[容器中的持久性存储](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/manage-containers/persistent-storage)

### 安装编译环境的容器

#### windows

执行下面的命令安装好容器和配置开发环境
```bash
build_win.bat
```

