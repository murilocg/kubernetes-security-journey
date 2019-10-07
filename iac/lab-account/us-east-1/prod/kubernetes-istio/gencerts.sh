#!/bin/bash

mkdir -p ./.secret
echo -e "$1" | tee "./.secret/$2"
