package Model;
use strict;
use warnings FATAL => 'all';
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}
sub createSERVER {
    my $self = shift;
    my $sql_server = qq(CREATE TABLE if not exists SERVER(name varchar (4) primary key,
               operating_system int NOT NULL,
               storage int NOT NULL,
               checksum varchar (10) NOT NULL,
               create_time timestamp default clock_timestamp ()
               ););
    return $sql_server;
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



sub createOPERATION {
    my $self = shift;
    my $sql_operation = qq(CREATE TABLE if not exists OPERATION(
                       id SERIAL,
                       name varchar (4) not NULL,
                       capacity varchar (10) NOT NULL,
                       create_time timestamp default clock_timestamp (),
                       primary key(id)
                       ););
    return $sql_operation;
}

1;