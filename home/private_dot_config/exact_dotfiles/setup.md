# Configure Linux

## System Configuration

## Device specific configurations

### Lenovo T14 - kernel parameter "backlight"
> vim /etc/default/grub
	@"acpi_backlight=native" 
	>>"GRUB_CMDLINE_LINUX_DEFAULT"

### Lenovo T14 - brightness on reboot [BUG in amdgpu]
There is a bug in the amdgpu package in the way the brightness level is read and written. This causes the brightness to reset to maximum when booting. This fix ensures that the brightness level is the same as pre-shutdown.
More information: https://bugzilla.kernel.org/show_bug.cgi?id=203905

> systemctl enable --now fix-brightness.service

## Services


~/.config/systemd
    - spotifyd.service
    ENABLE SERVICES

# Unprocessed

## Base16 Universal Manager
Needs to be manually installed unfortunately
mkdir -p "$(go env GOPATH)/src"
go install github.com/pinpox/base16-universal-manager

## random stuff i did...

### ...to get wireless xbox working
echo 1 > /sys/module/bluetooth/parameters/disable_ertm

