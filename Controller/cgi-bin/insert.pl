#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use lib "C:/Users/142587/PycharmProjects/perlProject/Controller/";
use strict;
use warnings;
use ReturnParams;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use HTML::Template;
use POSIX qw(strftime);
use STORAGE;
use SERVER;
my $s_inputstring=$ENV{QUERY_STRING};

# my $s_inputstring = "name=sto1&capacity=100";
my @a_key_value=split(/&/,$s_inputstring);
my %h_input = ();
my $s_tname = "server";
foreach my $pair ( @a_key_value){
    (my $s_key, my $s_value) = split(/=/, $pair);
    $s_value=~ s/%(..)/pack("C", hex($1))/ge;
    $s_value =~ s/\n/ /g;
    $s_value =~ s/\r//g;
    $s_value =~ s/\cM//g;
    $h_input{$s_key} = $s_value ; # Creating a hash
 }
my $i_len = keys %h_input;
my $s_date = strftime "%Y-%m-%d %H:%M:%S", localtime;
$h_input{'update_time'} =$s_date;
#insert data
my $i_res = 1;
my $o_storage = STORAGE->new;
$o_storage->create_conn;
if ($i_len == 3){
    $h_input{'checksum'} = md5_hex($s_inputstring);
    my $o_server = SERVER->new;
    $o_server->create_conn;
    $i_res = $o_server->insert($s_tname,\%h_input);
}else{
    $s_tname = "storage";
    $i_res = $o_storage->insert($s_tname,\%h_input);
}


my $o_template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/curd.tmpl");
my $o_params = ReturnParams->new;
my $s_result = $o_params->Params->{$i_res};
$o_template->param(RESULT => $s_result);

print "Content-Type: text/html\n\n", $o_template->output;