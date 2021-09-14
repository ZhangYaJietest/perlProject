package STORAGE;
use strict;
use warnings FATAL => 'all';
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}

sub createSTORAGE {
    my $self = shift;
     my $sql_storage = qq(CREATE TABLE if not exists STORAGE(
               id SERIAL,
               name varchar (4) not NULL,
               capacity varchar (10) NOT NULL,
               create_time timestamp default clock_timestamp (),
               primary key(id)
               ););
    return $sql_storage;
}


1;