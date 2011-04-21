#!/usr/bin/env bash

source "$HOME/.rvm/scripts/rvm"

rvm use 1.9.2@translator

cd ~/workspace/translator
touch minzy.txt
ruby run.rb >> log.txt
