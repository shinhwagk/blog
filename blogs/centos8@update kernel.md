1
```sh
rpm -qlp | grep kernel
kernel-core
kernel-modules
kernel-modules-extra
```

# 2
```sh
yum update kernel # or yum update kernel-{version}
```

# 3 kelnel modules
> /lib/modules/<KERNEL_VERSION>/modules.dep
```sh
# Listing currently loaded kernel modules
lsmod # need kmod package
```

# 4
- To list the boot entries of the kernel
```sh
 grubby --info=ALL | grep title
```
- set a kernel as default kernel
```sh
grubby --info ALL | grep id
grubby --set-default /boot/vmlinuz-<version>.<architecture>
```
