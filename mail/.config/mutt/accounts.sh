#!/usr/bin/env bash

maildir="$HOME/.mail"
configdir="${XDG_CONFIG_HOME:-$HOME/.config}/mutt"

i=0

for dir in $maildir/*/
do
	account=$(basename $dir)
	i=$((i + 1))

	echo "mailboxes \"=$account\""
	find $dir -maxdepth 1 -type d -name ".*" -printf "mailboxes \"=$account/%f\"\n" | sort -n

	configfile="$configdir/accounts.local/$account"

	if [ -f $configfile ]
	then
		echo "folder-hook =$account$ source $configdir/defaults.inbox.local"
		echo "folder-hook =$account source $configfile"
	fi

	echo "macro index \e$i '<sync-mailbox><change-folder>=$account<enter>' \"open $account folder\""
done
