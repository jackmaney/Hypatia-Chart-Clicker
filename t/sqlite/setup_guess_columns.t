use strict;
use warnings;
use Test::More tests => 4;
use Hypatia::DBI::Test::SQLite;
use Scalar::Util qw(blessed);

my $dbi_test=Hypatia::DBI::Test::SQLite->new;
my $dbh=$dbi_test->dbh;

my $hcc=Hypatia::Chart::Clicker->new({
    back_end=>"Chart::Clicker",
    graph_type=>"Line",
    dbi=>{
        dbh=>$dbh,
        table=>"hypatia_test_xy"
    }
});

ok(blessed $hcc eq 'Hypatia::Chart::Clicker');
ok($hcc->dbi->{Active});

my @columns = @{$hcc->_setup_guess_columns};

ok(@columns == 4);
ok(grep{$_ eq 'x1' or $_ eq 'x2' or $_ eq 'y1' or $_ eq 'y2'}@columns == 4);

