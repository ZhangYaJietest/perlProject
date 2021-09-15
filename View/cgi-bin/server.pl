#!C:/Strawberry/perl/bin/perl.exe
use lib "C:/Users/142587/PycharmProjects/perlProject/Controller/";
use strict;
use warnings;
use HTML::Template;
use DBI;
use Pg;

my $o_DB = Pg->new;
$o_DB->conn;


# open the html template
my $template = HTML::Template->new(filename=>"C:/Users/142587/PycharmProjects/perlProject/View/templates/server.tmpl");

# fill in some parameters
$template->param(HOME => "HOSTNAME*");
#storage
my $hr_data = $o_DB->select("storage");
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

my $hr_data = $o_DB->Condition_query(\@a_param);
my @loop_data = ();
while((my $key1,my $value1)=each(%$hr_data)){
    my %row_data;
    while((my $key2,my $value2)=each(%$value1)){
        # print "$key2  $value2 \n";
        $row_data{$key2}   = $value2;
    }
    push(@loop_data, \%row_data);
}
$template->param(SERVER_INFO => \@loop_data);

# send the obligatory Content-Type and print the template output
print "Content-Type: text/html\n\n", $template->output;
