#!/usr/bin/env bash

package=$(adb shell pm list packages | grep 'package:' | cut -d':' -f2 | fzf)

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

if [ -n ${package} ]
then
	adb shell monkey -p ${package} 1
fi
