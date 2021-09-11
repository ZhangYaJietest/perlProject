use DBI;
use CGI qw(:standard);
print header, start_html(-title=>"Team Lookup",
    -BGCOLOR=>"#66ff33"
);
print start_form,"<font face='arial' size='+1'>
 Look up what team? ",textfield('name'),p;
print submit, end_form, hr;
if(param()) {
    $team = param('name');
    my $dbh = DBI->connect('DBI:mysql:test;user=root;password=')or die "Connection to test failed: $DBI::errstr";
    my $sth=$dbh->prepare("SELECT * FROM websites");;
    $sth->execute($team);
    if ($sth->rows == 0){
    print "Your team isn't in the table.<br>";
    exit;
    }
print h2("Data for \u$team");
while(($name,$wins,$losses) = $sth->fetchrow_array()){
print <<EOF;
<table border="1" bgcolor="yellow">
<tr>
<th>Name</th>
<th>Wins</th>
<th>Losses</th>
</tr>
<tr>
<td>$name</td>
<td>$wins</td>
<td>$losses</td>
</tr>
</table>
EOF
print end_html();
$sth->finish();
    }
}