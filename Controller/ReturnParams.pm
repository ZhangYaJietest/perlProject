package ReturnParams;
use strict;
use warnings FATAL =>'all';
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}
sub Params{
    my %h_return = (
        "0","fail",
        "1","success",
        "2","This storage has been used and cannot be deleted",
        "3","Data deleted successfully",
        "4","The name already exists, please use a different hostname",
        "5","Hostname cannot be empty",
        "6","Data created successfully",
        "7","Data updated successfully",
        "8","The name of VM needs to start with VM or vm",
        "9","The name of storage needs to start with STO or sto"
    );
    return \%h_return;

}
1;