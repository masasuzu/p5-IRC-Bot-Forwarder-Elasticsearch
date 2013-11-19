# NAME

IRC::Bot::Forwarder::Elasticsearch - fowarder from IRC to Elasticsearch.

# SYNOPSIS

    use IRC::Bot::Forwarder::Elasticsearch;

    IRC::Bot::Forwarder::Elasticsearch->new(
        irc_host            => 'localhost',
        elasticsearch_nodes => ['localhost:9200'],
        channels            => ['#test'],
        nickname            => 'logger',
    );

# DESCRIPTION

IRC::Bot::Forwarder::Elasticsearch is fowarder from IRC to Elasticsearch.

# LICENSE

Copyright (C) SUZUKI Masashi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

SUZUKI Masashi <m15.suzuki.masashi@gmail.com>
