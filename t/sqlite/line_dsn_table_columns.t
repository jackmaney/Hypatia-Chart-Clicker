use strict;
use warnings;
use Test::More;
use Hypatia::DBI::Test::SQLite;
use Scalar::Util qw(blessed);
use Class::Path;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Series;

my $hdbts=Hypatia::DBI::Test::SQLite->new;

my $database=file($hdbts->dir,$hdbts->sqlite_db_file);

my $hypatia=Hypatia->new({
    back_end=>"Chart::Clicker",
    graph_type=>"Line",
    dbi=>{
	dsn=>"dbi:SQLite;dbname=$database",
	table=>"hypatia_test_xy"
    },
    columns=>{x=>"x1",y=>"y1"}
});

ok(blessed($hypatia) eq 'Hypatia');
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
ok(@$values == 5)
ok(grep{$_ == 1.1 or $_ == -2.1 or $_ == 3.3 or $_ == 0 or $_ == 7}@$values == 5);

done_testing();