#!/bin/sh

test -x $(which duplicity) || exit 0
. /root/.passphrase

export PASSPHRASE
echo $PASSPHRASE
unset PASSPHRASE