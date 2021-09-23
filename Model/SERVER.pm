package SERVER;
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
sub setServer{
    my $self = shift;
    print "\$self is a class ", ref($self)," reference.\n";
    $self->{"Owner"} = shift;
    $self->{"field"} = shift;
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
sub insert {
    my $self = shift;
    my $dbh = $self->{"DB"};
    #$_[0]:tablename $_[1]:\{name:,capacity:}
    my $s_tname = $_[0];
    my $hr_field = $_[1];
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
    #Determine whether naming is available
    if ($s_tname eq 'server'){
        return 8 ,if ($hr_field->{name} !~ /^(vm)/);
        my $o_storage = STORAGE->new;
        $o_storage->conn;
        #get capacity
        my @a_row = $o_storage->selectBYid($hr_field->{storage});
        if ($a_row[1]+10 > $a_row[0]){
            return 10;
        }
        #update capacity
        my $i_res = $o_storage->update_storage_capacity($hr_field->{storage});
        if ($i_res ne 1){
            return $i_res;
        }
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


1;