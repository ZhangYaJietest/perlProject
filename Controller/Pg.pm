package Pg;
use strict;
use warnings FATAL => 'all';
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use DBI;
use Judge;
use Variable::DBSql;
use SERVER;
use STORAGE;
use OPERATION;
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}

#Connect to database
sub conn {
    my $self = shift;
    my $driver = "Pg";
    my $database = "perldatabase";
    my $dsn = "DBI:$driver:dbname=$database;host=127.0.0.1;port=5432";
    my $userid = "postgres";
    my $password = "123456";
    my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
        or die $DBI::errstr;
    $self->{"DB"} = $dbh;

}

#create table
sub create {
    my $self = shift;
    my $dbh = $self->{"DB"};
    my $o_model= SERVER->new;
    my $o_storage = STORAGE->new;
    my $o_operation = OPERATION->new;

    my $s_sql_server = $o_model->createSERVER;
    $dbh->prepare( $s_sql_server)->execute() or die $DBI::errstr;


    my $s_sql_storage = $o_storage->createSTORAGE;
    $dbh->prepare( $s_sql_storage)->execute() or die $DBI::errstr;


    my $s_sql_operation = $o_operation->createOPERATION;
    $dbh->prepare( $s_sql_operation )->execute() or die $DBI::errstr;

}
sub select {
    my $self = shift;

    my $dbh = $self->{"DB"};
    my $tablename = shift;

    my $sql = "SELECT * from ".$tablename;

    my $sth = $dbh->prepare( $sql );
    $sth->execute() or die $DBI::errstr;
    #Get table fields
    my $o_jr = Judge->new;
    my @a_field = $o_jr->get_field($tablename);

    my %h_tabledata = ();
    my $i_len = @a_field;
    #deal data
    my $i_count =1;
    while(my @row = $sth->fetchrow_array()) {
        my @a_data_single = ();
        my %h_data_single = ();
        for(my $len=0;$len<$i_len;$len++){
            $h_data_single{$a_field[$len]} = $row[$len];
        }
        $h_tabledata{$i_count++} = \%h_data_single;
    }
    $self->{"data"} = \%h_tabledata;
    return \%h_tabledata;
}

sub Condition_query{
    my $self = shift;
    my $dbh = $self->{"DB"};
    my $ar_param = shift;
    my $tablename = $$ar_param[0];
    my $s_sql = "";

    my $o_DBsql = DBSql->new;
    if ($$ar_param[1] eq ''){
        $s_sql = $o_DBsql->Condition_query_sql($$ar_param[1]);
    }else{
        my $s_namevalue = $dbh->quote($$ar_param[1]);
        $s_sql = $o_DBsql->Condition_query_sql($s_namevalue);
    }
    my $sth = $dbh->prepare( $s_sql );
    $sth->execute() or die $DBI::errstr;
    #Get table fields
    my $o_jr = Judge->new;
    my @a_field = $o_jr->get_field($tablename);
    #
    my %h_tabledata = ();
    my $i_len = @a_field;
    #deal data
    my $i_count =1;
    while(my @row = $sth->fetchrow_array()) {
        my @a_data_single = ();
        my %h_data_single = ();
        for(my $len=0;$len<$i_len;$len++){
            $h_data_single{$a_field[$len]} = $row[$len];
        }
        $h_tabledata{$i_count++} = \%h_data_single;
    }
    $self->{"con_data"} = \%h_tabledata;
    return \%h_tabledata;
}

#tablename, field{}, where
sub update {
    my $self = shift;
    my $hr_field = $_[1];
    my $dbh = $self->{"DB"};
    my $o_DBsql = DBSql->new;
    #deal Quotation marks
    while((my $key,my $value)=each(%$hr_field)){
        $$hr_field{$key} = ($dbh->quote($$hr_field{$key}));
    }
    my $a_upwhere = $_[2];
    $$a_upwhere[1] = $dbh->quote($$a_upwhere[1]);
    #get sql
    my $s_updateSql = $o_DBsql->update_sql($_[0],$hr_field,$a_upwhere);
    #exec sql
    my $sth = $dbh->prepare( $s_updateSql );
    my $i_execResult = $sth->execute() or die $DBI::errstr;

    if ($i_execResult <= 0){
        return 0;
    }else{
        return 1;
    }

}

sub delete {
    my $self = shift;
    my $dbh = $self->{"DB"};
    #get detele sql
    my $o_DBsql = DBSql->new;
    my $s_deleteSql = $o_DBsql->delete_sql($_[0],$_[1],$dbh->quote($_[2]));
    #exec sql
    my $sth = $dbh->prepare( $s_deleteSql );
    my $i_execResult = $sth->execute() or die $DBI::errstr;
    #Determine whether the execution is successful
    if ($i_execResult <= 0){
        return 0;
    }else{
        return 1;
    }

}

sub insert {
    my $self = shift;
    my $dbh = $self->{"DB"};
    #$_[0]:tablename $_[1]:\{name:,capacity:}
    my $tname = $_[0];
    my $hr_field = $_[1];
    my $o_jr = Judge->new;
    my $name = qq($hr_field->{name});
    #Judgment repetition
    my $i_rep = 1;
    if (defined $tname){
        $i_rep = $o_jr->jrepeat($tname,$name);
        if ($i_rep == 0){
            # print "Data duplication";
            return 0;
        }
    }else{
        return 0;
    }
    #deal Quotation marks
    while((my $key,my $value)=each(%$hr_field)){

        $$hr_field{$key} = ($dbh->quote($$hr_field{$key}));

    }
    #get sql
    my $o_DBsql = DBSql->new;
    my $s_insertsql = $o_DBsql->insert_sql($tname,$hr_field);
    #exec sql
    my $sth = $dbh->prepare( $s_insertsql );
    my $i_execResult = $sth->execute() or die $DBI::errstr;

    if ($i_execResult <= 0){
        return 0;
    }else{
        return 1;
    }
}

sub display{
    my $self = shift;
    my $s_data = $self->{"con_data"};
    while((my $key1,my $value1)=each(%$s_data)){
        #The default is the name key
        while((my $key2,my $value2)=each(%$value1)){
            print "$key2  $value2   ";
        }
        print "\n";
    }

}

1;