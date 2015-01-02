use strict;
use FileHandle;
use Carp 'confess';

# debugging
# use Debug::ShowStuff ':all';
# use Debug::ShowStuff::ShowVar;


#------------------------------------------------------------------------------
# comp
#
sub comp {
	my ($is, $shouldbe, $test_name) = @_;
	
	# TESTING
	# println subname(); ##i
	
	# $test_name is required
	$test_name or confess ('$test_name is required');
	
	if(! equndef($is, $shouldbe)) {
		if ($ENV{'IDOCSDEV'}) {
			print STDERR 
				"\n",
				"\tis:         ", (defined($is) ?       $is       : '[undef]'), "\n",
				"\tshould be : ", (defined($shouldbe) ? $shouldbe : '[undef]'), "\n\n";
		}
		
		set_ok(0, "$test_name: values do not match");
	}
	
	else {
		set_ok(1, "$test_name: values match");
	}
}
#
# comp
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# slurp
#
sub slurp {
	my ($path) = @_;
	my $in = FileHandle->new($path);
	$in or die $!;
	return join('', <$in>);
}
#
# slurp
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# arr_comp
#
sub arr_comp {
	my ($alpha_sent, $beta_sent, $test_name, %opts) = @_;
	my (@alpha, @beta);
	
	# TESTING
	# println subname(); ##i
	
	# $test_name is required
	$test_name or confess ('$test_name is required');
	
	# both must be array references
	unless (
		UNIVERSAL::isa($alpha_sent, 'ARRAY') &&
		UNIVERSAL::isa($beta_sent, 'ARRAY')
		)
		{ die 'both params must be array references' }
	
	# if they have different lengths, they're different
	if (@$alpha_sent != @$beta_sent)
		{ set_ok(0, $test_name) }
	
	# get arrays to use for comparison
	@alpha = @$alpha_sent;
	@beta = @$beta_sent;
	
	# if order insensitive
	if ($opts{'order_insensitive'}) {
		@alpha = sort @alpha;
		@beta = sort @beta;
	}
	
	# if case insensitive
	if ($opts{'case_insensitive'}) {
		grep {$_ = lc($_)} @alpha;
		grep {$_ = lc($_)} @beta;
	}
	
	# loop through array elements
	for (my $i=0; $i<=$#alpha; $i++) { ##i
		# if one is undef but other isn't
		if (
			( (  defined $alpha[$i]) && (! defined $beta[$i]) ) ||
			( (! defined $alpha[$i]) && (  defined $beta[$i]) )
			) {
			set_ok(0, $test_name);
		}
		
		# if $alpha[$i] is undef then both must be, so they're the same
		elsif (! defined $alpha[$i]) {
		}
		
		# both are defined
		else {
			unless ($alpha[$i] eq $beta[$i])
				{ set_ok(0, $test_name) }
		}
	}
	
	# if we get this far, they're the same
	set_ok(1, $test_name);
}
#
# arr_comp
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# check_isa
#
sub check_isa {
	my ($ob, $class, $test_name) = @_;
	
	# $test_name is required
	$test_name or confess ('$test_name is required');
	
	set_ok(UNIVERSAL::isa( $ob, $class), $test_name);
}
#
# check_isa
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# equndef
#
sub equndef {
	my ($str1, $str2) = @_;
	
	# if both defined
	if ( defined($str1) && defined($str2) )
		{return $str1 eq $str2}
	
	# if neither are defined 
	if ( (! defined($str1)) && (! defined($str2)) )
		{return 1}
	
	# only one is defined, so return false
	return 0;
}
#
# equndef
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# stringify_tokens
#
sub stringify_tokens {
	my (@orgs) = @_;
	my (@rv);
	
	# loop through original tokens and build array of string versions
	foreach my $org (@orgs) {
		if (UNIVERSAL::isa $org, 'JSON::Relaxed::Parser::Token::String') {
			push @rv, $org->{'raw'};
		}
		else {
			push @rv, $org;
		}
	}
	
	# return new array
	return @rv;
}
#
# stringify_tokens
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# set_ok
#
sub set_ok {
	my ($ok, $test_name) = @_;
	
	# TESTING
	# println subname(); ##i
	
	# $test_name is required
	$test_name or confess ('$test_name is required');
	
	# development environment
	if ($ENV{'IDOCSDEV'}) {
		if ($ok) {
			return 1;
		}
		
		else {
			die($test_name);
		}
	}
	
	# else regular ok
	# ok($ok, '[1] ' . compact($test_name));
	ok($ok, compact($test_name));
}
#
# set_ok
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# key_count
#
sub key_count {
	my ($hash, $count, $test_name) = @_;
	
	# $test_name is required
	$test_name or confess ('$test_name is required');
	
	unless (scalar(keys %$hash) == $count) {
		set_ok(
			0,
			
			'hash should have ' .
			$count . ' ' .
			'element' .
			( ($count == 1) ? '' : 's' ) . ' ' .
			'but actually has ' .
			scalar(keys %$hash),
			
			$test_name
		);
	}
	
	set_ok(1, $test_name);
}
#
# key_count
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# bool_check
#
sub bool_check {
	my ($is_got, $should_got, $test_name) = @_;
	my ($is_norm, $should_norm);
	
	# $test_name is required
	$test_name or confess ('$test_name is required');
	
	# normalize boolean values
	$is_norm = $is_got ? 1 : 0;
	$should_norm = $should_got ? 1 : 0;
	
	if ($is_norm ne $should_norm) {
		print STDERR 
			"\n",
			"\tis:         ", (defined($is_got)     ? $is_got     : '[undef]'), "\n",
			"\tshould be : ", (defined($should_got) ? $should_got : '[undef]'), "\n\n";
		set_ok(0, $test_name);
		
		# return false
		return 0;
	}
	
	# ok
	set_ok(1, $test_name);
	
	# return true
	return 1;
}
#
# bool_check
#------------------------------------------------------------------------------



#------------------------------------------------------------------------------
# el_count
#
sub el_count {
	my ($arr, $count, $test_name) = @_;
	
	# $test_name is required
	$test_name or confess ('$test_name is required');
	
	unless (scalar(@$arr) == $count) {
		set_ok(
			0,
			
			'array should have ' .
			$count . ' ' .
			'element' .
			( ($count == 1) ? '' : 's' ) . ' ' .
			'but actually has ' .
			scalar(@$arr),
			
			$test_name
		);
	}
	
	set_ok(1, $test_name);
}
#
# el_count
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# compact
#
sub compact {
	my ($val) = @_;
	
	if (defined $val) {
		$val =~ s|^\s+||s;
		$val =~ s|\s+$||s;
		$val =~ s|\s+| |sg;
	}
	
	return $val;
}
#
# compact
#------------------------------------------------------------------------------


# return true
1;
