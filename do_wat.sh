#!/bin/bash

echo "Looking for things to do..."
find . | xargs grep TODO | grep -v xargs
echo "fin"
