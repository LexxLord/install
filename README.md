## Preparing for installation

**Erase the entire disk and install a GPT partition table**

```shell
wipefs --all /dev/sda
```

or

```shell
echo -e "g\nw\n" | fdisk /dev/sda
```

**Partition the disk**

- /dev/sda1 - EFI System - 512M
- /dev/sda2 - Without changes - All the remaining space

```shell
cfdisk
```

## install

**Install git**

```shell
pacman -Sy git glibc
```

**Clone repository**

```shell
git clone https://github.com/LexxLord/install.git
```

**Go to install**

```shell
cd install
```

**Start installation**

```shell
sh install-1
```

**Continue installation**

```shell
cd /install
```

**Start configure**

```shell
sh install-2
```

**Setting Up Boot and Login (Autologin)**

```shell
sh install-3
```

**Set up a repository**

```shell
sh install-4
```

**Additional settings**

```shell
sh install-5
```
