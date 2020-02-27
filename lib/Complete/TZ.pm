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

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_tz_name
                       complete_tz_offset
                       complete_tz
                );

our %SPEC;

# taken from Wikipedia page: https://en.wikipedia.org/wiki/UTC%2B14:00 on Feb 27, 2020
our @TZ_OFFSETS = qw(
    −12:00 −11:00 −10:30 −10:00 −09:30 −09:00 −08:30 −08:00 −07:00
    −06:00 −05:00 −04:30 −04:00 −03:30 −03:00 −02:30 −02:00 −01:00 −00:44 −00:25:21
    -00:00 +00:00 +00:20 +00:30 +01:00 +01:24 +01:30 +02:00 +02:30 +03:00 +03:30 +04:00 +04:30 +04:51 +05:00 +05:30 +05:40 +05:45
    +06:00 +06:30 +07:00 +07:20 +07:30 +08:00 +08:30 +08:45 +09:00 +09:30 +09:45 +10:00 +10:30 +11:00 +11:30
    +12:00 +12:45 +13:00 +13:45 +14:00
);

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
        array => \@TZ_OFFSETS,
    );
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO
