#!/bin/bash

if [ $# == 0 ]; then
    echo "Usage: url [grade] [followRedirects]"
    echo "* url: URL to analyse."
    echo "* grade: The desired security grade of your HTTP response headers. Possible grades: A+, A, B, C, D, E, F. Defaults to B."
    echo "* followRedirects: Follow redirects. Defaults to false, set to true to enable."
    exit 1
fi

GRADE=${2:-'B'}
FOLLOW_REDIRECTS=${3:-''}

declare -A grades=(
	['A+']=7
	['A']=6
	['B']=5
	['C']=4
	['D']=3
	['E']=2
	['F']=1
)

if [ "$2" = 'true' ]; then
    FOLLOW_REDIRECTS='on'
fi

GRADE=$3

RATING=$(curl -s -L "https://securityheaders.com/?hide=on&followRedirects=$FOLLOW_REDIRECTS&q=$1" -I | sed -En 's/x-grade: (.*)/\1/p' | tr -d '\r')

echo "::set-output name=rating::$RATING"

if [ ${grades[$RATING]} -ge ${grades[$GRADE]} ]; then
	exit 0
else
	exit 1
fi