[1mdiff --git a/router/proxy/fix_luug2.sh b/router/proxy/fix_luug2.sh[m
[1mold mode 100644[m
[1mnew mode 100755[m
[1mindex bd8d566..c4cbc20[m
[1m--- a/router/proxy/fix_luug2.sh[m
[1m+++ b/router/proxy/fix_luug2.sh[m
[36m@@ -1,5 +1,7 @@[m
 #!/bin/sh[m
 [m
[32m+[m[32m# This scripts prevents other hosts from using luug2.ece.vt.edu[m
[32m+[m
 while true; do[m
 	echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind[m
 	arping -q -I eth0 -U -c 2 -s 128.173.89.246 128.173.91.254[m
[1mdiff --git a/router/proxy/fix_luug3.sh b/router/proxy/fix_luug3.sh[m
[1mold mode 100644[m
[1mnew mode 100755[m
[1mindex e480f10..d890f78[m
[1m--- a/router/proxy/fix_luug3.sh[m
[1m+++ b/router/proxy/fix_luug3.sh[m
[36m@@ -1,5 +1,7 @@[m
 #!/bin/sh[m
 [m
[32m+[m[32m# This scripts prevents other hosts from using luug3.ece.vt.edu[m
[32m+[m
 while true; do[m
 	echo 1 > /proc/sys/net/ipv4/ip_nonlocal_bind[m
 	arping -q -I eth0 -U -c 2 -s 128.173.89.247 128.173.91.254[m
