#!/bin/sh -l

echo "----- env ------"
printenv
echo "decrypting client.ovpn"
gpg --quiet --batch --yes --decrypt --passphrase="$INPUT_GPGPASSPHRASE" \
    --output $HOME/client.ovpn $INPUT_OVPNPATH
cat $HOME/client.ovpn
echo $INPUT_OVPNUSERNAME > $HOME/pass.txt
echo $INPUT_OVPNPASSWORD >> $HOME/pass.txt
cat $HOME/pass.txt
