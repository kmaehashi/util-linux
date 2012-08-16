#!/usr/bin/perl

# Archive File Exporter
# @author Kenichi Maehashi

use strict;
use warnings;
use utf8;

use CGI;

#### CONFIGURATION
my $STORAGE_SERVER = "//192.168.1.2/share";
my $STORAGE_SERVER_DIR = "/home/kenichi/public_html/storage";
my $SHARES_DIR = "/home/kenichi/shares";


### PROTOTYPES
sub is_storage_mounted();
sub mount_storage();
sub error($);


my $cgi = new CGI;

if (not is_storage_mounted()) {
	mount_storage() || error('Failed to mount the storage "' . $STORAGE_SERVER . '" on "' . $STORAGE_SERVER_DIR . '".');
}


sub is_storage_mounted() {
	# TODO
	return 0;
}

sub mount_storage() {
	# TODO
	# mount -t cifs -o ro,user=guest,guest,iocharset="sjis" //192.168.1.5/shared public_html/terastation

	return 0;
}

sub error($) {
	my $msg = shift;

	print $cgi->header(-charset => 'UTF-8');
	print $cgi->start_html(-title => 'Error!', -encoding => 'UTF-8');
	print $msg;
	print $cgi->end_html;
}



