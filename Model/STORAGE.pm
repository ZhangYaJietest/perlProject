package STORAGE;
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


sub update_storage_capacity{
    my $self = shift;
    my $dbh = $self->{"DB"};
    my $i_id = $_[0];
    $self->{id} = $i_id;

    my $o_storage = STORAGE->new;
    $o_storage->create_conn;
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

sub insert {
    my $self = shift;
    my $dbh = $self->{"DB"};
    #$_[0]:tablename $_[1]:\{name:,capacity:}
    my $s_tname = $_[0];
    my $hr_field = $_[1];
    #Determine whether naming is available
    if ($s_tname eq 'server'){
        return 8 ,if ($hr_field->{name} !~ /^(vm)/);
    }else{
        return 9 ,if ($hr_field->{name} !~ /^(sto)/);
    }
    my $o_jr = Judge->new;
    my $s_name = qq($hr_field->{name});
    #Judgment repetition
    my $i_rep = 1;
    if (defined $s_tname){
        $i_rep = $o_jr->jrepeat($s_tname,$s_name);
        if ($i_rep == 0){
            # print "Data duplication";
            return 4;
        }
    }else{
        return 5;
    }
    #deal Quotation marks
    while((my $key,my $value)=each(%$hr_field)){

        $$hr_field{$key} = ($dbh->quote($$hr_field{$key}));

    }
    #get sql
    my $o_DBsql = DBSql->new;
    my $s_insertsql = $o_DBsql->insert_sql($s_tname,$hr_field);
    #exec sql
    my $sth = $dbh->prepare( $s_insertsql );
    my $i_execResult = $sth->execute() or die $DBI::errstr;

    if ($i_execResult <= 0){
        return 0;
    }else{
        return 6;
    }
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

    base::create_table($sql_storage);
}


1;