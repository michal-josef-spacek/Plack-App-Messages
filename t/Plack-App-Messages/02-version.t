use strict;
use warnings;

use Plack::App::Messages;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Plack::App::Messages::VERSION, 0.01, 'Version.');
