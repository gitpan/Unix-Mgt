#!/usr/bin/perl -w
use strict;
use Unix::Mgt;
use Test::More;
use Unix::SearchPathGuess ':all';

# go to test directory
BEGIN {
	use File::Spec;
	use File::Basename();
	my $thisf = File::Spec->rel2abs($0);
	my $thisd = File::Basename::dirname($thisf);
	chdir($thisd);
}

# load home-grown test libraries 
require './test-lib.pm';
require './module-lib.pm';

# tools for debugging
# use Debug::ShowStuff ':all';
# use Debug::ShowStuff::ShowVar;


#------------------------------------------------------------------------------
# check if this test is being run in an acceptable operating system
#
my ($bad_os);

# guess if this is Windows or cygwin
if ( ($^O =~ m|MSWin32|si) || ($^O =~ m|cygwin|si) )
	{ $bad_os = 1 }
else
	{ $bad_os = 0 }

# if this isn't an OS that this module supports, don't run any tests
if ($bad_os)
	{ plan skip_all => 'This module irrelevant on Windows' }
else
	{ plan tests => 21 }

#
# check if this test is being run in an acceptable operating system
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# test for existence of some necessary external commands
#
do {
	my ($local_path, @dirs);
	
	# get directories array
	$local_path = search_path_guess();
	@dirs = split(':', $local_path);
	@dirs = grep {m|\S|s} @dirs;
	@dirs = do { my %seen; grep { !$seen{$_}++ } @dirs };
	
	CMD_LOOP:
	foreach my $cmd (qw{adduser usermod groupadd}) {
		# println $cmd; ##i
		
		foreach my $dir (@dirs) {
			my ($path, $mode);
			$path = "$dir/$cmd";
			
			if (-e $path) {
				ok(1);
				next CMD_LOOP;
			}
		}
		
		# if we get this far then we didn't find the command
		ok(0);
	}
};
#
# test for existence of some necessary external commands
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
##= Unix::Mgt::User->get()
#
if (1) { ##i
	my ($user);
	
	# attempt to create user object without a user name fails
	$user = Unix::Mgt::User->get();
	mgt_err('missing-user-name');
	bool_check($user, 0);
	
	# attempt to create user object with nonexistent name fails
	$user = Unix::Mgt::User->get('djdjdjdjdjdjd');
	mgt_err('do-not-have-user');
	bool_check($user, 0);
	
	# create user object with existent name
	$user = Unix::Mgt::User->get('root');
	mgt_err(undef);
	bool_check($user, 1);
}
#
# Unix::Mgt::User->get()
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
##= Unix::Mgt::Group->get()
#
if (1) { ##i
	my ($group);
	
	##- attempt to create group object without a user name fails
	$group = Unix::Mgt::Group->get();
	mgt_err('missing-group-name');
	bool_check($group, 0);
	
	##- attempt to create group object with nonexistent name fails
	$group = Unix::Mgt::Group->get('djdjdjdjdjdjd');
	mgt_err('do-not-have-group');
	bool_check($group, 0);
	
	##- create group object with existent name
	$group = Unix::Mgt::User->get('root');
	mgt_err(undef);
	bool_check($group, 1);
}
#
# Unix::Mgt::Group->get()
#------------------------------------------------------------------------------


