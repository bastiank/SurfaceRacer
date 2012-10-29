#!/bin/sh

APPDIR=$(dirname "$0")
java  -Djava.library.path="$APPDIR:$APPDIR/lib" -cp "/home/surface//opt/processing-2.0b5/lib/oscP5.jar:$APPDIR/lib/SurfaceRacer.jar:$APPDIR/lib/core.jar:$APPDIR/lib/jogl-all.jar:$APPDIR/lib/gluegen-rt.jar:$APPDIR/lib/jogl-all-natives-linux-i586.jar:$APPDIR/lib/gluegen-rt-natives-linux-i586.jar:$APPDIR/lib/pbox2d.jar:$APPDIR/lib/jbox2d_2.1.2_ds_v2.jar:$APPDIR/lib/slf4j-nop-1.6.4.jar:$APPDIR/lib/slf4j-api-1.6.4.jar:$APPDIR/lib/jl1.0.jar:$APPDIR/lib/minim.jar:$APPDIR/lib/tritonus_aos.jar:$APPDIR/lib/jsminim.jar:$APPDIR/lib/tritonus_share.jar:$APPDIR/lib/mp3spi1.9.4.jar" SurfaceRacer
