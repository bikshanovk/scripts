#!/bin/bash

echo "Amount of arguments: $#"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $*"

echo "Random word: $(sed -n "${RANDOM:0:$(wc -w /usr/share/dict/words | awk '{print $1}')}p" /usr/share/dict/words)"

grep "\w\{$1,\}" /usr/share/dict/words

