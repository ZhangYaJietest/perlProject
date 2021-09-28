package DBSql;
use lib "C:/Users/142587/PycharmProjects/perlProject/Model/";
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
    my $s_tname = $_[0];
    my $hr_field = $_[1];
    my $s_keysql = "(";
    my $s_valuesql = "(";
    my $i_len = keys %$hr_field;
    my $i_count = 1;
    while((my $key,my $value)=each(%$hr_field)){
        if ($i_count++<$i_len){
           $s_keysql  .= $key .=",";
            $s_valuesql .= $value .=",";

        }else{
            $s_keysql .= $key .=")";
            $s_valuesql .= $value .=")";
        }
    }

    my $s_insertSql = "INSERT INTO ".$s_tname.$s_keysql." values".$s_valuesql.";";
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

sub Condition_query_sql{
    my $self = shift;
    my $s_name = $_[0];
    my $s_cdsql ="";
    if ($s_name eq ''){
        $s_cdsql = "SELECT A.name,B.name as operating_system,C.name as storage,checksum,A.create_time,A.update_time
         from server A,operation B,storage C
	     where A.operating_system = B.id
	     AND A.storage = C.id order by name;";
    }else{
        $s_cdsql = "SELECT A.name,B.name as operating_system,C.name as storage,checksum,A.update_time,A.create_time
         from server A,operation B,storage C
	     where A.operating_system = B.id
	     AND A.storage = C.id and A.name like " . $s_name ." order by name;";
    }
    return $s_cdsql;
}

sub update_capacity{
    my $self = shift;
    my $i_id = $_[0];
    my $s_cdsql = "update storage set usedcapacity =(select usedcapacity from storage where id = ".$i_id.")+10 where id=".$i_id.";";
    return $s_cdsql;
}
sub selectBYid_sql{
    my $self = shift;
    my $i_id = $_[0];
    my $s_cdsql = "select capacity,usedcapacity  from storage where id = ".$i_id.";";
    return $s_cdsql;
}
sub selectBYname_sql{
    my $self = shift;
    my $s_name = $_[0];
    my $s_cdsql = "select capacity,usedcapacity  from storage where name = ".$s_name.";";
    return $s_cdsql;
}

1;