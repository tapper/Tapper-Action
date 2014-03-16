package Tapper::Action::Daemon;

use 5.010;

use strict;
use warnings;

use Tapper::Action;
use Moose;
use Tapper::Config;
use Log::Log4perl;

with 'MooseX::Daemonize';

after start => sub {
                    my $self = shift;

                    return unless $self->is_daemon;

                    my $logconf = Tapper::Config->subconfig->{files}{log4perl_cfg};
                    Log::Log4perl->init($logconf);

                    my $daemon = Tapper::Action->new()->loop;
                    say STDERR "Here I am";
            };


=head2 run

Frontend to subcommands: start, status, restart, stop.

=cut

sub run
{
        my $self = shift;

        my ($command) = @ARGV ? @ARGV : @_;
        return unless $command && grep /^$command$/, qw(start status restart stop);
        $self->$command;
        say $self->status_message;
}
;


1;
