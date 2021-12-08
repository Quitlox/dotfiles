# Configure Linux

## User Configurations

### Window Manager Manual Configuration



### Post Software Installation Configurations

*Wireshark*
sudo usermod -a -G wireshark quitlox

*Vim*
To complete the setup for the YouCompleteMe (autocomplete) plugin for vim, 
run the following commands:
* cd /home/quitlox/.local/share/vim/bundle/repos/github.com/ycm-core/youcompleteme
* python3 install.py --all
* vim: call dein#recache_runtimepath()

*Docker*
sudo usermod -a -G docker quitlox
sudo systemctl enable --now docker

## System Configuration


### Enable touch scrolling in firefox
More information: https://superuser.com/questions/1151161/enable-touch-scrolling-in-firefox

> vim /etc/security/pam_env.conf
	> MOZ_USE_XINPUT2 DEFAULT=1
	- /src/patch/etc_security_pam_env.patch

### PulseAudio: Auto-connect bluetooth headset
To make your headset auto connect you need to enable PulseAudio's switch-on-connect-module.
More information: https://wiki.archlinux.org/index.php/Bluetooth_headset#Setting_up_auto_connection 

> vim /etc/pulse/default.pa
	> load-module module-switch-on-connect
	- /src/patch/etc_pulse_default.patch

### PulseAudio: Switch automatically between HSP and A2DP
The A2DP protocol is the standard protocol for bluetooth audio, and delivers
good audio quality. Unfortunately, this protocol does not support 
bidirectional audio in linux. Therefore, in order to use bluetooth headsets
with voice, the protocol should switch to HSP, which does support voice.
Archwiki: https://wiki.archlinux.org/title/Bluetooth_headset#Switch_between_HSP/HFP_and_A2DP_setting

> vim /etc/pulse/default.pa
	> "load-module module-blueooth-policy" ++ " auto_switch=2"

### PulseAudio: HFP not working with PulseAudio
Archwiki: https://wiki.archlinux.org/title/Bluetooth_headset#HFP_not_working_with_PulseAudio

## Distro-specific Configurations

### Manjaro

#### LightDM Boot Sequence
LightDM fails to start because it boots too fast.
More information: https://wiki.archlinux.org/index.php/LightDM#LightDM_does_not_appear_or_monitor_only_displays_TTY_output

> vim /etc/lightdm/ligthdm.conf
	> [LightDM]
	> logind-check-graphical=true

#### PulseAudio
> install_pulse
	- Automatich Post-Install Script provided by Manjaro i3

## Device specific configurations

### Lenovo T14 - kernel parameter "backlight"
> vim /etc/default/grub
	@"acpi_backlight=native" 
	>>"GRUB_CMDLINE_LINUX_DEFAULT"

### Lenovo T14 - brightness on reboot [BUG in amdgpu]
There is a bug in the amdgpu package in the way the brightness level is read and written. This causes the brightness to reset to maximum when booting. This fix ensures that the brightness level is the same as pre-shutdown.
More information: https://bugzilla.kernel.org/show_bug.cgi?id=203905

> systemctl enable --now fix-brightness.service

## Patches

~/.config/src/patch
		- etc_pulse_default.patch
		- etc_security_pam_env.patch
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

# TODO

## Larger tasks

* Find tool for easily managing unknown new external monitor
* Swap out antigen for antibody (antigen is deprecated)
* configure fzf in zsh and vim
* Overengeneering the Desktop Environment:
    ** Implement Notification Center	
    ** Network manager + Wrapper around linux-hotspot?
* How to deal with node (system + nvm)?
* Fix zinit first load
* Fix zinit history

## Smaller Fixes

* Configure PS4 Controller (doesn't work with Stardew?). Installed [this](https://github.com/chrippa/ds4drv)
* Add multiple keyboard layouts using ibus
* Fix backlight issue at startup
* Fix brightness being managed by two programs?
* Add bell on low power
* Replace manual i3lock script with AUR package


## YADM Compatibility fixes

* Add profiles for terminals, and conditionally source vim files
* Add profiles for git keys, and conditionally set identifity
* bug: .local/share/vim folder not created
* Ask for change shell to zsh
* Add reminder TODO list
    ** set monitor configuration 'autorandr --save'
    ** yadm config local.class home
    ** yadm alt
    ** yadm decrypt
    ** yadm bootstrap
* base16 manager
* set wallpaper
* create /workspace directory structure (and print 'tree', fancy :O)
* delete standard files:
    ** ~/.gtkrc-2.0 (moved to .config/)
    ** ~/.bash
    ** ~/.i3 (moved to .config/i3)
    ** ~/.gimp-2.8 (moved to .config/GIMP/xx)

## Contributing

* AUR Packaging:
    ** Processing xD
    ** base16-universal-manager
* base16-universal-manager
    ** Add support for custom colorschemes
    ** Add support for custom templates
* picom
    ** Add animation to the focussed border (resize and move the focussed border from the old focussed window to the new focussed window)
* polybar
    ** ibus module?
* New: We need some uniform way of changing config files for different themes. Maybe using symlinks?
* XDG Everything!:
    ** MitmProxy: https://github.com/mitmproxy/mitmproxy/issues/3863

