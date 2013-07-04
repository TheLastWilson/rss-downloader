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

print @names;
print @rss_link;
print @exp;
