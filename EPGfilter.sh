#!/bin/bash

# Rev: 16-03-2021
url=("http://www.xmltvepg.nl/rytec.channels.xml.xz" "http://epgspot.com/rytec_epg/rytec.channels.xml.xz" "http://rytecepg.dyndns.tv/epg_data/rytec.channels.xml.xz" "http://epg.vuplus-community.net/rytec.channels.xml.xz")

J=1
	for i in "${url[@]}"
		do
            if [ $J -ne 0 ] ; then
                wget $i -O /tmp/rytec.channels.xml.xz        
                J=$?
                if [ $J -eq 0 ] ; then
                    xz -f -q -d /tmp/rytec.channels.xml.xz
                fi
            fi    
        done
/usr/bin/dos2unix /etc/epgimport/FILTERpattern.txt
grep -v -f "/etc/epgimport/FILTERpattern.txt" "/tmp/rytec.channels.xml" > "/etc/epgimport/filtered.channels.xml"
grep -f "/etc/epgimport/FILTERpattern.txt" "/tmp/rytec.channels.xml" > "/etc/epgimport/removed.channels.xml"

if [ -f "/etc/epgimport/rytec.sources.xml" ]; then
    cp -f "/etc/epgimport/rytec.sources.xml" "/etc/epgimport/rytec.sources.xml.org"
    mv -f /etc/epgimport/rytec.sources.xml /etc/epgimport/filtered.sources.xml
    sed -i -E 's/channels="rytec.channels.xml.xz"/channels="filtered.channels.xml"/' "/etc/epgimport/filtered.sources.xml"
fi
