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
# my $s_inputstring="name=vm40&storage=4&operating_system=4&wherename=vm4";
# my $s_inputstring = "wherename=sto3&name=sto3&capacity=300";
my @a_key_value=split(/&/,$s_inputstring);
my $i_len = @a_key_value;
my %h_input = ();
my @a_Where=();
foreach my $pair ( @a_key_value){
    (my $s_key, my $s_value) = split(/=/, $pair);
    $s_value =~ s/%(..)/pack("C", hex($1))/ge;
    $s_value =~ s/\n/ /g;
    $s_value =~ s/\r//g;
    $s_value =~ s/\cM//g;
    if ($s_key eq 'wherename'){
        $a_Where[0] = 'name';
        $a_Where[1] = $s_value;
    } else{
        $h_input{$s_key} = $s_value ; # Creating a hash
    }
 }
#get tablename
my $o_server = SERVER->new;
$o_server->create_conn;
my $s_tname = "storage";
if($i_len eq 4){
    $s_tname = "server";
    #get checksum
    my $hr_data = $o_server->select($s_tname);
    while((my $s_key1,my $s_value1)=each(%$hr_data)){
        if($s_value1->{'name'} eq $a_Where[1]){
            $h_input{'checksum'} = $s_value1->{'checksum'};

        }
    }
}
my $s_date = strftime "%Y-%m-%d %H:%M:%S", localtime;
$h_input{'update_time'} =$s_date;
#update data
my $i_res = 1;
if($i_len eq 4){
    $i_res = $o_server->update($s_tname,\%h_input,\@a_Where);
}else{
    my $o_storage = STORAGE->new;
    $o_storage->create_conn;
    my @a_row = $o_storage->selectBYname($a_Where[1]);
    if($a_row[1] > $h_input{'capacity'}){
        $i_res=11;
    }
    if ($i_res eq 1){
        $i_res = $o_storage->update($s_tname,\%h_input,\@a_Where);
    }
}

my $o_template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/curd.tmpl");
my $o_params = ReturnParams->new;
my $s_result = $o_params->Params->{$i_res};
$o_template->param(RESULT => $s_result);
print "Content-Type: text/html\n\n", $o_template->output;

