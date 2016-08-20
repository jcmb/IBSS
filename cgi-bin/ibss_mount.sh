#! /bin/bash
echo -e "Content-type: text/html\r\n\r\n"
echo -e "<html><head><title>NTRIP Connection information</title></head><body>"
USER=`echo "$QUERY_STRING" | sed -n 's/^.*USER=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
USER_ORG=`echo "$QUERY_STRING" | sed -n 's/^.*USER_ORG=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
BASE_ORG=`echo "$QUERY_STRING" | sed -n 's/^.*BASE_ORG=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
PASS=`echo "$QUERY_STRING" | sed -n 's/^.*PASS=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
BASE=`echo "$QUERY_STRING" | sed -n 's/^.*BASE=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
HEADERS=`echo "$QUERY_STRING" | sed -n 's/^.*HEADERS=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`


echo -e "<h1>IBSS base station $BASE information for $USER of $USER_ORG</h1>\n"
echo -e "<br>This test takes 15 seconds"
# echo curl -f  --connect-timeout 10 -m 10  -H "Ntrip-Version: Ntrip/2.0" -H "User-Agent: NTRIP CURL_NTRIP_TEST/0.1" -u $USER:$PASS  http://$USER_ORG.ibss.trimbleos.com:2101/$BASE
./NtripClient.py --V2 --HeaderFile /tmp/headers_$$  -f /tmp/st_$$   -m 10  -u $USER -p $PASS -b $BASE_ORG -o $USER_ORG $BASE
#echo "Result: $?"
echo "<br><H2>Status:</h2><br>"
perl -f ibss_mount.pl < /tmp/headers_$$
RES=$?
echo "</pre>"
if [ $RES == 0 ]
then
   echo "<H2>Data:</H2>"

   if [ -s /tmp/st_$$ ]
   then
      Size=`stat -c %s /tmp/st_$$`
      echo "Base is sending data ($Size bytes)"
      rm /tmp/st_$$
   else
      echo "Base is not sending data"
   fi
fi

if [ $HEADERS ]
then
   echo "<br><H2>Headers</h2><pre>"
   cat headers_$$
   echo "</pre>"
fi

rm /tmp/headers_$$
echo "</body></html>"
#echo "<pre>";
#cat ~/tmp/st_$$
