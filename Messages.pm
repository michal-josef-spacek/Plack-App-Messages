package Plack::App::Messages;

use base qw(Plack::Component::Tags::HTML);
use strict;
use warnings;

use Error::Pure qw(err);
use Plack::Util::Accessor qw(generator messages title);
use Plack::Session;
use Scalar::Util qw(blessed);
use Tags::HTML::Messages;

our $VERSION = 0.01;

sub _css {
	my ($self, $env) = @_;

	$self->{'_messages'}->process_css({
		'info' => 'blue',
		'error' => 'red',
	});

	return;
}

sub _prepare_app {
	my $self = shift;

	# Defaults which rewrite defaults in module which I am inheriting.
	if (! defined $self->generator) {
		$self->generator(__PACKAGE__.'; Version: '.$VERSION);
	}

	if (! defined $self->title) {
		$self->title('Messages');
	}

	# Inherite defaults.
	$self->SUPER::_prepare_app;

	# Defaults from this module.
	my %p = (
		'css' => $self->css,
		'tags' => $self->tags,
	);
	$self->{'_messages'} = Tags::HTML::Messages->new(%p);

	return;
}

sub _process_actions {
	my ($self, $env) = @_;

	if (defined $self->messages) {
		my $messages_ar = $self->messages;
		if (ref $messages_ar ne 'ARRAY') {
			err 'Messages must be a reference to array.';
		}
		foreach my $message (@{$messages_ar}) {
			if (! blessed($message) || ! $message->isa('Data::Message::Simple')) { 
				err "Message must be a 'Data::Message::Simple' instance.";
			}
		}
		if (! exists $env->{'psgix.session'}) {
			err "Session doesn't exist.";
		}
		my $session = Plack::Session->new($env);
		$session->set('messages', $messages_ar);
	}

	return;
}

sub _tags_middle {
	my ($self, $env) = @_;

	my $messages_ar = [];
	if (exists $env->{'psgix.session'}) {
		my $session = Plack::Session->new($env);
		$messages_ar = $session->get('messages');
		$session->set('messages', []);
	}
	$self->{'_messages'}->process($messages_ar);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Plack::App::Messages - Plack messages application.

=head1 SYNOPSIS

 use Plack::App::Messages;

 my $obj = Plack::App::Messages->new(%parameters);
 my $psgi_ar = $obj->call($env);
 my $app = $obj->to_app;

=head1 DESCRIPTION

Plack application which print messages from session. Session field is 'messages'
and contain reference to array with L<Data::Message::Simple> instances.
In case of no session, there is no processing of messages.

=head1 METHODS

=head2 C<new>

 my $obj = Plack::App::Messages->new(%parameters);

Constructor.

Returns instance of object.

=over 8

=item * C<css>

Instance of CSS::Struct::Output object.

Default value is CSS::Struct::Output::Raw instance.

=item * C<generator>

HTML generator string.

Default value is 'Plack::App::Login; Version: __VERSION__'.

=item * C<messages>

Set list of default messages to Plack session.
Each message must be a L<Data::Message::Simple> instance.

Default value is undef.

=item * C<tags>

Instance of Tags::Output object.

Default value is Tags::Output::Raw->new('xml' => 1) instance.

=item * C<title>

Page title.

Default value is 'Login page'.

=back

=head2 C<call>

 my $psgi_ar = $obj->call($env);

Implementation of login page.

Returns reference to array (PSGI structure).

=head2 C<to_app>

 my $app = $obj->to_app;

Creates Plack application.

Returns Plack::Component object.

=head1 ERRORS

 TODO

=head1 EXAMPLE

=for comment filename=messages_psgi.pl

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

=head1 DEPENDENCIES

L<Error::Pure>,
L<Plack::Component::Tags::HTML>,
L<Plack::Util::Accessor>,
L<Plack::Session>,
L<Scalar::Util>,
L<Tags::HTML::Messages>.

=head1 SEE ALSO

=over

=item L<Plack::App::Login>

Plack login application.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Plack-App-Register>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
