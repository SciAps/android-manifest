#!/bin/sh

echo "Installing ducati-m3-core0.xem3"
cp ducati-m3-core0.xem3 /system/vendor/firmware/

echo "Installing bootanimation"
cp bootanimation /system/bin/bootanimation

echo "Installing framework-res.apk"
cp framework-res.apk /system/framework/

sync

echo "Done."
reboot
