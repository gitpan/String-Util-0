#!/usr/bin/perl -w
use strict;
use String::Util ':all';
use Test;
BEGIN { plan tests => 11 };

# general purpose variable
my ($val, $org, $new);

# stubs for comparison subroutines
sub err;
sub comp;


#------------------------------------------------------------------------------
# eq_undef, neundef
# 
unless (equndef 'a', 'a')
	{ err 'equndef', 'failed comparison of identical defined values' }

unless (equndef undef, undef)
	{ err 'equndef', 'failed comparison of two undefined values' }

if (equndef 'a', 'b')
	{ err 'equndef', 'failed comparison of different defined values' }

if (equndef 'a', undef)
	{ err 'equndef', 'failed comparison of defined and undefined values' }


if (neundef 'a', 'a')
	{ err 'neundef', 'failed comparison of identical defined values' }

if (neundef undef, undef)
	{ err 'neundef', 'failed comparison of two undefined values' }

unless (neundef 'a', 'b')
	{ err 'neundef', 'failed comparison of different defined values' }

unless (neundef 'a', undef)
	{ err 'neundef', 'failed comparison of defined and undefined values' }


ok (1);
# 
# eq_undef, neundef
#------------------------------------------------------------------------------



#------------------------------------------------------------------------------
# crunch
# 

# basic crunching
$val = "  Starflower \n\n\t  Miko     ";
$val = crunch($val);
comp $val, 'Starflower Miko';

# crunch on undef returns undef
if (defined crunch(undef))
	{ err 'crunch', 'returned defined output for undefined input' }

ok (1);
# 
# crunch
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# trim
# 

# basic trimming
$val = '  steve     ';
$val = trim($val);
comp $val, 'steve';

# trim on undef returns undef
if (defined trim(undef))
	{ err 'trim', 'returned defined output for undefined input' }

ok (1);
# 
# trim
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# nospace
# 

# removal of spaces
$val = "  Starflower \n\t  Miko   ";
$val = nospace($val);
comp $val, 'StarflowerMiko';

ok (1);
# 
# trim
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# define
# 

# define an undef
undef $val;
$val = define($val);
comp $val, '';

# define an already defined value
$val = 'x';
define $val;
comp $val, 'x';

ok (1);
# 
# define
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# unquote
# 

# single quotes
$val = "'Starflower'";
$val = unquote($val);
comp $val, 'Starflower';

# double quotes
$val = '"Starflower"';
$val = unquote($val);
comp $val, 'Starflower';

# no quotes
$val = 'Starflower';
$val = unquote($val);
comp $val, 'Starflower';

ok (1);
# 
# unquote
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# htmlesc
# 

# basic operation of htmlesc
$val = '<>"&';
$val = htmlesc($val);
comp $val, '&lt;&gt;&quot;&amp;';

# change undef to empty string
undef $val;
$val = htmlesc($val);
comp $val, '';

ok (1);
# 
# htmlesc
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# fullchomp
# 

# scalar context
$val = qq|Starflower\n\r\r\r\n|;
$val = fullchomp($val);
comp $val, 'Starflower';

ok (1);
# 
# fullchomp
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# hascontent
# 
undef $val;
hascontent($val) and err 'hascontent', 'returned true on undef';

$val = '';
hascontent($val) and err 'hascontent', 'returned true on empty string';

$val = "   \t   \n\n  \r   \n\n\r     ";
hascontent($val) and err 'hascontent', 'returned true on string that just has whitespace';

$val = '0';
hascontent($val) or err 'hascontent', 'returned false on zero';

$val = ' x ';
hascontent($val) or err 'hascontent', 'returned false defined string with an "x" in it';

ok(1);
# 
# hascontent
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# randword
# 
# Not sure how to test this besides making sure it actually runs.
# 
undef $val;
$val = randword(20);

unless ( defined($val) && (length($val) == 20) )
	{ err 'randword', 'failed to return random string of appropriate length' }

ok(1);
# 
# randword
#------------------------------------------------------------------------------



#------------------------------------------------------------------------------
# randcrypt
# 
# Not sure how to test this besides making sure it actually runs.
# 
$val = 'Mypassword';
$val = randcrypt($val);

ok(1);
# 
# randcrypt
#------------------------------------------------------------------------------


###############################################################################
# end of tests
###############################################################################


#------------------------------------------------------------------------------
# err
# 
sub err {
	my ($function_name, $err) = @_;
	
	print STDERR $function_name, ': ', $err, "\n";
	exit;
	ok(0);
}
# 
# err
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# comp
# 
sub comp {
	my ($is, $shouldbe) = @_;
	
	if(! equndef($is, $shouldbe)) {
		print STDERR 
			"\n",
			"\tis:         ", (defined($is) ?       $is       : '[undef]'), "\n",
			"\tshould be : ", (defined($shouldbe) ? $shouldbe : '[undef]'), "$shouldbe\n\n";	
		ok(0);
		exit;
	}
}
# 
# comp
#------------------------------------------------------------------------------

