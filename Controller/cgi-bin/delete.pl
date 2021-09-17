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
my $s_inputstring=$ENV{QUERY_STRING};
# my $s_inputstring= "id=4";
my $s_tname = 'server';
my ($key,$value) = split(/=/, $s_inputstring);
if ($key eq 'id'){
    $s_tname = 'storage';
}
#delete data
my $o_DB = Pg->new;
$o_DB->conn;


my $i_res = $o_DB->delete($s_tname,$key,$value);

my $template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/curd.tmpl");
# if ($i_res eq 1){
#     $template->param(RESULT => "Delete successful");
# }else{
#     $template->param(RESULT => "Delete fail");
# }
my $params = ReturnParams->new;
my $s_result = $params->Params->{$i_res};
$template->param(RESULT => $s_result);
print "Content-Type: text/html\n\n", $template->output;
