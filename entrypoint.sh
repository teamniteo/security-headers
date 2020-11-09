#!/bin/bash

declare -A grades=(
   ['A+']=7
   ['A']=6
   ['B']=5
	 ['C']=4
	 ['D']=5
	 ['E']=6
	 ['F']=7
)

GRADE=$2

RATING=`curl -s --location --request GET "https://securityheaders.io/?hide=on&q=$1" -I | sed -En 's/x-grade: (.*)/\1/p' | tr -d '\r'`

echo "::set-output name=rating::$RATING"

if [ ${grades[$RATING]} -ge ${grades[$GRADE]} ]; then
	exit 0
else
	exit 1
fi