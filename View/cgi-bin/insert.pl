#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Controller/";
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use HTML::Template;
use DBI;
use Pg;
my $inputstring=$ENV{QUERY_STRING};

# my $inputstring = "name=vm2&storage=6&operating_system=2";
my @key_value=split(/&/,$inputstring);
my %input = ();
my $tname = "server";
foreach my $pair ( @key_value){
    (my $key, my $value) = split(/=/, $pair);
    $value=~ s/%(..)/pack("C", hex($1))/ge;
    $value =~ s/\n/ /g;
    $value =~ s/\r//g;
    $value =~ s/\cM//g;
    $input{$key} = $value ; # Creating a hash
 }
$input{'checksum'} = md5_hex();
#insert data

my $DB = Pg->new;
$DB->conn;
my $i_res = $DB->insert($tname,\%input);
my $template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/curd.tmpl");
if ($i_res eq 1){
    $template->param(RESULT => "Insert successful");
}else{
    $template->param(RESULT => "Insert fail");
}
print "Content-Type: text/html\n\n", $template->output;