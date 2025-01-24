import requests, os, ipaddress, json, subprocess

ece = "128.173.88.1/22"
addrs = ipaddress.IPv4Network(ece, False)

good = []

for i in addrs:
	print(i, end="")
	ret = os.system("ping -c 1 -W .5 "+str(i)+" 1> /dev/null")
	if ret == 0:
		print(" BAD PING")
		continue
	rdns = subprocess.run(["dig", "+short", "-x", str(i)], capture_output=True, text=True, check=True).stdout.strip()
	if rdns:
		print(" BAD RDNS "+rdns)
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
