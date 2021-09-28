#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use HTML::Template;
use STORAGE;
use OPERATION;

my $s_inputstring=$ENV{QUERY_STRING};
# my $s_inputstring="id=9";
(my $s_key, my $s_value) = split(/=/, $s_inputstring);
# print "$s_key  $s_value";
my $o_storage = STORAGE->new;
$o_storage->create_conn;
my $hr_data = $o_storage->select("storage");
my $o_template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/update.tmpl");
#update server
if ($s_key eq 'name'){

    $o_template->param(HOME => "HOSTNAME*");
    $o_template->param(HOSTNAME => $s_value);
    #storage
    my @a_loop_data = ();
    while((my $s_key1,my $s_value1)=each(%$hr_data)){
        my %row_data;
        while((my $s_key2,my $s_value2)=each(%$s_value1)){
            # print "$s_key2  $s_value2 \n";
            if ($s_key2 eq 'id' or $s_key2 eq 'name'){
                $row_data{$s_key2}   = $s_value2;
            }
        }
        push(@a_loop_data, \%row_data);
    }
    $o_template->param(BOOL => 1);
    $o_template->param(STORAGE_INFO => \@a_loop_data);

    $o_template->param(STORAGENAME => "STORAGE*");
    #OPERATIN_SYATEM
    $o_template->param(OPERATIN_SYATEM => "OS*");

    my $o_operation = OPERATION->new;
    $o_operation->create_conn;
    my $hr_data = $o_operation->select("operation");
    my @a_loop_data = ();
    while((my $s_key1,my $s_value1)=each(%$hr_data)){
        my %row_data;
        while((my $s_key2,my $s_value2)=each(%$s_value1)){
            # print "$s_key2  $s_value2 \n";
            if ($s_key2 eq 'id' or $s_key2 eq 'name'){
                $row_data{$s_key2}   = $s_value2;
            }
        }
        push(@a_loop_data, \%row_data);
    }
    $o_template->param(OPERATION_INFO => \@a_loop_data);
}else{
    #update storage
    $o_template->param(BOOL => 0);
    $o_template->param(STORAGENAME => "STORAGE*");
    $o_template->param(CAPACITY => "CAPACITY*");
    while((my $s_key1,my $s_value1)=each(%$hr_data)){
        if($s_value1->{'id'} eq $s_value){
            $o_template->param(STORAGEINFO =>$s_value1->{'name'} );
            $o_template->param(CAPACITYINFO =>$s_value1->{'capacity'} );
        }
    }

}
print "Content-Type: text/html\n\n", $o_template->output;
