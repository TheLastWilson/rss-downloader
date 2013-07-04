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

$debug = 1; # set to 1 to stop program actually downloading also does not delete urls.list file
$verbose = 0; # print messages

$infile = "./urls.list";	# The temp file that holds the rss feed
$feedsfile = 'feeds'; 		# The file that contains all the feed links and names
$destination = '/test/';	# Tte Destination to save fils
open(FEEDS, $feedsfile);	# open feedsfile for reading feed info
@lines = <FEEDS>;
$logfile = '~/rss-downloader-log.txt'; # location of the log file

$default_regex = 'enclosure url="(http://.*\.m(p4|4v))"';   # RegEx searching for shows in .mp4 format


foreach $line(@lines)	{	# foreach loop to split the feeds file format = NAME,FEEDURL
  @temp = split(/,/, $line);
  push(@names, $temp[0]);  	# store the name of the feed
  push(@rss_link, $temp[1]);	# store the link for the rss feed
  if($temp[2]){ push(@exp, $temp[2]); }
  else{ push(@exp, $default_regex); }
}

my @matches; 	# Array to hold the details of matches from the RegEx

$counter = 0;

foreach $rss_link(@rss_link) {
  if($verbose eq 1) { print $rss_link."\n"; }
  getstore("$rss_link","$infile"); 	# download the rss feed for today.

  $downloaded = './downloaded/'.$names[$counter];
  open(INFILE, $infile);		# Open the temp file
  open(DOWNLOAD,$downloaded);	# Open the previously downloaded file (Read-Only)

  @prevdown = <DOWNLOAD>;		# store the previously downloaded files 
  if($verbose eq 1) { print "Ignoring $ignorenum files previously downloaded($download): \n @prevdown"; }

  close(DOWNLOAD); 	# Cloes the read-only status on the download file
  open(DOWNLOAD,">>$downloaded"); 	# Open with appened

  while ($line = <INFILE>){
    if ($line =~ $exp[$counter]) {  # Check RegEx
      $temp = 0;
      foreach $prevdown(@prevdown) { # Check against ignore list
       if($1."\n" eq $prevdown) { $temp = 2; }
      }
      
      if ($temp == 0) {
        print DOWNLOAD $1."\n";		# Print link to downloaded file
        if ($verbose eq 1) { print "Download:".$1."\n";	}		# Print linke to screen
        if ($debug == 0) {
          if ( $verbose eq 1 ) { print "download starting\n"; }
          system ("pushd $destination && wget $1 -nv -a $logfile && popd"); # command = move to /test/, execute "wget link", move back to previous folder
          if ( $verbose eq 1 ) { print "download stopping\n"; }
        } else { print "download not starting(in debug mode) for $1\n"; }
      } #if $temp
    } # if $linke $regex
  } # while $line

  close(INFILE);		# Close the file
  close(DOWNLOAD);
  if ($debug == 0) { unlink($infile); } 	# Delete urls.list
  $counter++;
}
