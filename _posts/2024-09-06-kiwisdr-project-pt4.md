---
title: "KiwiSDR Project Part 4"
date: 2024-09-06
categories: [radio]
tags: [radio]
---
Ok! So I've powered up the noisy as heck wifi bridge but also plugged in the USB wifi adapter with a 8dB antenna attached. I'm going to try to get the adapter working from the comfort of inside the house then go power down everything attached to the ethernet, especially the bridge because it is VERY noisy in the environment even when it's not plugged into anything but power.

So first things first, let's see what's on the USB bus:

```shell-session
debian@kiwisdr:~$ lsusb
-bash: lsusb: command not found
```

Well that's no good, but expected. Let's install USB utils so we can take a look

```shell-session
debian@kiwisdr:~$ sudo apt install usbutils
```
After installing usbutils, we'll see what's on the USB bus and install the appropriate firmware.

```shell-session
debian@kiwisdr:~$ lsusb
Bus 001 Device 002: ID 0cf3:9271 Qualcomm Atheros Communications AR9271 802.11n
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

debian@kiwisdr:~$ apt search atheros
Sorting... Done
Full Text Search... Done
firmware-atheros/unknown 20170823-1rcnee1~jessie+20180328 all
  Binary firmware for Atheros wireless cards

debian@kiwisdr:~$ sudo apt install firmware-atheros
```

Ok, so let's install some tools for wireless networking.

```shell-session
debian@kiwisdr:~$ sudo apt install iw wireless-tools wpasupplicant wavemon
```

Now at this point I could go outside and unplug and re-plug the USB adapter, but it's hot and gross so I'll reboot and log back in. After that:

```shell-session
debian@kiwisdr:~$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether e4:15:f6:f7:4d:a8 brd ff:ff:ff:ff:ff:ff
3: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e8:de:27:09:0a:55 brd ff:ff:ff:ff:ff:ff
4: usb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
    link/ether e4:15:f6:f7:4d:a0 brd ff:ff:ff:ff:ff:ff
```

Sweet! `wlan0` is alive, but down! Let's bring it up so we can look at the spectrum / networks:

```shell-session
debian@kiwisdr:~$ sudo ip link set wlan0 up
```

Now we should be able to use `wavemon` to scan for networks. `wavemon` is an ncurses based way to more conveniently browse wireless networks. We'll run `sudo wavemon` and check things out.

<img src="/assets/images/kiwisdr/Pasted image 20240906100506.png" alt="Wavemon on KiwiSDR" >

Ok, so nothing yet, we'll have to hit `F3` and initiate a scan:

<img src="/assets/images/kiwisdr/Pasted image 20240906100608.png" alt="Wavemon Scan on KiwiSDR" >

So this is where it's wild. Let's explore with a not-to-scale KD8ORQ home diagram:

<img src="/assets/images/kiwisdr/Untitled-2024-09-06-1017.png" alt="KD8ORQ Home Diagram">

The `dankostan_EXT` extender was installed because the extender in the garage didn't get enough signal to connect to the modem in the front of the house. According to `wavemon`, the USB stick+antenna averages a 10dB better signal than the intermediary extender (dankostan_EXT) I was intending to use. So we'll setup the KiwiSDR to use the original AP in the front of the house and once the Wifi is working on the KiwiSDR, all the extenders can be removed[^1]!

I was about to edit `/etc/network/interfaces` to bring up the wireless interface, but according to a comment in it, I should be using `connman` to manage the network connection. So...

```shell-session
debian@kiwisdr:/etc/network$ sudo apt install connman
```

And the network drops. The device is no longer ping-able, etc. The screen stopped updating when connman was 80% of the way through being installed. So let's go power cycle the thing after a good wait to ensure the apt operation completed. I thought something might happen with both interfaces being live on the same network, but we haven't even set the thing up yet.

Everything was fine after the power cycle and connman was installed. Let's make sure it runs at startup:

```shell-session
debian@kiwisdr:~$ sudo systemctl enable connman
debian@kiwisdr:~$ sudo systemctl start connman
```

Let's run it:

```shell-session
debian@kiwisdr:~$ sudo connmanctl
```

We'll get a new prompt and run three commands:

```shell-session
connmanctl> enable wifi
connmanctl> scan wifi
connmanctl> services
```

To connect to our network, we'll use the results from the second column of the output of `services`:

```shell-session
connmanctl> connect wifi_e8de27090a55_64616e6b6f7374616e_managed_psk
```

I got an error:

```shell-session
connmanctl> connect wifi_e8de27090a55_64616e6b6f7374616e_managed_psk
Error /net/connman/service/wifi_e8de27090a55_64616e6b6f7374616e_managed_psk: Not registered
```

Turns out the link wasn't up after the reboot, let's try again:

```shell-session
debian@kiwisdr:~$ sudo ip link set wlan0 up
```

Still broken. Googling says the agent wasn't running, so

```shell-session
debian@kiwisdr:~$ sudo connmanctl
connmanctl> agent on
connmanctl> connect wifi_e8de27090a55_64616e6b6f7374616e_managed_psk
```

Boom! Asked for a passphrase and it worked:

```shell-session
debian@kiwisdr:~$ ip addr show wlan0
3: wlan0: <BROADCAST,MULTICAST,DYNAMIC,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether e8:de:27:09:0a:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.170/24 brd 192.168.12.255 scope global wlan0
       valid_lft forever preferred_lft forever
    inet6 fd8b:cfb9:3269:6cc7:eade:27ff:fe09:a55/64 scope global mngtmpaddr dynamic
       valid_lft 1698sec preferred_lft 1698sec
    inet6 fd24:8142:392f:0:eade:27ff:fe09:a55/64 scope global mngtmpaddr dynamic
       valid_lft forever preferred_lft forever
    inet6 2607:fb91:16ad:4968:eade:27ff:fe09:a55/64 scope global mngtmpaddr dynamic
       valid_lft forever preferred_lft forever
    inet6 fe80::eade:27ff:fe09:a55/64 scope link
       valid_lft forever preferred_lft forever
```

So let's go detach the ethernet, reboot and try this (not in that order, but yes):

<img src="/assets/images/kiwisdr/Pasted image 20240906111045.png" alt="Waterfall on KiwiSDR" >

AWWWW YEAH! I zoomed in and the carrier noise from before is gone. The part that is wild is that the noise floor is 1-2 dB off from where the KiwiSDR would be with no antenna attached!

After a little bit of browsing around the bands, this is a night and day change -- I am now successfully picking up signals I could not have imagined picking up before since I'm in the low noise garage. I love this!

Someday soon I'll have to consolidate all these notes so they make more sense to future readers, but I am finally happy with my KiwiSDR setup.
