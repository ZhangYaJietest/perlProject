#!/usr/bin/perl

use lib "C:/Users/142587/PycharmProjects/perlProject/Controller/";
use strict;
use warnings;
use DBI;
# use Operation;
use Pg;

# my $house = Operation->new; # Call class method
# $house->set_owner ("Tom Savage"); # Call instance method
# $house->display_owner;

my $DB = Pg->new;
$DB->conn;

my $tname = "server";
#operation_system linux 1  win 2 mac 3
my %field = qw{
               name vm3
               operating_system 4
               storage 5
               checksum 999999};
my @up = qw(name vm3);
#insert(tablename,field{})
$DB->create;
# $DB->insert($tname,\%field);

$DB->select($tname);
$DB->display;
# print($DB->update($tname,\%field,\@up));
# print($DB->delete($tname,"name","vm3"));

