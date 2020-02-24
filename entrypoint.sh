#!/bin/sh -l

echo "----- env ------"
printenv
echo "decrypting client.ovpn"
gpg --quiet --batch --yes --decrypt --passphrase="$INPUT_GPGPASSPHRASE" \
    --output $HOME/client.ovpn $INPUT_OVPNPATH
cat $HOME/client.ovpn
echo $INPUT_OVPNUSERNAME > $HOME/$INPUT_OVPNPASSFILENAME
echo $INPUT_OVPNPASSWORD >> $HOME/$INPUT_OVPNPASSFILENAME
cat $HOME/$INPUT_OVPNPASSFILENAME
