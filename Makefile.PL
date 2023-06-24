use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Plack messages application.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Plack-App-Messages';
perl_version 5.008;
readme_from 'Messages.pm';
recursive_author_tests('xt');
requires 'Error::Pure' => 0;
requires 'Plack::Component::Tags::HTML' => 0.15;
requires 'Plack::Util::Accessor' => 0;
requires 'Plack::Session' => 0;
requires 'Scalar::Util' => 0;
requires 'Tags::HTML::Messages' => 0;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Plack-App-Messages/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/Plack-App-Messages';
resources 'repository' => 'git://github.com/michal-josef-spacek/Plack-App-Messages';
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
