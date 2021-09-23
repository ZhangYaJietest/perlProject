#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use strict;
use warnings;
use HTML::Template;
use STORAGE;
use SERVER;


# open the html template
my $template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/server.tmpl");

# fill in some parameters
$template->param(HOME => "HOSTNAME*");
#storage
my $o_storage = STORAGE->new;
$o_storage->conn;
my $hr_data = $o_storage->select("storage");
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
$template->param(STORAGE_INFO => \@loop_data);

$template->param(STORAGENAME => "STORAGE*");
#OPERATIN_SYATEM
$template->param(OPERATIN_SYATEM => "OS*");

my $inputstring=$ENV{QUERY_STRING};
# my $inputstring= "name=vm1";
my $s_tname = 'server';
my @a_param = ($s_tname,"");
if (defined($inputstring)){
    (my $key, my $value) = split(/=/, $inputstring);
    if(defined($value)){
        @a_param = ($s_tname,$value);
    }
}

my $o_server = SERVER->new;
$o_server->conn;
my $hr_data = $o_server->Condition_query(\@a_param);
my @loop_data = ();
foreach my $key1(sort {lc($a) cmp lc($b)} keys %$hr_data){
    my %row_data;
    my $value1 = %$hr_data{$key1};
    foreach my $key2 (keys %$value1){
        if($key2 eq 'create_time'){
            my @a_CreateTime= split('\.',$$value1{$key2});
            $row_data{$key2}   = $a_CreateTime[0];
        }else{
            $row_data{$key2}   = $$value1{$key2};
        }
    }
    push(@loop_data, \%row_data);
}
$template->param(SERVER_INFO => \@loop_data);

# send the obligatory Content-Type and print the template output
print "Content-Type: text/html\n\n", $template->output;
