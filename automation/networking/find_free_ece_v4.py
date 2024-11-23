import requests, os, ipaddress, json

ece = "128.173.88.1/22"
addrs = ipaddress.IPv4Network(ece, False)

good = []

for i in addrs:
	ret = os.system("ping -c 1 -W .5 "+str(i))
	if ret == 0: continue
	r = requests.get("https://ipinfo.io/"+str(i)+"/json").json()
	if r.get("hostname") is not None: continue
	r = requests.get("https://orca-public.caas.nis.vt.edu/ipr/v1/public/ip/"+str(i)+"/contacts").content.decode("ascii")
	if not "ECE" in r: continue
	good.append(str(i))
	print(good)

print(good)
