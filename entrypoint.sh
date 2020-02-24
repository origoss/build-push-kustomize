#!/bin/sh -l

echo "----- env ------"
printenv
echo "decrypting client.ovpn"
gpg --quiet --batch --yes --decrypt --passphrase="$INPUT_GPGPASSPHRASE" \
    --output $HOME/secrets/client.ovpn $INPUT_OVPNPATH
cat $HOME/secrets/client.ovpn
