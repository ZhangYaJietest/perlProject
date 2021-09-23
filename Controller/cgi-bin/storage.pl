#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use strict;
use warnings;
use HTML::Template;
use DBI;
use Pg;
use STORAGE;
my $inputstring=$ENV{QUERY_STRING};
my $template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/storage.tmpl");
my $o_storage = STORAGE->new;
$o_storage->conn;
my $hr_data = $o_storage->select("storage");
if(defined($inputstring)){
    (my $key, my $value) = split(/=/, $inputstring);
    if(defined($value)){
        # $template->param(STORAGE => $value);
        $template->param(BOOL => 1);
        my @loop_data = ();
        while((my $key1,my $value1)=each(%$hr_data)){
            my %row_data;
            if($value1->{'name'} eq $value){
                while((my $key2,my $value2)=each(%$value1)){
                    if($key2 eq 'create_time'){
                        my @a_CreateTime= split('\.',$value2);
                        $value2  = $a_CreateTime[0];
                    }
                    $row_data{$key2}   = $value2;
            }
                push(@loop_data, \%row_data);
            }
        }
            $template->param(STORAGE_INFO => \@loop_data);
    }else{
        $template->param(HOME => "HOSTNAME*");
        $template->param(CAPACITY => "CAPACITY*");
        $template->param(BOOL => 0);
        my @loop_data = ();
        foreach my $key1(sort { $a <=> $b } keys %$hr_data){
            my %row_data;
            my $value1 = %$hr_data{$key1};
            while((my $key2,my $value2)=each(%$value1)){
                if($key2 eq 'create_time'){
                    my @a_CreateTime= split('\.',$value2);
                    $value2  = $a_CreateTime[0];
                }
                $row_data{$key2}   = $value2;
            }
            push(@loop_data, \%row_data);
        }
        $template->param(STORAGE_INFO => \@loop_data);
        }
}
print "Content-Type: text/html\n\n", $template->output;

