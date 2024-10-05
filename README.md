# Sandbox RootFS

这是 **NextOJ** 使用的沙箱 RootFS。它基于 **Ubuntu 20.04.1**，尽可能还原 NOI Linux 的环境。

每个编译器都可以通过 `$PATH` 直接访问。你可以从 [release](https://github.com/oimoj/sandbox-rootfs/releases) 下载，也可以自行引导构建。

# 自行引导构建

你将需要以下条件：

* 一个具有 root 权限的 Linux 环境
* `arch-chroot`（通常在 `arch-install-scripts` 包中）
* `debootstrap`（确保使用与 Ubuntu 20.04.1 兼容的版本）

首先，克隆此仓库：

```bash
git clone https://github.com/oimoj/sandbox-rootfs
cd sandbox-rootfs
```

设置 RootFS 的引导路径。如果路径中已有内容，将被 `rm -rf` 清空；如果路径不存在，则会被 `mkdir -p` 创建。

```bash
export ROOTFS_PATH=/rootfs
```

如果你是 root 用户，只需运行 `bootstrap.sh` 脚本：

```bash
./bootstrap.sh
```

如果你使用 `sudo`，请确保使用 `-E` 选项保留 `ROOTFS_PATH` 环境变量：

```bash
sudo -E ./bootstrap.sh
```
