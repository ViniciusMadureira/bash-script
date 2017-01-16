#!/bin/bash
# Author: Vinícius Madureira <contato@viniciusmadureira.com>
# Version: 0.1
# Date: January 16, 2017
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
url='http://economia.uol.com.br/cotacoes/cambio/dolar-comercial-estados-unidos/'
content=$(curl -s $url)
quotations=$(echo "$content" | grep -Po "<p class=\"cotacao\">.*<\/span> R\\$ [0-9]+,[0-9]+ </p>" | grep -Po "R\\$ [0-9]+,[0-9]+" | sed -e 's/\s\|R\$//g')
indexQuotations=$(echo "$content" | grep -Po "(?U)ic-cotacao.*<\/span>" | sed -e 's/<.*//g' -e 's/.*>//g' -e '1d')
date=$(echo $content | grep -Po "[0-9]{2}/[0-9]{2}/[0-9]{4} [0-9]{2}h[0-9]{2}" | head -n 1 | awk '{print $1}')
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
