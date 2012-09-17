use strict;
use warnings;
use Test::More;
use Hypatia;
use Hypatia::DBI::Test::SQLite;
use Scalar::Util qw(blessed);

my $hdts=Hypatia::DBI::Test::SQLite->new({table=>"hypatia_test_xy"});

foreach my $graph_type(qw(Area Bar Line Point))
{
    my $hypatia=Hypatia->new({
	back_end=>"Chart::Clicker",
	graph_type=>$graph_type,
	dbi=>{dsn=>"dbi:SQLite:dbname=" . $hdts->sqlite_db_file,
	    table=>"hypatia_test_xy"},
	    columns=>{x=>"x1",y=>"y1"}
    });
    
    ok(blessed($hypatia) eq "Hypatia");
    ok(blessed($hypatia->dbh) eq 'DBI::db');
    ok($hypatia->dbh->{Active});
    
    my $cc=$hypatia->chart;
    
    ok(blessed($cc) eq 'Chart::Clicker');
    
    my $dataset=$cc->datasets->[0];
    ok(blessed($dataset) eq 'Chart::Clicker::Data::DataSet');
    
    my $dataseries=$dataset->series->[0];
    ok(blessed($dataseries) eq 'Chart::Clicker::Data::Series');
    my $keys=$dataseries->keys;
    ok(@$keys == 5);
    ok(grep{$_ ==1 or $_ == 2 or $_== 4 or $_==5 or $_==6}@$keys == 5);
    
    my $values = $dataseries->values;
    ok(@$values == 5);
    
    ok(scalar(grep{$_ == 7.22 or $_ == 3.88 or $_ == 6.2182 or $_ == 4.1 or $_ == 2.71828}@$values) == 5);
}

done_testing();