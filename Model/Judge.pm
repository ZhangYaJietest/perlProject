package Judge;
use strict;
use warnings FATAL => 'all';
use DBI;
use Pg;
use STORAGE;
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}

#0：tablename variable 1：Field variable
sub jrepeat{
    my $self = shift;
    my $tablename = $_[0];
    my $field = $_[1];
    my $DB = Pg->new;
    $DB->conn;
    my $hr_tabledata = $DB->select($tablename);
    my $i_count = 0;
    while((my $key1,my $value1)=each(%$hr_tabledata)){
        #The default is the name key
        while((my $key2,my $value2)=each(%$value1)){
            if($key2 eq 'name' and $value2 eq $field){
                return 0;
            }
        }
    }
    return 1;
}

sub get_field{
    my $self = shift;
    my $DB = Pg->new;
    my $dbh = $DB->conn;
    my $tablename = $_[0];

    my $s_dsql = DBSql->new;
    $tablename = $dbh->quote($tablename);
    my $s_field = $s_dsql->field_select($tablename);
    my $s_sth = $dbh->prepare( $s_field );
    $s_sth->execute() or die $DBI::errstr;
    my @a_field = ();
    while(my @row = $s_sth->fetchrow_array()) {
        push(@a_field,$row[1]);
    }
    return @a_field;

}
sub delete_storage_data{
    my $self = shift;
    my $ar_params = $_[0];
    my $DB = Pg->new;
    $DB->conn;
    my $hr_ServerData = $DB->select('server');
    while((my $key1,my $value1)=each(%$hr_ServerData)){
        my $i_storage = $value1->{'storage'};
        if($i_storage eq $$ar_params[2] ){
            return 2;
        }
    }
    return 1;
}


1;