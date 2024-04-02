#! /usr/bin/perl
use strict;

use Data::Dumper;




$/ ="\r\n"; #The NTRIP source tables are CR/LF

my $skipped_header=1;
my $type;
my $mount;
my $id;
my $format;
my $format_details;
my $carrier;
my $nav;
my $network;
my $country;
my $lat;
my $long;
my $nmea;
my $solution;
my $generator;
my $comp;
my $authentication;
my $fee;
my $bitrate;
my $misc;

my $user=shift @ARGV;
my $user_org=shift @ARGV;
my $pass=shift @ARGV;
my $base_org="";
my $base="";

#print "<BODY>\n";

print "<TABLE BORDER=1  id=\"Mounts\" class=\"tablesorter\">\n";
printf("<thead><tr>\n");
#printf("   <th> Type</th>\n");
printf("   <th> Mount point</th>\n");
printf("   <th> Id</th>\n");
printf("   <th> Format</th>\n");
#printf("   <th> Format details</th>\n");
printf("   <th> Carrier Phase</th>\n");
printf("   <th> GNSS System</th>\n");
printf("   <th> Network</th>\n");
printf("   <th> Country</th>\n");
printf("   <th> Latitude</th>\n");
printf("   <th> Longitude</th>\n");
printf("   <th> NMEA</th>\n");
printf("   <th> Solution Type</th>\n");
printf("   <th> Generator</th>\n");
#printf("   <th> Compression</th>\n");
printf("   <th> Login</th>\n");
printf("   <th> Fee</th>\n");
#printf("   <th> bitrate</th>\n");
printf("   <th> Misc</th>\n");
printf("   <th> #Fields</th>\n");
printf("</tr></thead><tbody>\n");

while (<>) {
   chomp;
#   print "***+$_=\n";
   if ($skipped_header) {
       if ($_ ne "ENDSOURCETABLE" ) {
        printf("<tr>\n");
        ($type,$mount,$id,$format,$format_details,$carrier,$nav,$network,$country,$lat,$long,$nmea,$solution,$generator,$comp,$authentication,$fee,$bitrate,$misc) = split (/;/,$_,-1);
        my @fields = split(';', $_,  -1);
#        print (@fields[0]);
#        print Dumper(\@fields);

        my $num_fields = scalar @fields;

        if ($type eq "STR") {
   #        printf("   <TD>$type</TD>\n");
           printf("   <TD> ");
       if ( $mount =~ /(.*)-\((.*)\)/) {
#          print "Found org in mount" . $2;
           $base=$1;
           $base_org=$2;
        }
           else {
          $base_org=$user_org;
          $base=$mount;
        }

           print ("<a href=\"/cgi-bin/IBSS/ibss_mount.sh?USER=". $user. "&USER_ORG=".$user_org. "&PASS=".$pass."&BASE_ORG=".$base_org."&BASE=".$base."&HEADERS=\">".$mount);
           #status&USER_ORG=ntrip2&PASS=trimble&BASE=BERTHOUD&BASE_ORG=ntrip2&HEADERS=">$mount
           printf("</TD>\n");
           printf("   <TD> $id</TD>\n");
           printf("   <TD> $format</TD>\n");
   #        printf("   <TD> $format_details</TD>\n");
   #        printf("   <TD> $carrier</TD>\n");
           printf("   <TD> ");
           if ($carrier eq "0") {
              print "Code Only"
              }
           elsif ($carrier eq "1") {
              print "L1"
              }
           elsif ($carrier eq "2") {
              print "L1/L2"
              }
           elsif ($carrier eq "3") {
              print "L1/L2/L5"
              }
           else {
              print "Unknown $carrier"
              }

           printf("</TD>\n");

           printf("   <TD> $nav</TD>\n");
           printf("   <TD> $network</TD>\n");
           printf("   <TD> $country</TD>\n");
           printf("   <TD> $lat</TD>\n");
           printf("   <TD> $long</TD>\n");
           printf("   <TD> ");

           if ($nmea eq "0") { print "Must Not Send NMEA"}
           elsif ($nmea eq "1") { print "Must Send NMEA" }
           else { print "Unknown $nmea" }

           printf("</TD>\n");
           printf("   <TD> ");

           if ($solution eq "0") { print "Single base" }
           elsif ($solution eq "1") {print "Network"}
           else {print "Unknown $solution"}

           printf("</TD>\n");
           printf("   <TD> $generator</TD>\n");
#          printf("   <TD> $comp</TD>\n");
           printf("   <TD> ");

           if ($authentication eq "N") {print "No"}
           elsif ( $authentication eq  "B") {print "Required"}
           elsif ( $authentication eq  "D") {print "Digest"}
           else {print "Unknown $authentication"}

           printf("</TD>\n");
           printf("   <TD> ");
           if ($fee == "N") {print "No"}
           elsif ($fee == "Y") {print "Yes"}
           else {print "Unknown $fee"}

           printf("</TD>\n");
   #        printf("   <TD> $bitrate</TD>\n");
           printf("   <TD> $fields[$num_fields-1]</TD>\n");
           printf("   <TD> $num_fields</TD>\n");

           printf("</tr>\n");
   #        print"$type;$mount;$id;$format;$format_details;$carrier;$nav;$network;$country;$lat;$long;$nmea;$solution;$generator;$comp;$authentication;$fee;$bitrate;$misc\n";
            }
         }
       }
   else {
      $skipped_header = $_ eq "";
      }
   }

print "</tbody></TABLE>\n";
print <<'EOF';
<script>
$(document).ready(function()
{
   console.log("In ready");
   console.log($("#Mounts"));
   $("#Mounts").tablesorter({"theme": "blue"});
}
);
</script>
EOF


