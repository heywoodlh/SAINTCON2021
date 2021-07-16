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

