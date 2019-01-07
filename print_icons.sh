#!/usr/bin/env bash

# fast_chr and unichr functions from Orwellophile on Stack Overflow (see https://stackoverflow.com/questions/602912/how-do-you-echo-a-4-digit-unicode-character-in-bash)
# These are a work-around for the lack of unicode output support in bash prior to version 4.2
fast_chr() {
    local __octal
    local __char
    printf -v __octal '%03o' $1
    printf -v __char \\$__octal
    REPLY=$__char
}

function unichr {
    local c=$1    # Ordinal of char
    local l=0    # Byte ctr
    local o=63    # Ceiling
    local p=128    # Accum. bits
    local s=''    # Output string

    (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

    while (( c > o )); do
        fast_chr $(( t = 0x80 | c & 0x3f ))
        s="$REPLY$s"
        (( c >>= 6, l++, p += o+1, o>>=1 ))
    done

    fast_chr $(( t = p | c ))
    REPLY="$REPLY$s"
}

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
filename="./build/mapping.txt"
count=0

while read -r line
do
    if [ "${line:0:1}" = "#" ]
    then
	name_num=(${line//:/ })
	echo -e "\n${YELLOW}${name_num[0]:1} (${name_num[1]} glyphs)${NC}:"
	count=$((count + name_num[1]))
    else
	str=""
	IFS=';' read -ra array_glyph <<< "$line"
	for glyph in "${array_glyph[@]}"; do
	    info=(${glyph//:/ })
            unichr "0x${info[1]}"
	    if [ $# -gt 0 ]; then
		str="$str${info[0]}: $REPLY\n"
	    else
		str="$str $REPLY"
	    fi
	done
	echo -e $str | sed 's/ /  /g'
    fi
done < "$filename"

echo -e "\n${GREEN}Total: $count glyphes${NC}"
