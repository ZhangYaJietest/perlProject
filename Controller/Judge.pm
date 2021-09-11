package Judge;
use strict;
use warnings FATAL => 'all';
use DBI;
use Pg;
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
    while((my $key1,my $value1)=each(%$hr_tabledata)){
        #The default is the name key
        while((my $key2,my $value2)=each(%$value1)){
            if($key2 eq 'name' and $value2 eq $field){
                return 0;
            }
        }
    }
    return 1;

    # my $sth = $DB->select($tablename);
    # while(my @row = $sth->fetchrow_array()) {
    #     print "ID = ". $row[0] . "\n";
    #     print "NAME = ". $row[1] ."\n";
    #     print "ADDRESS = ". $row[2] ."\n";
    # }

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
sub dealdata{

}
1;