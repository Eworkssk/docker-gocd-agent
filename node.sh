#!/usr/bin/env bash

source /home/go/.profile

nvm install $1
nvm use $1
shift 

bash -c "$@"
