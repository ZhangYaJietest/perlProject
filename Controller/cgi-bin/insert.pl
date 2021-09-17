#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use lib "C:/Users/142587/PycharmProjects/perlProject/Controller/";
use strict;
use warnings;
use ReturnParams;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use HTML::Template;
use DBI;
use Pg;
use POSIX qw(strftime);
my $s_inputstring=$ENV{QUERY_STRING};

# my $s_inputstring = "name=sto1&capacity=100";
my @s_key_value=split(/&/,$s_inputstring);
my %h_input = ();
my $s_tname = "server";
foreach my $pair ( @s_key_value){
    (my $key, my $s_value) = split(/=/, $pair);
    $s_value=~ s/%(..)/pack("C", hex($1))/ge;
    $s_value =~ s/\n/ /g;
    $s_value =~ s/\r//g;
    $s_value =~ s/\cM//g;
    $h_input{$key} = $s_value ; # Creating a hash
 }
my $i_len = keys %h_input;
if ($i_len == 3){
    $h_input{'checksum'} = md5_hex($s_inputstring);
}else{
    $s_tname = "storage";
}
my $s_date = strftime "%Y-%m-%d %H:%M:%S", localtime;
$h_input{'update_time'} =$s_date;
#insert data

my $DB = Pg->new;
$DB->conn;
my $i_res = $DB->insert($s_tname,\%h_input);
my $template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/curd.tmpl");
if ($i_res eq 1){
    $template->param(RESULT => "Insert successful");
}else{
    $template->param(RESULT => "Insert fail");
}
my $params = ReturnParams->new;
my $s_result = $params->Params->{$i_res};
$template->param(RESULT => $s_result);

print "Content-Type: text/html\n\n", $template->output;