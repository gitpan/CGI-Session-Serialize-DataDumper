package CGI::Session::Serialize::DataDumper;

use strict;
use Safe;
use Data::Dumper;

use vars qw($VERSION);

($VERSION) = '$Revision: 1.5 $' =~ m/Revision:\s*(\S+)/;


sub freeze {
    my ($self, $data) = @_;
    
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Purity   = 0;
    local $Data::Dumper::Useqq    = 1;
    local $Data::Dumper::Deepcopy = 0;   
    
    my $d = new Data::Dumper([$data], ["D"]);
    return $d->Dump();    
}



sub thaw {
    my ($self, $string) = @_;    

    # To make -T happy
    my ($safe_string) = $string =~ m/^(.*)$/;
    
    my $D = undef;
    my $cpt = new Safe();
    $D = $cpt->reval ($safe_string );
    if ( $@ ) {
        die $@;
    }

    return $D;
}


1;

=pod

=head1 NAME

CGI::Session::Serialize::DataDumper - serializer for CGI::Session using Data::Dumper

=head1 DESCRIPTION

This library is used by CGI::Session driver to serialize session data before storing
it in disk. 

=head1 METHODS

=over 4

=item freeze()

receives two arguments. First is the CGI::Session driver object, the second is the data to be
stored passed as a reference to a hash. Should return true to indicate success, undef otherwise, 
passing the error message with as much details as possible to $self->error()

=item thaw()

receives two arguments. First being CGI::Session driver object, the second is the string
to be deserialized. Should return deserialized data structure to indicate successs. undef otherwise,
passing the error message with as much details as possible to $self->error().

=back

=head1 WARNING

If you want to be able to store objects, consider using L<CGI::Session::Serialize::Storable> or
L<CGI::Session::Serialize::FreezeThaw> instead.

=head1 COPYRIGHT

Copyright (C) 2002 Sherzod Ruzmetov. All rights reserved.

This library is free software. It can be distributed under the same terms as Perl itself. 

=head1 AUTHOR

Sherzod Ruzmetov <sherzodr@cpan.org>

All bug reports should be directed to Sherzod Ruzmetov <sherzodr@cpan.org>. 

=head1 MAINTAINER

Jonathan Buhacoff <jonathan@buhacoff.net>

Sherzod wrote the module, I just wanted to be able to call it DataDumper so that when I glance
at code I don't have to remember that "Default" (CGI::Session::Serialize::Default) uses Data::Dumper. 

If you encounter a bug, try using "Default" instead of "DataDumper". If the bug goes away, then
it's mine, and you should send the report to me.  If it persists, it's Sherzod's, and you should
send the report to him. You can CC me if you want me to help as well, because I'm a big fan of 
Sherzod's CGI::Session and I use it all the time, so I'm very interested in bugfixes etc. 

=head1 SEE ALSO

=over 4

=item *

L<CGI::Session|CGI::Session> - CGI::Session manual

=item *

L<CGI::Session::Tutorial|CGI::Session::Tutorial> - extended CGI::Session manual

=item *

L<CGI::Session::CookBook|CGI::Session::CookBook> - practical solutions for real life problems

=item *

B<RFC 2965> - "HTTP State Management Mechanism" found at ftp://ftp.isi.edu/in-notes/rfc2965.txt

=item *

L<CGI|CGI> - standard CGI library

=item *

L<Apache::Session|Apache::Session> - another fine alternative to CGI::Session

=back

=cut

