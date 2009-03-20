#!/usr/bin/perl
#
# Author: Craig Wilson (Craigawilson at gmail dot com)
#
# Origonal Author: Mat Miehling (mamiehling at gmail dot com)
#
# Please feel free to edit/distribute this file, but PLEASE do not
#    claim my work as your own.
#

use LWP::Simple;

$infile = "./urls.list";		# The temp file that holds the rss feed
$download = "./downloaded";		# The file that holds the links for the previously downloaded shows
@rss_link = ('http://revision3.com/systm/feed/quicktime-high-definition/', 'http://revision3.com/tekzilla/feed/quicktime-high-definition/?subshow=false', 'http://revision3.com/hak5/feed/quicktime-large/'); # Array holding RSS links


#$rss_link = 'http://revision3.com/systm/feed/quicktime-high-definition/'; # Array holding RSS links


$regex = 'enclosure url="(http://.*\.mp4)"'; # RegEx searching for shows in .mp4 format
my @matches; # Array to hold the details of matches from the RegEx

foreach $rss_link(@rss_link)
{
 print $rss_link."\n";
 getstore("$rss_link","$infile"); # download the rss feed for today.

 open(INFILE, $infile);		# Open the temp file
 open(DOWNLOAD,$download);	# Open the previously downloaded file (Read-Only)

 @prevdown = <DOWNLOAD>;		# store the previously downloaded files 
#print "Ignoring $ignorenum files previously downloaded($download): \n @prevdown"; 

 close(DOWNLOAD); 	# Cloes the read-only status on the download file
 open(DOWNLOAD,">>$download"); 	# Open with appened
 
 while ($line = <INFILE>)
 {
  if ($line =~ $regex)	# Check RegEx
  {
    $temp = 0;
    foreach $prevdown(@prevdown) # Check against ignore list
    {
     if($1."\n" eq $prevdown)
     { 
      $temp = 2;
     }
    }
    
    if ($temp == 0)
    {
     print DOWNLOAD $1."\n";		# Print link to downloaded file
     print "Download:".$1."\n";			# Print linke to screen
     exec ('pushd /test/ && wget '.$1."&& popd"); # command = move to /test/, execute "wget link", move back to previous folder
    } #if $temp
   
  } # if $linke $regex
 } # while $line

 close(INFILE);		# Close the file
 close(DOWNLOAD);
 unlink($infile); 	# Delete urls.list
}
