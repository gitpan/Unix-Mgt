use strict;
use IPC::System::Simple 'capturex';
use Unix::SearchPathGuess 'cmd_path_guess';

# debugging
# use Debug::ShowStuff ':all';
# use Debug::ShowStuff::ShowVar;


#------------------------------------------------------------------------------
# mgt_err
#
sub mgt_err {
	my ($should) = @_;
	return set_ok(comp($Unix::Mgt::err_id, $should));
}
#
# mgt_err
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# reset_users_groups
#

# config
my $ug_count = 10;

sub reset_users_groups {
	my ($users, $groups);
	
	# initialize mod-only users and groups
	$users = $Unix::Mgt::User::MOD_ONLY = {};
	$groups = $Unix::Mgt::Group::MOD_ONLY = {};
	
	# loop through indexes
	foreach my $idx (1..$ug_count) {
		# only modify this user and group in Unix::Mgt;
		$users->{"u$idx"} = 1;
		$users->{"g$idx"} = 1;
		$groups->{"u$idx"} = 1;
		$groups->{"g$idx"} = 1;
		
		# user
		foreach my $type (qw{u g}) {
			if ( getpwnam("$type$idx") ) {
				my @cmd = (cmd_path_guess('deluser'), '--remove-home', "$type$idx");
				capturex(@cmd);
			}
			
			# group
			if ( getgrnam("$type$idx") ) {
				my @cmd = (cmd_path_guess('delgroup'), "$type$idx");
				capturex(@cmd);
			}
		}
	}
};
#
# reset_users_groups
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# show_err
#
sub show_err {
	my ($should) = @_;
	
	# if any error, display it
	if ($Unix::Mgt::err_id) {
		print
			'error:', "\n",
			"   $Unix::Mgt::err_id\n",
			"   $Unix::Mgt::err_msg\n";
	}
	
	# else output that there isn't an error
	else {
		print "no Unix::Mgt error\n";
	}
}
#
# show_err
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# show_user
#
sub showuser { return show_user(@_) }

sub show_user {
	my ($user) = @_;
	
	if ($user) {
		# showhash($user, title=>'$user');
		foreach my $key (keys %$user) {
			print $key, ' = ', $user->{$key}, "\n";
		}
	}
	else {
		print "no \$user\n";
	}
}
#
# show_user
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# show_group
#
sub showgroup { return show_group(@_) }

sub show_group {
	my ($group) = @_;
	
	if ($group) {
		foreach my $key (keys %$group) {
			print $key, ' = ', $group->{$key}, "\n";
		}
	}
	else {
		print "no \$group\n";
	}
}
#
# show_group
#------------------------------------------------------------------------------


# return true
1;
