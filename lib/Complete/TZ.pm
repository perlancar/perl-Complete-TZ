package Complete::TZ;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
#use Log::Any '$log';

use Complete;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_tz
                );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Timezone-related completion routines',
};

$SPEC{complete_tz} = {
    v => 1.1,
    summary => 'Complete from list of timezone names',
    args => {
        word => { schema=>'str' },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_tz {
    require Complete::Util;

    my %args  = @_;
    my $word  = $args{word} // "";

    Complete::Util::complete_file(
        starting_path => '/usr/share/zoneinfo',
        handle_tilde => 0,
        allow_dot => 0,
        filter => sub {
            return 0 if $_[0] =~ /\.tab$/;
            1;
        },

        word => $word,
    );
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

