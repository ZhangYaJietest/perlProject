package STORAGE;
use strict;
use warnings FATAL => 'all';
use Pg;
our @ISA=qw (Exporter Pg);
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}


sub update_storage_capacity{
    my $self = shift;
    my $dbh = $self->{"DB"};
    my $i_id = $_[0];
    $self->{id} = $i_id;

    my $o_storage = STORAGE->new;
    $o_storage->conn;
    #get sql
    my $o_DBsql = DBSql->new;
    my $s_updatesql = $o_DBsql->update_capacity($i_id);
    #exec sql
    my $sth = $dbh->prepare( $s_updatesql );
    my $i_execResult = $sth->execute() or die $DBI::errstr;
    if ($i_execResult <= 0){
        return 0;
    }else{
        return 1;
    }
}

sub selectBYid{
    my $self = shift;
    my $dbh = $self->{"DB"};
    my $o_DBsql = DBSql->new;
    my $s_selectsql = $o_DBsql->selectBYid_sql($_[0]);
    my $sth = $dbh->prepare( $s_selectsql );
    $sth->execute() or die $DBI::errstr;

    my @row = $sth->fetchrow_array();
    return @row;
}

sub selectBYname{
    my $self = shift;
    my $dbh = $self->{"DB"};
    my $o_DBsql = DBSql->new;
    my $s_name = $dbh->quote($_[0]);
    my $s_selectsql = $o_DBsql->selectBYname_sql($s_name);
    my $sth = $dbh->prepare( $s_selectsql );
    $sth->execute() or die $DBI::errstr;

    my @row = $sth->fetchrow_array();
    return @row;
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