import requests, os, ipaddress, json

ece = "128.173.88.1/22"
addrs = ipaddress.IPv4Network(ece, False)

good = []

for i in addrs:
	print(i, end="")
	ret = os.system("ping -c 1 -W .5 "+str(i)+" 1> /dev/null")
	if ret == 0:
		print(" BAD PING")
		continue
	r = requests.get("https://ipinfo.io/"+str(i)+"/json").json()
	if r.get("hostname") is not None:
		print(" BAD RDNS "+r.get("hostname"))
		continue
	r = requests.get("https://orca-public.caas.nis.vt.edu/ipr/v1/public/ip/"+str(i)+"/contacts").content.decode("ascii")
	if not "adminGroup" in r:
		print(" BAD NIS RESPONSE")
		continue
	if not "ECE" in r:
		print(" NOT ECE "+json.loads(r)[0]["adminGroup"])
		continue
	good.append(str(i))
	print(" GOOD")

print(good)
