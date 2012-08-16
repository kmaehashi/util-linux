#!/bin/sh

mount -t cifs -o ro,user=guest,guest,iocharset="sjis" //192.168.1.2/shared public_html/share

