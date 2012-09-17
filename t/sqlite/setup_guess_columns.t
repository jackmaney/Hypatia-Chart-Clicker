use strict;
use warnings;
use Test::More tests => 5;
use Hypatia::DBI::Test::SQLite;
use Hypatia::Chart::Clicker;
use Scalar::Util qw(blessed);

my $dbi_test=Hypatia::DBI::Test::SQLite->new({table=>"hypatia_test_xy"});
my $dbh=$dbi_test->dbh;

my $hcc=Hypatia::Chart::Clicker->new({
    back_end=>"Chart::Clicker",
    graph_type=>"Line",
    dbi=>{
        dbh=>$dbh,
        table=>"hypatia_test_xy"
    }
});

ok(not $hcc->cols);
ok(blessed $hcc eq 'Hypatia::Chart::Clicker');
ok($hcc->dbh->{Active});

my @columns = @{$hcc->_setup_guess_columns};

ok(@columns == 4);

ok(scalar(grep{$_ eq 'x1' or $_ eq 'x2' or $_ eq 'y1' or $_ eq 'y2'}@columns) == 4);

