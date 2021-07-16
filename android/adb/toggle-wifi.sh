#!/usr/bin/env bash

if adb shell dumpsys wifi | grep "Wi-Fi is enabled"
then
	echo 'Disabling wifi'
	adb shell svc wifi disable
else
	echo 'Enabling wifi'
	adb shell svc wifi enable
fi
