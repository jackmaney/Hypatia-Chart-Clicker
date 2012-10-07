package Hypatia::Chart::Clicker::Options::Axis;
use strict;
use warnings;
use Moose;
use MooseX::Aliases;
use Hypatia::Types qw(PositiveInt NumBetween0And1);
use Hypatia::Chart::Clicker::Types qw(Color Font Orientation Position AxisRange);
use Graphics::Color::RGB;
use Graphics::Primitive::Font;

has "tick_label_angle"=>(is=>"ro",isa=>"Num",default=>0);

has "color"=>(isa=>Color, is=>"ro",coerce=>1,default=>sub{ Graphics::Color::RGB->new({r=>0,g=>0,b=>0,a=>1}) });

has "format"=>(isa=>"Str|CodeRef", is=>"ro",default=>"%s");

has "fudge_amount"=>(isa=>NumBetween0And1, is=>"ro", default=>0);

has "hidden"=>(isa=>"Bool", is=>"ro", default=>0);

has "label"=>(isa=>"Str", is=>"ro",predicate=>"has_label_option");

has "label_color"=>(isa=>Color, is=>"ro", coerce=>1,default=>sub{ Graphics::Color::RGB->new({r=>0,g=>0,b=>0,a=>1}) });

has "label_font"=>(isa=>Font, is=>"ro", coerce=>1,default=>sub{ Graphics::Primitive::Font->new });

has "position"=>(isa=>Position, is=>"ro", predicate=>"has_position_option");

has "range"=>(isa=>AxisRange, is=>"ro", predicate=>"has_range_option");

has "show_ticks"=>(isa=>"Bool", is=>"ro", default=>1);

has "staggered"=>(isa=>"Bool", is=>"ro", default=>0);

has "skip_range"=>(isa=>AxisRange, is=>"ro", predicate=>"has_skip_range_option");

has "tick_font"=>(isa=>Font, is=>"ro", coerce=>1,default=>sub{ Graphics::Primitive::Font->new });

has "tick_label_color"=>(isa=>Color, is=>"ro", coerce=>1,default=>sub{ Graphics::Color::RGB->new({r=>0,g=>0,b=>0,a=>1}) });

has "tick_labels"=>(isa=>"ArrayRef", is=>"ro", predicate=>"has_tick_labels_option");

has "tick_values"=>(isa=>"ArrayRef", is=>"ro", predicate=>"has_tick_values_option");

has "ticks"=>(isa=>PositiveInt, is=>"ro", predicate=>"has_ticks_option", alias=>"num_ticks");


__PACKAGE__->meta->make_immutable;
1;