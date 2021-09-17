#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use HTML::Template;
use DBI;
use Pg;

my $o_DB = Pg->new;
$o_DB->conn;
my $inputstring=$ENV{QUERY_STRING};
# my $inputstring="id=9";
(my $key, my $value) = split(/=/, $inputstring);
# print "$key  $value";
my $hr_data = $o_DB->select("storage");
my $template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/update.tmpl");
#update server
if ($key eq 'name'){

    $template->param(HOME => "HOSTNAME*");
    $template->param(HOSTNAME => $value);
    #storage
    my @loop_data = ();
    while((my $key1,my $value1)=each(%$hr_data)){
        my %row_data;
        while((my $key2,my $value2)=each(%$value1)){
            # print "$key2  $value2 \n";
            if ($key2 eq 'id' or $key2 eq 'name'){
                $row_data{$key2}   = $value2;
            }
        }
        push(@loop_data, \%row_data);
    }
    $template->param(BOOL => 1);
    $template->param(STORAGE_INFO => \@loop_data);

    $template->param(STORAGENAME => "STORAGE*");
    #OPERATIN_SYATEM
    $template->param(OPERATIN_SYATEM => "OS*");

    my $hr_data = $o_DB->select("operation");
    my @loop_data = ();
    while((my $key1,my $value1)=each(%$hr_data)){
        my %row_data;
        while((my $key2,my $value2)=each(%$value1)){
            # print "$key2  $value2 \n";
            if ($key2 eq 'id' or $key2 eq 'name'){
                $row_data{$key2}   = $value2;
            }
        }
        push(@loop_data, \%row_data);
    }
    $template->param(OPERATION_INFO => \@loop_data);
}else{
    #update storage
    $template->param(BOOL => 0);
    $template->param(STORAGENAME => "STORAGE*");
    $template->param(CAPACITY => "CAPACITY*");
    while((my $key1,my $value1)=each(%$hr_data)){
        if($value1->{'id'} eq $value){
            $template->param(STORAGEINFO =>$value1->{'name'} );
            $template->param(CAPACITYINFO =>$value1->{'capacity'} );
        }
    }

}
print "Content-Type: text/html\n\n", $template->output;
