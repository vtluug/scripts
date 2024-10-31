import requests, os, ipaddress

ece = "128.173.88.1/22"
addrs = ipaddress.IPv4Network(ece, False)

good = []

for i in addrs:
	ret = os.system("ping -c 1 -W .5 "+str(i))
	if ret == 0: continue
	r = requests.get("https://ipinfo.io/"+str(i)+"/json").json()
	if r.get("hostname") is not None: continue
	good.append(str(i))
	print(good)

print(good)
