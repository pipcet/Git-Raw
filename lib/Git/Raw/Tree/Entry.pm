package Git::Raw::Tree::Entry;

use strict;
use warnings;

use Git::Raw;

=head1 NAME

Git::Raw::Tree::Entry - Git tree entry class

=head1 DESCRIPTION

A C<Git::Raw::Tree::Entry> represents an entry in a L<Git::Raw::Tree>.

B<WARNING>: The API of this module is unstable and may change without warning
(any change will be appropriately documented in the changelog).

=head1 METHODS

=head2 id( )

Retrieve the id of the tree entry, as string.

=head2 name( )

Retrieve the filename of the tree entry.

=head2 object( $repo )

Retrieve the object pointed by the tree entry.

=head2 filemode( )

Retrieve the file mode of the tree entry, as a string containing six
octal digits, such as "100644" or "040000".

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

my %objects;

sub register {
    $objects{$$self} = $self;
    Scalar::Util::weaken($objects{$$self});
}

sub CLONE {
    for my $key (keys %objects) {
	my $self = delete $objects{$key};

	$self->_possess;

	$self->register;
    }
}

1; # End of Git::Raw::Tree::Entry
sub CLONE_SKIP {
    return 1;
}

1;