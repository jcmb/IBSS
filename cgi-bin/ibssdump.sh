#! /bin/bash
echo -e "Content-type: text/html\r\n\r\n"
echo -e "<html><head><title>NTRIP Table information</title></head><body>"
USER=`echo "$QUERY_STRING" | sed -n 's/^.*USER=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
USER_ORG=`echo "$QUERY_STRING" | sed -n 's/^.*USER_ORG=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
PASS=`echo "$QUERY_STRING" | sed -n 's/^.*PASS=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
HEADERS=`echo "$QUERY_STRING" | sed -n 's/^.*HEADERS=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
RAW=`echo "$QUERY_STRING" | sed -n 's/^.*RAWS=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`

#USER=status
#USER_ORG=ntrip3
#USER_ORG=ibss

echo -e "<h1>NTRIP Table information for $USER of $USER_ORG</h1>\n"
curl -f -D headers_$$ -o /tmp/st_$$ --connect-timeout 10 -m 300  -H "Ntrip-Version: Ntrip/2.0" -H "User-Agent: NTRIP CURL_NTRIP_TEST/0.1" -u $USER:$PASS  http://$USER_ORG.ibss.trimbleos.com:2101/
RES=$?
#echo "Result: $?"
#stat /tmp/st_$$
#echo perl ntripdump.pl <~/tmp/st_$$
#cat ~/tmp/st_$$
if [ $RES == 0 ]
then
    perl ibssdump.pl $USER $USER_ORG $PASS </tmp/st_$$
    echo "<p/>End of table"
else
    if [ $RES == 22 ]
    then
        echo "Invalid Password"
    else
        echo "Connection Error ($RES)"
    fi
fi

if [ $HEADERS ]
then
   echo "<br><H2>Headers</h2><pre>"
   cat headers_$$
   echo "</pre>"
fi

if [ $RAW ]
then
   echo "<br><H2>RAW</h2><pre>"
   cat /tmp/st_$$
   echo "</pre>"
fi

rm headers_$$
echo "</body></html>"
#echo "<pre>";
rm /tmp/st_$$
