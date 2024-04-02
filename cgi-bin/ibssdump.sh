#! /bin/bash
echo -e "Content-type: text/html\r\n\r\n"

cat  <<EOF
<html><head>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="/jquery.tablesorter.min.js"></script>
<link rel="stylesheet" type="text/css" href="/css/style.css"></link>
<title>NTRIP Table information</title></head>
<body class="page">
<div class="container clearfix">
  <div style="padding: 10px 10px 10px 0 ;"> <a href="http://construction.trimble.com/">
        <img src="/images/trimble-logo.png" alt="Trimble Logo" id="logo"> </a>
      </div>
  <!-- end #logo-area -->
</div>
<div id="top-header-trim"></div>
<div id="content-area">
<div id="content">
<div id="main-content" class="clearfix">

EOF

USER=`echo "$QUERY_STRING" | sed -n 's/^.*USER=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
USER_ORG=`echo "$QUERY_STRING" | sed -n 's/^.*USER_ORG=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
PASS=`echo "$QUERY_STRING" | sed -n 's/^.*PASS=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
HEADERS=`echo "$QUERY_STRING" | sed -n 's/^.*HEADERS=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
RAW=`echo "$QUERY_STRING" | sed -n 's/^.*RAW=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`

#USER=status
#USER_ORG=ntrip3
#USER_ORG=ibss
#PASS=trimble

echo -e "<h1>NTRIP Table information for $USER of $USER_ORG</h1>\n"
curl -f --silent -D /tmp/headers_$$ -o /tmp/st_$$ --connect-timeout 10 -m 300  -H "Ntrip-Version: Ntrip/2.0" -H "User-Agent: NTRIP CURL_NTRIP_TEST/0.1" -u $USER:$PASS  https://$USER_ORG.ibss.trimbleos.com:52101/
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
   cat /tmp/headers_$$
   echo "</pre>"
fi

if [ $RAW ]
then
   echo "<br><H2>RAW</h2><pre>"
   cat /tmp/st_$$
   echo "</pre>"
fi

rm /tmp/headers_$$
echo "</div></div></div></div></body></html>"
#echo "<pre>";
rm /tmp/st_$$
