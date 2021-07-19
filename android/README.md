## Android scripts

This directory contains example workflows I have used for configuring an Android for pentesting.

Device details:

- Hardware: [OnePlus One](https://en.wikipedia.org/wiki/OnePlus_One) (codename Bacon)
- Operating System: [LineageOS](https://lineageos.org/) 18 (Android 11) flashed with [Kali Nethunter](https://www.kali.org/get-kali/#kali-mobile)
- Rooted using [Magisk](https://magisk.me/)

I won't cover how to flash a custom operating system to your device or how to root it as there are many guides but I will detail how I set my device up post-install.

Also, you don't _have to have_ Kali Nethunter for this all to work, but it makes all of these tools much easier to use.

## Dependencies for computer:

I'll outline what I've installed on my machine to interface with the phone more smoothly. These are mostly things I use on my computer to use the scripts contained in this repository. These are tools available for Unix/Unix-like operating systems, so Windows users should just use WSL2 if you want the same type of setup. Most of these applications are available in the repositories for most Linux distributions, FreeBSD or MacOS' Homebrew.

- BASH
- Coreutils
- `adb`
- `fzf`
- `ffmpeg` 


## App stores:

- [F-Droid](https://f-droid.org/): Open source app store for open source apps. Available for any Android.
- [Kali Nethunter App Store](https://store.nethunter.com/): Fork of F-Droid with repositories containing Android security applications available for use with Nethunter. You do not need to flash Kali Nethunter on the device to use the app store.


## Notable apps for this setup:

- [Hacker's Keyboard](https://f-droid.org/en/packages/org.pocketworkstation.pckeyboard/)
- [Wireguard](https://f-droid.org/en/packages/com.wireguard.android/)
- [Termux](https://f-droid.org/en/packages/com.termux/)
- [Termux:Boot](https://f-droid.org/en/packages/com.termux.boot/)
- [Termux:API](https://f-droid.org/en/packages/com.termux.api/)
- [Nethunter](https://store.nethunter.com/en/packages/com.offsec.nethunter/)
- [cSploit](https://store.nethunter.com/en/packages/org.csploit.android/)
- [Rucky](https://store.nethunter.com/en/packages/com.mayank.rucky/)
- [DriveDroid](https://store.nethunter.com/en/packages/com.softwarebakery.drivedroid/)


## Make the Android remotely accessible:

### OpenSSH:
I use OpenSSH in Termux as outlined here:

[Termux Wiki: OpenSSH](https://wiki.termux.com/wiki/Remote_Access#OpenSSH)

After opening Termux and the Termux:Boot apps you can run the following commands in Termux to make sure that the `sshd` process starts on boot:

```bash
pkg install -y openssh

mkdir -p ~/.termux/boot

printf '#!/data/data/com.termux/files/usr/bin/sh\ntermux-wake-lock\nsshd' >> ~/.termux/boot/sshd

chmod +x ~/.termux/boot/sshd
```

This is what my SSH config looks like in Termux (it is located at `$PREFIX/etc/ssh/sshd_config`):

```bash
PrintMotd yes
PasswordAuthentication no
Subsystem sftp /data/data/com.termux/files/usr/libexec/sftp-server
Port 1024
```

You'll want to take note of what your username is in Termux, available with the `whoami` command. Also, notice the port in my config is port 1024, and that I'm not using password authentication which will require that you setup an SSH key for your user in Termux. 

So if you use my config and your user was named `u0_a111` you would use the following command on your computer to connect to the Android device:

```bash
ssh -p1024 u0_a111@ip-address
```

For even more reliable SSH connectivity you can also install `mosh` in Termux:

```bash
pkg install -y mosh
```


### Wireguard:

I prefer Wireguard for VPN stuff. I won't get into how to setup Wireguard but I use Wireguard to make my Android device available to other remote devices. My Android and other devices connect to a VPS running Wireguard and are able to connect to each other using the tunnel network provided by Wireguard.

Rather than routing my entire Android's traffic through Wireguard, I split tunnel and make sure the only traffic going through Wireguard is the private network Wireguard serves. For example, my Wireguard network uses 10.51.51.0/24 for the IP addresses it assigns to remote devices so in my Android Wireguard app I setup `10.51.51.0/24` in the AllowedIPs. This will allow my Android device to see anything in `10.51.51.0/24` after connecting to my Wireguard instance but will not route any other traffic through Wireguard.

I setup Always On VPN on the Android by going to Settings > Network & Internet > Advanced > VPN > the gear icon next to the Wireguard tunnel > Always-on VPN and toggling that to on. This will ensure that whenever my device has network connectivity it will always connect to the VPN. 

### Remote ADB:

I use the SSH server in Termux to SSH into the phone and forward the port for `adbd` over SSH.

I outlined that process here:

[Remotely connecting to Rooted Android via ADB](https://the-empire.systems/rooted-android-remote-adb)

To sum up, I put the following in Termux in `~/.termux/boot/adb`:

```bash
#!/data/data/com.termux/files/usr/bin/env bash

INTERFACE='tun0'

su -c "setprop service.adb.tcp.port 5555 && iptables -A INPUT -i ${INTERFACE} -p tcp --d
port 5555 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT && stop adbd && start adbd"
```

Make it executable:

```bash
chmod +x ~/.termux/boot/adb
```

This will run adb on port 5555 and `iptables` will only allow incoming traffic on port 5555 from the interface `tun0` -- which is the default VPN interface on Android. Meaning that remote ADB will only be accessible to my devices in the same Wireguard instance.

To make the remote ADB instance available to my laptop, I use SSH:

```bash
ssh -L 5555:127.0.0.1:5555 -qCN kali-phone

```

Then connect with `adb` to the local port:

```
adb connect localhost:5555
```

You will probably need to open your phone and approve the connection request.

Once connected, you can use `adb` as though it were locally connected through a USB cable. You can even do screen capture using this remote ADB session, although it's very slow. 
