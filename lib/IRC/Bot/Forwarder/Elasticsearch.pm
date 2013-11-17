package IRC::Bot::Forwarder::Elasticsearch;
use 5.008005;
use strict;
use warnings;
use AnySan;
use AnySan::Provider::IRC;
use Encode;
use Elasticsearch;
use POSIX qw();
use Moo;

our $VERSION = "0.01";

has 'irc_host' => (
    is      => 'ro',
    default => sub { 'localhost' },
);

has 'elasticsearch_nodes' => (
    is      => 'ro',
    default => sub { ['localhost:9200'] },
);

has 'nickname' => (
    is      => 'ro',
    default => sub { 'flogger' },
);

has 'time_format' => (
    is      => 'ro',
    default =>  '%Y/%m/%d %H:%M:%S %z'
);

has 'channels' => (
    is      => 'ro',
);

sub BUILD {
    my ($self) = @_;

    my $irc = irc(
        $self->irc_host,
        nickname        => $self->nickname,
        recive_commands => [ 'PRIVMSG', 'NOTICE' ],
        channels        => +{
            map { $_ => +{} } @{ $self->channels },
        }
    );
    my $e = Elasticsearch->new(nodes => $self->elasticsearch_nodes);

    AnySan->register_listener( elastic_forward => {
        cb => sub {
            my ($receive) = @_;
            (my $channel = $receive->attribute->{channel}) =~ s/#//;
            $e->index(
                index => 'irc',
                type => $channel,
                body => +{
                    time     => POSIX::strftime($self->time_format, localtime),
                    message  => decode_utf8($receive->message),
                    event    => $receive->event,
                    nickname => $receive->from_nickname,
                }
            );
        }
    });
}

sub run {
    AnySan->run;
}


777;

__END__

=encoding utf-8

=head1 NAME

IRC::Bot::Forwarder::Elasticsearch - It's new $module

=head1 SYNOPSIS

    use IRC::Bot::Forwarder::Elasticsearch;

=head1 DESCRIPTION

IRC::Bot::Forwarder::Elasticsearch is ...

=head1 LICENSE

Copyright (C) SUZUKI Masashi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

SUZUKI Masashi E<lt>m15.suzuki.masashi@gmail.comE<gt>

=cut

