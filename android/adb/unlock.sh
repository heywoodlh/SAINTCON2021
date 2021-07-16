#!/usr/bin/env bash

android_pin=$(pass kali-oneplusone/pin)

## If screen is turned off
if adb shell dumpsys power | grep -q "mHoldingDisplaySuspendBlocker=false"
then
	## Press power button
	adb shell input keyevent 26
fi


## If locked
if adb shell dumpsys power | grep -q "mUserActivityTimeoutOverrideFromWindowManager=10000"
then
	## Open unlock dialog screen with the menu button:
	adb shell input keyevent 82
	## Send PIN and hit OK
	adb shell input text ${android_pin} && adb shell input keyevent 66
fi
