#!/bin/bash

INSTALL_BIN=/usr/local/bin

while read line
do
  rm -fr $INSTALL_BIN/$line
done <command_list.txt






