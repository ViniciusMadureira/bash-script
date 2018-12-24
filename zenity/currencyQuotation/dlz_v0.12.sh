#!/bin/bash
# Author: Vinícius Madureira <contato@viniciusmadureira.com>
# Version: 0.12
# Date: December 24, 2018
# Script: Bash BRL Quatation (BraQua)
# Dependencies: GNU bash 4.3.42(1); zenity 3.18.1.1-1; curl 7.43.0; GNU grep 2.22; GNU sed 4.2.2; GNU Awk 4.1.3; GNU coreutils 8.24 (head)
: '

 ███▄ ▄███▓ ▄▄▄      ▓█████▄ ▓█████     ▄▄▄▄ ▓██   ██▓    █     █░███▄    █  ███▄ ▄███▓
▓██▒▀█▀ ██▒▒████▄    ▒██▀ ██▌▓█   ▀    ▓█████▄▒██  ██▒   ▓█░ █ ░█░██ ▀█   █ ▓██▒▀█▀ ██▒
▓██    ▓██░▒██  ▀█▄  ░██   █▌▒███      ▒██▒ ▄██▒██ ██░   ▒█░ █ ░█▓██  ▀█ ██▒▓██    ▓██░
▒██    ▒██ ░██▄▄▄▄██ ░▓█▄   ▌▒▓█  ▄    ▒██░█▀  ░ ▐██▓░   ░█░ █ ░█▓██▒  ▐▌██▒▒██    ▒██ 
▒██▒   ░██▒ ▓█   ▓██▒░▒████▓ ░▒████▒   ░▓█  ▀█▓░ ██▒▓░   ░░██▒██▓▒██░   ▓██░▒██▒   ░██▒
░ ▒░   ░  ░ ▒▒   ▓▒█░ ▒▒▓  ▒ ░░ ▒░ ░   ░▒▓███▀▒ ██▒▒▒    ░ ▓░▒ ▒ ░ ▒░   ▒ ▒ ░ ▒░   ░  ░
░  ░      ░  ▒   ▒▒ ░ ░ ▒  ▒  ░ ░  ░   ▒░▒   ░▓██ ░▒░      ▒ ░ ░ ░ ░░   ░ ▒░░  ░      ░
░      ░     ░   ▒    ░ ░  ░    ░       ░    ░▒ ▒ ░░       ░   ░    ░   ░ ░ ░      ░   
       ░         ░  ░   ░       ░  ░    ░     ░ ░            ░            ░        ░   
                      ░                      ░░ ░                                      

'
url='https://api.cotacoes.uol.com/mixed/summary?&currencies=1,11,5&itens=1,1943&fields=name,openbidvalue,askvalue,variationpercentbid,price,exchangeasset,open,pctChange,date,abbreviation&jsonp=jsonp'
content=$(curl -s $url)
quotations=$(echo "$content" | grep --perl-regexp --only-matching --regexp='"askvalue":\d+\.\d+' | sed 's/.*://g')
indexQuotations=$(echo "$content" | grep --perl-regexp --only-matching --regexp='"variationpercentbid":\d+\.\d+' | sed 's/.*://g')
date=$(echo "$content" | grep --perl-regexp --only-matching --regexp='\d{14}' | head -n 1 | date "+%d/%m/%Y")
read -ra QUOTATIONS <<< $quotations
read -ra INDEX_QUOTATIONS <<< $indexQuotations
CURRENCIES=("Dólar (USD)" "Peso  (ARS)" "Euro  (EUR)")
for index in ${!QUOTATIONS[@]}; do
    QUOTATIONS[$index]="${CURRENCIES[$index]} # ${QUOTATIONS[$index]} # ${INDEX_QUOTATIONS[$index]}"
done
IFS="#"
zenity --list \
    --timeout=600 \
    --width=320 --height=220 \
    --title="Real (BRL)" \
    --text="Data: <b>$date</b>" \
    --column="Moeda" \
    --column="Cotação (R$)" \
    --column="Variação" \
    ${QUOTATIONS[@]}
exit 0
