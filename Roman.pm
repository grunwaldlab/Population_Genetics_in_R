package Roman;

use 5.006;
use strict;
use warnings;
our $VERSION='1.24';

=head1 NAME

Roman - functions for converting between Roman and Arabic numerals

=head1 VERSION

Version 1.24

=cut


=head1 SYNOPSIS

	use Roman;

	$arabic = arabic($roman) if isroman($roman);
	$roman = Roman($arabic);
	$roman = roman($arabic);

=head1 DESCRIPTION

This package provides some functions which help conversion of numeric
notation between Roman and Arabic.

=head1 Functions

=head2 isroman

Tests if argument is valid roman number

=head2 arabic

roman => arabic

=head2 Roman

arabic => roman

=head2 roman

Same as Roman, lowercase

=head1 BUGS

Domain of valid Roman numerals is limited to less than 4000, since
proper Roman digits for the rest are not available in ASCII.

Please report any bugs or feature requests to
C<bug-roman /AT/ rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Roman>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SEE ALSO

L<Text::Roman> - also handles conversion between Arabic and Roman numerals,
but can handle a larger range than this module.

L<Math::Roman> -
another module for converting between Arabic and Roman numerals.

L<Convert::Number::Roman> - handles the same conversion, but also lets
you specify upper or lower case.

L<Roman::Unicode> - make Roman numerals, using Unicode characters.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Roman

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Roman>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Roman>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Roman>

=item * Search CPAN

L<http://search.cpan.org/dist/Roman>

=back

=head1 AUTHOR

OZAWA Sakuro <ozawa at aisoft.co.jp> 1995-1997
Alexandr Ciornii, C<< <alexchorny at gmail.com> >> 2007

=head1 COPYRIGHT

Copyright (c) 1995 OZAWA Sakuro.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut

use Exporter 'import';
#our @ISA = qw(Exporter);
our @EXPORT = qw(isroman arabic Roman roman);

our %roman2arabic = qw(I 1 V 5 X 10 L 50 C 100 D 500 M 1000);
my %roman_digit = qw(1 IV 10 XL 100 CD 1000 MMMMMM);
my @figure = reverse sort keys %roman_digit;
#my %roman_digit;
$roman_digit{$_} = [split(//, $roman_digit{$_}, 2)] foreach @figure;

sub isroman($) {
    my $arg = shift;
    $arg ne '' and
      $arg =~ /^(?: M{0,3})
                (?: D?C{0,3} | C[DM])
                (?: L?X{0,3} | X[LC])
                (?: V?I{0,3} | I[VX])$/ix;
}

sub arabic($) {
    my $arg = shift;
    isroman $arg or return undef;
    my($last_digit) = 1000;
    my($arabic);
    foreach (split(//, uc $arg)) {
        my($digit) = $roman2arabic{$_};
        $arabic -= 2 * $last_digit if $last_digit < $digit;
        $arabic += ($last_digit = $digit);
    }
    $arabic;
}

sub Roman($) {
    my $arg = shift;
    0 < $arg and $arg < 4000 or return undef;
    my($x, $roman);
    foreach (@figure) {
        my($digit, $i, $v) = (int($arg / $_), @{$roman_digit{$_}});
        if (1 <= $digit and $digit <= 3) {
            $roman .= $i x $digit;
        } elsif ($digit == 4) {
            $roman .= "$i$v";
        } elsif ($digit == 5) {
            $roman .= $v;
        } elsif (6 <= $digit and $digit <= 8) {
            $roman .= $v . $i x ($digit - 5);
        } elsif ($digit == 9) {
            $roman .= "$i$x";
        }
        $arg -= $digit * $_;
        $x = $i;
    }
    $roman;
}

sub roman($) {
    lc Roman shift;
}

1; # End of Roman
