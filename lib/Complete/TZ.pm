package Complete::TZ;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Common qw(:all);
use Complete::Util qw(hashify_answer);
use Sah::Schema::date::tz_offset;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_tz_name
                       complete_tz_offset
                       complete_tz
                );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Timezone-related completion routines',
};

$SPEC{complete_tz_name} = {
    v => 1.1,
    summary => 'Complete from list of timezone names',
    description => <<'_',

Currently implemented via looking at `/usr/share/zoneinfo`, so this only works
on systems that have that.

_
    args => {
        %arg_word,
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_tz_name {
    require Complete::File;

    my %args  = @_;
    my $word  = $args{word} // "";

    my $res = hashify_answer(Complete::File::complete_file(
        starting_path => '/usr/share/zoneinfo',
        handle_tilde => 0,
        allow_dot => 0,
        filter => sub {
            return 0 if $_[0] =~ /\.tab$/;
            1;
        },

        word => $word,
    ));
    $res->{path_sep} = '/';
    $res;
}

# old name
*complete_tz = \&complete_tz_name;

$SPEC{complete_tz_offset} = {
    v => 1.1,
    summary => 'Complete from list of existing timezone offsets (in the form of -HH:MM(:SS)? or +HH:MM(:SS)?)',
    description => <<'_',

_
    args => {
        %arg_word,
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_tz_offset {
    require Complete::Util;

    my %args  = @_;
    my $word  = $args{word} // "";

    Complete::Util::complete_array_elem(
        word => $word,
        array => \@Sah::Schema::date::tz_offset::TZ_STRING_OFFSETS,
    );
}

1;
# ABSTRACT:

=for Pod::Coverage ^(complete_tz)$

=head1 DESCRIPTION


=head1 SEE ALSO
