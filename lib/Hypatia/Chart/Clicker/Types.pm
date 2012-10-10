package Hypatia::Chart::Clicker::Types;
use MooseX::Types -declare=>[
    qw(
	Options
	NumBetween0And1
	Color
	Padding
	Position
	AxisFormat
	Font
	AxisRange
	AxisOptions
	Format
    )
];
use MooseX::Types::Moose qw(HashRef Num Str ArrayRef);
use Hypatia::Types qw(PositiveInt);

subtype Options, as class_type("Hypatia::Chart::Clicker::Options");
coerce Options, from HashRef, via { Hypatia::Chart::Clicker::Options->new($_) };

subtype NumBetween0And1, as Num, where {$_ >= 0 and $_ <= 1};

subtype Color, as class_type("Graphics::Color::RGB");
coerce Color, from HashRef, via {Graphics::Color::RGB->new($_)};
coerce Color, from NumBetween0And1, via { Graphics::Color::RGB->new({r=>$_,g=>$_,b=>$_,a=>$_}) };

subtype Padding, as class_type("Graphics::Primitive::Insets");
coerce Padding, from PositiveInt, via { Graphics::Primitive::Insets->new({top=>$_,bottom=>$_,right=>$_,left=>$_}) };
coerce Padding, from HashRef[PositiveInt], via { Graphics::Primitive::Insets->new($_) };

enum Position,[qw(north south east west center North South East West Center)];

enum Format, [qw(png pdf ps svg PNG PDF PS SVG Png Pdf Ps Svg)];

subtype Font, as class_type("Graphics::Primitive::Font");
coerce Font, from HashRef, via {Graphics::Primitive::Font->new($_)};

subtype RangeArrayRef, as ArrayRef[Num], where{@{$_} == 2 and $_->[0] < $_->[1]};

subtype AxisRange, as class_type("Chart::Clicker::Data::Range");
coerce AxisRange, from RangeArrayRef, via {
    Chart::Clicker::Data::Range->new({min=>$_->[0], max=>$_->[1]});
}

subtype AxisOptions, as class_type("Hypatia::Chart::Clicker::Options::Axis");
coerce AxisOptions, from HashRef, via { Hypatia::Chart::Clicker::Options::Axis->new($_) };


1;