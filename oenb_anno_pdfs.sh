#!/bin/bash

# script for generating and downloading newspaper PDFs from anno.oenb.ac.at
# author: Wurzelmann
# date: 2019-10-09
#
# version 1.0 2019-10-14 code cleanup, fixed typos
# version 0.9 2019-10-12

echo ""
echo "Das Startdatum setzt sich zusammen aus einem Jahr, einem Monat und einem Tag. Ab diesem Startdatum wird die eingegebene Anzahl an Tagen abgearbeitet."
echo ""

echo -n "Jahr? (Format: YYYY) "
read year

echo -n "Monat? (Format: MM) "
read month

echo -n "Tag? (Format: DD) "
read day

echo -n "Anzahl der Tage ab Startdatum? "
read num_days

echo -n "Welche Zeitung? (Kürzel wie oez, nos, ovs, dkv,...)) "
read zeitung

read -e -p "Downloadpfad: " download_path

start_date=${year}${month}${day}

cd ${download_path}

# Ausnahme von Schleife fuer ersten Tag
date=`date +%Y%m%d -d "${start_date}"`
curl "http://anno.onb.ac.at/cgi-content/anno_pdf.pl?aid=${zeitung}&datum=${date}" -H 'Host: anno.onb.ac.at' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-GB,en-US;q=0.7,en;q=0.3' --compressed -H "Referer: http://anno.onb.ac.at/cgi-content/anno?aid=${zeitung}&datum=${date}" -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1'
    wget -nc --directory-prefix=${zeitung}/${year} "http://anno.onb.ac.at/pdfs/ONB_${zeitung}_${date}.pdf"

# main loop fuer das ganze Jahr ab dem ersten Tag
for i in `seq 1 $num_days`
do 
    date=`date +%Y%m%d -d "${start_date}+${i} days"`
curl "http://anno.onb.ac.at/cgi-content/anno_pdf.pl?aid=${zeitung}&datum=${date}" -H 'Host: anno.onb.ac.at' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-GB,en-US;q=0.7,en;q=0.3' --compressed -H "Referer: http://anno.onb.ac.at/cgi-content/anno?aid=${zeitung}&datum=${date}" -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1'
    wget -nc --directory-prefix=${zeitung}/${year} "http://anno.onb.ac.at/pdfs/ONB_${zeitung}_${date}.pdf"
    # random sleep um nicht geblockt zu werden
    sleep $(( $(head -1 /dev/urandom | cksum | awk '{print $2}') % 30 ))
done
