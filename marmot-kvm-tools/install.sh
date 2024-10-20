#!/bin/bash

INSTALL_BIN=/usr/local/bin

while read CMD
do
    install -v -m 0755 -o root -g root $CMD $INSTALL_BIN/$CMD
done <command_list.txt

install -v -m 0755 -o root -g root -d libruby  $INSTALL_BIN/libruby
install -v -m 0755 -o root -g root libruby/*   $INSTALL_BIN/libruby/

REMOTE_COMMAND=/usr/local/bin/vm-create-remote.rb
rm -f $REMOTE_COMMAND
ln -s /usr/local/bin/vm-create-remote $REMOTE_COMMAND


