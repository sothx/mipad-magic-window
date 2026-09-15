#!/bin/bash
CACHE=$(find /data/user_de -name *shaders_cache* -type f | grep code_cache)
for i in $CACHE; do
  rm -rf $i
done

for i in "$(find /data -type f -name '*shader*')"; do
  rm -f $i
done
