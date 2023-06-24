#!/usr/bin/env perl

use strict;
use warnings;

use CSS::Struct::Output::Indent;
use Data::Message::Simple;
use Plack::App::Messages;
use Plack::Builder;
use Plack::Runner;
use Tags::Output::Indent;

# Run application.
my $app = Plack::App::Messages->new(
        'css' => CSS::Struct::Output::Indent->new,
        'messages' => [
                Data::Message::Simple->new(
                        'text' => 'Error message.',
                        'type' => 'error',
                ),
                Data::Message::Simple->new(
                        'text' => 'Info message.',
                        'type' => 'info',
                ),
        ],
        'tags' => Tags::Output::Indent->new(
                'preserved' => ['style'],
                'xml' => 1,
        ),
)->to_app;
my $builder = Plack::Builder->new;
$builder->add_middleware('Session');
$builder->mount('/' => $app);
Plack::Runner->new->run($builder->to_app);

# Output:
# HTTP::Server::PSGI: Accepting connections at http://0:5000/

# > curl http://localhost:5000/
# <!DOCTYPE html>
# <html lang="en">
#   <head>
#     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
#     <meta name="generator" content="Plack::App::Messages; Version: 0.01" />
#     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
#     <title>
#       Messages
#     </title>
#     <style type="text/css">
# * {
# 	box-sizing: border-box;
# 	margin: 0;
# 	padding: 0;
# }
# .error {
# 	color: red;
# }
# .info {
# 	color: blue;
# }
# </style>
#   </head>
#   <body>
#     <div class="messages">
#       <span class="error">
#         Error message.
#       </span>
#       <br />
#       <span class="info">
#         Info message.
#       </span>
#     </div>
#   </body>
# </html>