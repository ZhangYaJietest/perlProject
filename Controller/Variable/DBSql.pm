package DBSql;
use lib "C:/Users/142587/PycharmProjects/perlProject/Controller/";
use strict;
use warnings FATAL => 'all';
use Judge;
sub new{
    my $class = shift;
    my $ref={};
    bless($ref);
    return $ref;
}

sub field_select{
    my $self = shift;
    my $s_tablename = $_[0];
    my $s_dsql = "SELECT a.attnum, a.attname AS field, t.typname AS type, a.attlen AS length, a.atttypmod AS lengthvar
    , a.attnotnull AS notnull, b.description AS comment
       FROM pg_class c, pg_attribute a
    LEFT JOIN pg_description b
    ON a.attrelid = b.objoid
        AND a.attnum = b.objsubid, pg_type t
    WHERE c.relname = $s_tablename
        AND a.attnum > 0
        AND a.attrelid = c.oid
        AND a.atttypid = t.oid
        ORDER BY a.attnum;";
    return $s_dsql;
}

sub insert_sql{
    my $self = shift;
    my $tname = $_[0];
    my $field = $_[1];
    my $s_keysql = "(";
    my $s_valuesql = "(";
    my $i_len = keys %$field;
    my $i_count = 1;
    while((my $key,my $value)=each(%$field)){
        if ($i_count++<$i_len){
            $s_keysql .= $key .=",";
            $s_valuesql .= $value .=",";

        }else{
            $s_keysql .= $key .=")";
            $s_valuesql .= $value .=")";
        }
    }

    my $s_insertSql = "INSERT INTO ".$tname.$s_keysql." values".$s_valuesql.";";
    return $s_insertSql;
}

sub delete_sql{
    my $self = shift;
    my $s_tname = $_[0];
    my $s_fieldKey = $_[1];
    my $s_fieleValue = $_[2];
    my $s_deleteSql = "DELETE FROM ".$s_tname." WHERE ".$s_fieldKey."=".$s_fieleValue.";";
    return $s_deleteSql;
}
sub update_sql{
    my $self = shift;
    my $s_tname = $_[0];
    my $hr_upField = $_[1];
    my $a_upwhere = $_[2];

    my $s_setSql = "";
    my $s_whereSql = "$$a_upwhere[0]"." = ";
    my $i_len = keys %$hr_upField;
    my $i_count = 1;

    while((my $key,my $value)=each(%$hr_upField)){
        if ($i_count++<$i_len){
            my $set_sql = $key."=";
            $s_setSql .= $set_sql.= $value .= ",";
        }else{
            my $set_sql = $key."=";
            $s_setSql .= $set_sql.= $value;
        }
    }
    $s_whereSql .= $$a_upwhere[1];

    # while((my $key,my $value)=each(%$a_upwhere)){
    #     print $key;
    #     print $value;
    # }

    my $s_updateSql = "UPDATE ".$s_tname." SET ".$s_setSql." WHERE ".$s_whereSql.";";
    return $s_updateSql;
}

1;