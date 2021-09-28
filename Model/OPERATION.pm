package OPERATION;
use strict;
use warnings FATAL => 'all';
use BASE::base;
our @ISA=qw (Exporter base);
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
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
    base::create_table($sql_operation);
}


1;