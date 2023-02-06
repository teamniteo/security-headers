#!/bin/bash

if [ $# == 0 ]; then
    echo "Usage: url [grade] [followRedirects]"
    echo "* url: URL to analyse."
    echo "* grade: The desired security grade of your HTTP response headers. Possible grades: A+, A, B, C, D, E, F. Defaults to B."
    exit 1
fi

GRADE=${2:-'B'}
supportedTLS=""

declare -A grades=(
	['A+']=7
	['A']=6
	['B']=5
	['C']=4
	['D']=3
	['E']=2
	['F']=1
	['R']=0
)

function scan() {
    curl -slvo /dev/null --show-error --fail "$1" --tlsv$2 --tls-max $2
    retval=$?
    if [ $retval -eq 0 ]; then
        supportedTLS=$(echo "$supportedTLS tls$2" | xargs)
    fi
}

RATING=$(curl -s -L "https://securityheaders.com/?hide=on&followRedirects=on&q=https%3A%2F%2F$1" -I | sed -En 's/x-grade: (.*)/\1/p' | tr -d '\r')
scan "$1" "1.0"
scan "$1" "1.1"
scan "$1" "1.2"
scan "$1" "1.3"

if [ "$supportedTLS" != "tls1.2 tls1.3" ]; then
	RATING="F"
fi

echo "::set-output name=supportedTLS::$supportedTLS"
echo "::set-output name=rating::$RATING"

if [ ${grades[$RATING]} -ge ${grades[$GRADE]} ]; then
	exit 0
else
	exit 1
fi
