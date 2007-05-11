package Data::StackedMap;

use 5.00503;
use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '0.01';

use strict;
use warnings;

use Carp qw(croak);

sub new {
    my ($pkg) = @_;
    
    my $self = bless [{}], $pkg;
    
    return $self;
}

sub delete {
    my ($self, $key) = @_;
    
    return delete $self->[-1]->{$key};    
}

sub exists {
    my ($self, $key) = @_;
    
    for my $layer (1..@$self) {
        return -$layer if exists $self->[-$layer]->{$key};
    }
    
    return 0;
}

sub get {
    my ($self, $key) = @_;

    my $layer = $self->exists($key);
    return $self->[$layer]->{$key} if $layer;
    
    return;
}

sub set {
    my ($self, $key, $value) = @_;
    
    $self->[-1]->{$key} = $value;
}

sub push {
    my $self = shift;
    push @$self, {};
}

sub pop {
    my $self = shift;

    if (@$self == 1) {
        croak "Can't pop single layer stack";
    }

    return pop @$self;
}

sub size {
    my $self = shift;
    return scalar @$self;
}

1;
__END__

=head1 NAME

Data::StackedMap - An object that stores key/value pairs in a stacked fashion

=head1 SYNOPSIS

    use Data::StackedMap;
    
    my $data = Data::StackedMap->new();

    $data->set("foo" => 10);
    print $data->get("foo"); # prints '10'

    $data->push();
    print $data->get("foo"); # still prints '10'
    
    $data->set("foo" => 20);
    print $data->get("foo"); # now prints '20'
    
    $data->pop();
    print $data->get("foo"); # prints '10' again

=head1 DESCRIPTION

This class implements a simple key/value map where each key can exist multiple times in different 
layers in a stack.

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new ()

Creates a new instance of this class. 

=back

=head2 INSTANCE METHODS

=over 4

=item exists ( $key )

Checks if data with the key I<$key> exists anywhere in the stack. Returns the layer (from the top) 
in which the key is first found. -1 for top-most layer, -2 for second top-most layer and so forth. 
Returns 0 if the key is not found at all.

=item delete ( $key )

Deletes the value of I<$key> at the top of the stack. If an entry with the same key exists down the 
stack C<get> and C<exists> will operate on that value.

=item get ( $key )

Returns the value of I<$key> or undef it the key doesn't exist. Will search down the stack 
to find the value.

=item set ( $key => $value )

Sets the value of I<$key> to I<$value>.

=item push ()

Creates a new current map in the stack.

=item pop ()

Removes the current stack entry. Will throw an error if called when there is only 
one map in the stack.

=item size ()

Returns the length of the stack, i.e. how many layers deep it currently is.

=back

=head1 SEE ALSO

L<Tie::Hash::Stack>

L<Data::StackedHash>

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to C<bug-data-stackedmap@rt.cpan.org>, 
or through the web interface at L<http://rt.cpan.org>.

=head1 AUTHOR

Claes Jakobsson C<< <claesjac@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Claes Jakobsson C<< <claesjac@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
