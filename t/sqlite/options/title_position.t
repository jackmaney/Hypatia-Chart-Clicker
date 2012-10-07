use strict;
use warnings;
use Test::More;
use Hypatia;
use Hypatia::DBI::Test::SQLite;
use Scalar::Util qw(blessed);

my $hdts=Hypatia::DBI::Test::SQLite->new({table=>"hypatia_test_xy"});

my @positions=qw(north south east west center North South East West Center);

foreach my $position(@positions)
{

    my $hypatia=Hypatia->new({
	dbi=>{dbh=>$hdts->dbh,table=>"hypatia_test_xy"},
	columns=>{x=>"x1",y=>"y1"},
	back_end=>"Chart::Clicker",
	graph_type=>"Line",
	options=>{title_position=>$position}
    });
    
    isa_ok($hypatia,"Hypatia");
    
    my $cc=$hypatia->chart;
    
    isa_ok($cc,"Chart::Clicker");

    ok($cc->title_position eq $position);
}

done_testing();