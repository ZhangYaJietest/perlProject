#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use strict;
use warnings;
use HTML::Template;
use STORAGE;
my $s_inputstring=$ENV{QUERY_STRING};
my $o_template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/storage.tmpl");
my $o_storage = STORAGE->new;
$o_storage->create_conn;
my $hr_data = $o_storage->select("storage");
if(defined($s_inputstring)){
    (my $s_key, my $s_value) = split(/=/, $s_inputstring);
    if(defined($s_value)){
        # $o_template->param(STORAGE => $s_value);
        $o_template->param(BOOL => 1);
        my @a_loop_data = ();
        while((my $s_key1,my $s_value1)=each(%$hr_data)){
            my %row_data;
            if($s_value1->{'name'} eq $s_value){
                while((my $s_key2,my $s_value2)=each(%$s_value1)){
                    if($s_key2 eq 'create_time'){
                        my @a_CreateTime= split('\.',$s_value2);
                        $s_value2  = $a_CreateTime[0];
                    }
                    $row_data{$s_key2}   = $s_value2;
            }
                push(@a_loop_data, \%row_data);
            }
        }
            $o_template->param(STORAGE_INFO => \@a_loop_data);
    }else{
        $o_template->param(HOME => "HOSTNAME*");
        $o_template->param(CAPACITY => "CAPACITY*");
        $o_template->param(BOOL => 0);
        my @a_loop_data = ();
        foreach my $s_key1(sort { $a <=> $b } keys %$hr_data){
            my %row_data;
            my $s_value1 = %$hr_data{$s_key1};
            while((my $s_key2,my $s_value2)=each(%$s_value1)){
                if($s_key2 eq 'create_time'){
                    my @a_CreateTime= split('\.',$s_value2);
                    $s_value2  = $a_CreateTime[0];
                }
                $row_data{$s_key2}   = $s_value2;
            }
            push(@a_loop_data, \%row_data);
        }
        $o_template->param(STORAGE_INFO => \@a_loop_data);
        }
}
print "Content-Type: text/html\n\n", $o_template->output;

