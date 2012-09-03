#!perl -T

use Test::More tests => 7;

BEGIN {
    my @modules=qw(
        Hypatia::Chart::Clicker
        Hypatia::Chart::Clicker::Line
        Hypatia::Chart::Clicker::Bar
        Hypatia::Chart::Clicker::Area
        Hypatia::Chart::Clicker::Point
        Hypatia::Chart::Clicker::Bubble
        Hypatia::Chart::Clicker::Pie
    );

    foreach(@modules)
    {
        use_ok($_) or print "Couldn't load module $_\n";
    }
}

diag( "Testing Hypatia::Chart::Clicker $Hypatia::Chart::Clicker::VERSION, Perl $], $^X" );

