#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
use lib "C:/Users/142587/PycharmProjects/perlProject/Controller/";
use strict;
use warnings;
use ReturnParams;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use HTML::Template;
use SERVER;
use STORAGE;
my $s_inputstring=$ENV{QUERY_STRING};
# my $s_inputstring= "id=4";
my $s_tname = 'server';
my ($s_key,$s_value) = split(/=/, $s_inputstring);
#delete data
my $i_res = 1;
if ($s_key eq 'id'){
    $s_tname = 'storage';
    my $o_storage = STORAGE->new;
    $o_storage->create_conn;
    $i_res = $o_storage->delete($s_tname,$s_key,$s_value);
}else{
    my $o_server = SERVER->new;
    $o_server->create_conn;
    $i_res = $o_server->delete($s_tname,$s_key,$s_value);
}

my $o_template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/curd.tmpl");
# if ($i_res eq 1){
#     $o_template->param(RESULT => "Delete successful");
# }else{
#     $o_template->param(RESULT => "Delete fail");
# }
my $o_params = ReturnParams->new;
my $s_result = $o_params->Params->{$i_res};
$o_template->param(RESULT => $s_result);
print "Content-Type: text/html\n\n", $o_template->output;
