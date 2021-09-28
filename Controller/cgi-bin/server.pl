#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use strict;
use warnings;
use HTML::Template;
use STORAGE;
use SERVER;


# open the html template
my $o_template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/server.tmpl");

# fill in some parameters
$o_template->param(HOME => "HOSTNAME*");
#storage
my $o_storage = STORAGE->new;
$o_storage->create_conn;
my $hr_data = $o_storage->select("storage");
my @a_loop_data = ();
while((my $s_key1,my $s_value1)=each(%$hr_data)){
    my %h_row_data;
    while((my $s_key2,my $s_value2)=each(%$s_value1)){
        if ($s_key2 eq 'id' or $s_key2 eq 'name'){
            $h_row_data{$s_key2}   = $s_value2;
        }
    }
    push(@a_loop_data, \%h_row_data);
}
$o_template->param(STORAGE_INFO => \@a_loop_data);

$o_template->param(STORAGENAME => "STORAGE*");
#OPERATIN_SYATEM
$o_template->param(OPERATIN_SYATEM => "OS*");

my $s_inputstring=$ENV{QUERY_STRING};
# my $s_inputstring= "name=vm1";
my $s_tname = 'server';
my @a_param = ($s_tname,"");
if (defined($s_inputstring)){
    (my $key, my $s_value) = split(/=/, $s_inputstring);
    if(defined($s_value)){
        @a_param = ($s_tname,$s_value);
    }
}

my $o_server = SERVER->new;
$o_server->create_conn;
my $hr_data = $o_server->Condition_query(\@a_param);
my @a_loop_data = ();
foreach my $s_key1(sort {lc($a) cmp lc($b)} keys %$hr_data){
    my %h_row_data;
    my $s_value1 = %$hr_data{$s_key1};
    foreach my $s_key2 (keys %$s_value1){
        if($s_key2 eq 'create_time'){
            my @a_CreateTime= split('\.',$$s_value1{$s_key2});
            $h_row_data{$s_key2}   = $a_CreateTime[0];
        }else{
            $h_row_data{$s_key2}   = $$s_value1{$s_key2};
        }
    }
    push(@a_loop_data, \%h_row_data);
}
$o_template->param(SERVER_INFO => \@a_loop_data);

# send the obligatory Content-Type and print the template output
print "Content-Type: text/html\n\n", $o_template->output;
