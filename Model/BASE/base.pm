package base;
use strict;
use warnings FATAL => 'all';
use Pg;

sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}

sub create_conn{
    my $self = shift;
    my $o_DB = Pg->new;
    $self->{"DB"} = $o_DB->conn;
    return $o_DB->conn;;
}
sub create{
    my $self = shift;
    my $o_DB = Pg->new;
    $o_DB->conn;
    my $s_sql = $_[0];
    $o_DB->create($s_sql);
}

sub select{
    my $self = shift;
    my $o_DB = Pg->new;
    $o_DB->conn;
    my $s_table_name = $_[0];
    my $hr_data = $o_DB->select($s_table_name);
    $self->{"data"} = $hr_data;
    return $hr_data;
}

sub update{
    my $self = shift;
    my $o_DB = Pg->new;
    $o_DB->conn;
    my $i_result = $o_DB->update($_[0],$_[1],$_[2]);
    return $i_result;
}

sub delete{
    my $self = shift;
    my $o_DB = Pg->new;
    $o_DB->conn;
    my $i_result = $o_DB->delete($_[0],$_[1],$_[2]);
    return $i_result;
}


sub display{
    my $self = shift;
    my $s_data = $self->{"data"};
    foreach my $key1(sort {lc($a) cmp lc($b)}  keys %$s_data){
        my $value1 = %$s_data{$key1};
        print $key1;
        #The default is the name key
        while((my $key2,my $value2)=each(%$value1)){
            print "$key2  $value2   ";
        }
        print "\n";
    }

}




1;