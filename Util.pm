package String::Util;
use strict;
use Carp;
# use Debug::ShowStuff ':all';

# version
use vars '$VERSION';
$VERSION = '0.11';


=head1 NAME

String::Util -- Handy string processing utilities

=head1 SYNOPSIS

  use String::Util ':all';
  
  # "crunch" whitespace and remove leading/trailing whitespace
  $val = crunch($val);
  
  # does this value have "content", i.e. it's defined
  # and has something besides whitespace?
  if (hascontent $val) {...}
  
  # format for display in web page
  $val = htmlesc($val);
  
  # remove leading/trailing whitespace
  $val = trim($val);
  
  # ensure defined value
  $val = define($val);
  
  # remove leading/trailing quotes
  $val = unquote($val);
  
  # remove all whitespace
  $val = nospace($val);
  
  # remove trailing \r and \n, regardless of what
  # the OS considers an end-of-line
  $val = fullchomp($val);
  
  # or call in void context:
  fullchomp $val;
  
  # encrypt string using random seed
  $val = randcrypt($val);
  
  # are these two values equal, where two undefs count as "equal"?
  if (equndef $a, $b) {...}
  
  # are these two values different, where two undefs count as "equal"?
  if (neundef $a, $b) {...}
  
  # get a random string of some specified length
  $val = randword(10);

=head1 DESCRIPTION

String::Util provides a collection of small, handy utilities for processing
strings.

=head1 INSTALLATION

String::Util can be installed with the usual routine:

	perl Makefile.PL
	make
	make test
	make install

You can also just copy Util.pm into the String/ directory of one of your
library trees.

=head1 FUNCTIONS

=cut




#------------------------------------------------------------------------------
# export
# 
use vars qw[@EXPORT_OK %EXPORT_TAGS @ISA];
@ISA = 'Exporter';

# the following functions accept a value and return a modified version of that value
push @EXPORT_OK, qw[
	crunch     htmlesc    trim        define
    unquote    nospace    fullchomp   randcrypt
];

# the following functions return true of false based on their input
push @EXPORT_OK, qw[ hascontent equndef neundef ];

# the following function returns a random word
push @EXPORT_OK, qw[ randword ];

%EXPORT_TAGS = ('all' => [@EXPORT_OK]);
# 
# export
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# crunch
# 

=head1 crunch(string)

Crunches all whitespace in the string down to single spaces.  Also removes all
leading and trailing whitespace.  Undefined input results in undefined output.

=cut

sub crunch {
	my ($val) = @_;
	
	if (defined $val) {
		$val =~ s|^\s+||s;
		$val =~ s|\s+$||s;
		$val =~ s|\s+| |sg;
	}
	
	return $val;
}
# 
# crunch
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# hascontent
# 

=head1 hascontent(scalar)

Returns true if the given argument contains something besides whitespace.

This function tests if the given value is defined and, if it is, if that
defined value contains something besides whitespace.

An undefined value returns false.  An empty string returns false.  A value
containing nothing but whitespace (spaces, tabs, carriage returns,
newlines, backspace) returns false.  A string containing any other
characers (including zero) returns true.

=cut

sub hascontent {
	my ($val) = @_;
	
	defined($val) or return 0;
	$val =~ m|\S|s or return 0;
	
	return 1;
}
# 
# hascontent
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# trim
# 

=head1 trim(string)

Returns the string with all leading and trailing whitespace removed.
Trim on undef returns undef.

=cut

sub trim{
	my ($val) = @_;
	
	if (defined $val) {
		$val =~ s|^\s+||s;
		$val =~ s|\s+$||s;
	};
	
	return $val;
}
# 
# trim
#------------------------------------------------------------------------------



#------------------------------------------------------------------------------
# nospace
# 

=head1 nospace(string)

Removes all whitespace characters from the given string.

=cut

sub nospace {
	my ($val) = @_;
	
	if (defined $val)
		{ $val =~ s|\s+||gs }
	
	return $val;
}
# 
# nospace
#------------------------------------------------------------------------------



#------------------------------------------------------------------------------
# htmlesc
# 

=head1 htmlesc(string)

Formats a string for literal output in HTML.  An undefined value is
returned as an empty string.

htmlesc is very similar to CGI.pm's escapeHTML.  If your script already
loads CGI.pm, you may well not need htmlesc.  However, there are a few
differences.  htmlesc changes an undefined value to an empty string, whereas
escapeHTML returns undefs as undefs and also results in a warning.  Also,
escapeHTML will not modify a value in place: you always have to store the
return value, even in you're putting it back in to the variable the value
came from.  It's a matter of taste.


=cut

sub htmlesc{
	my ($val) = @_;
	
	if (defined $val) {
		$val =~ s|\&|&amp;|g;
		$val =~ s|\"|&quot;|g;
		$val =~ s|\<|&lt;|g;
		$val =~ s|\>|&gt;|g;
	}
	else
		{$val = ''}
	
	return $val;
}
# 
# htmlesc
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# unquote
# 

=head1 unquote(string)

If the given string starts and ends with quotes, removes them.
Recognizes single quotes and double quotes.  The value must begin
and end with same type of quotes or nothing is done to the value.
Undef input results in undef output.  

=cut

sub unquote {
	my ($val) = @_;
	
	if (defined $val) {
		$val =~ s|^\"(.*)\"$|$1|s or
		$val =~ s|^\'(.*)\'$|$1|s;
	}	
	
	return $val;
}
# 
# unquote
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# define
# 

=head1 define(scalar)

Takes a single value as input. If the value is defined, it is
returned unchanged.  If it is not defined, an empty string is returned.

This subroutine is useful for printing when an undef should simply be represented
as an empty string.  Granted, Perl already treats undefs as empty strings in
string context, but this sub makes -w happy.  And you ARE using -w, right?

=cut

sub define {
	my ($val) = @_;
	defined($val) or $val = '';
	return $val;
}
# 
# define
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# randword
# 

=head1 randword(length, %options)

Returns a random string of characters. String will not contain any vowels (to
avoid distracting dirty words). First argument is the length of the return
string.  

=head2 option: numerals

If the numerals option is true, only numerals are returned, no alphabetic
characters.

=head2 option: strip_vowels

This option is true by default.  If true, vowels are not included in the
returned random string.

=cut

sub randword {
	my ($count, %opts) = @_;
	my ($rv, $char, @chars);
	$rv = '';
	@chars = ('a' .. 'z', 'A' .. 'Z', '0' .. '9');
	
	defined($count) or croak 'syntax: randword($count)';
	
	# defaults
	defined($opts{'strip_vowels'}) or $opts{'strip_vowels'} = 1;
	
	while (length($rv) < $count) {
		$char = rand();
				
		# numerals random word
		if ($opts{'numerals'}) {
			$char =~ s|^0.||;
			$char =~ s|\D||g;
		}
		
		# character random word
		else {
			$char = int($char * $#chars);
			$char = $chars[$char];
			next if($opts{'strip_vowels'} && $char =~ m/[aeiouy]/i);
		}
		
		$rv .= $char;
	}
	
	return substr($rv, 0, $count);
}
# 
# randword
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# equndef
# 

=head1 equndef($str1, $str2)

Returns true if the two given strings are equal.  Also returns true if both
are undef.  If only one is undef, or if they are both defined but different,
returns false.

=cut

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
# neundef
# 

=head1 neundef($str1, $str2)

The opposite of equndef, returns true if the two strings are *not* the same.

=cut

sub neundef {
	return equndef(@_) ? 0 : 1;
}
# 
# neundef
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# fullchomp
# 

=head1 fullchomp(string)

Works like chomp, but is a little more thorough about removing \n's and \r's
even if they aren't part of the OS's standard end-of-line.

Undefs are returned as undefs.

=cut

sub fullchomp {
	my ($line) = @_;
	defined($line) and $line =~ s|[\r\n]+$||s;
	defined(wantarray) and return $line;
	$_[0] = $line;
}
# 
# fullchomp
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# randcrypt
# 

=head1 randcrypt(string)

Crypts the given string, seeding the encryption with a random
two character seed.

=cut

sub randcrypt {
	my ($pw) = @_;
	my ($rv);
	$rv = crypt($pw, randword(2));
	return $rv;
}
# 
# randcrypt
#------------------------------------------------------------------------------



# return true
1;


__END__

=head1 TERMS AND CONDITIONS

Copyright (c) 2005 by Miko O'Sullivan.  All rights reserved.  This program is 
free software; you can redistribute it and/or modify it under the same terms 
as Perl itself. This software comes with B<NO WARRANTY> of any kind.

=head1 AUTHORS

Miko O'Sullivan
F<miko@idocs.com>


=head1 VERSION

=over

=item Version 0.10    December 1, 2005

Initial release

=item Version 0.11    December 22, 2005

This is a non-backwards compatible version.

urldecode, urlencode were removed entirely.  All of the subs that used to
modify values in place were changed so that they do not do so anymore, except
for fullchomp.

See http://www.xray.mpe.mpg.de/mailing-lists/modules/2005-12/msg00112.html
for why these changes were made.

=item Version 0.12    Oct 15, 2008

Final version.  As of this version String::Util is no longer under development
or being supported.


=back


=cut
