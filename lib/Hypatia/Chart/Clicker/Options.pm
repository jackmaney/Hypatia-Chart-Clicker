package Hypatia::Chart::Clicker::Options;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
#use Hypatia::Chart::Clicker::Options::Axis;
#use Hypatia::Chart::Clicker::Options::Title;
use Graphics::Color::RGB;
use Graphics::Primitive::Insets;
use Scalar::Util qw(blessed);

#ABSTRACT: Options to apply to Chart::Clicker objects via Hypatia

subtype 'PositiveNum', as 'Num', where {$_>0};
subtype 'PositiveInt', as 'Int', where {$_>0};
subtype "ColorNum", as "Num", where {$_>=0 and $_<=1};

#subtype 'AxisOptions', as class_type("Hypatia::Chart::Clicker::Options::Axis");
#coerce 'AxisOptions', from 'HashRef', via { Hypatia::Chart::Clicker::Options::Axis->new($_) };

subtype 'Color', as class_type("Graphics::Color::RGB");
coerce 'Color', from 'HashRef', via {Graphics::Color::RGB->new($_)};
coerce "Color", from "ColorNum", via { Graphics::Color::RGB->new({r=>$_,g=>$_,b=>$_,a=>$_}) };


subtype 'Padding', as class_type("Graphics::Primitive::Insets");
coerce "Padding", from "PositiveInt", via { Graphics::Primitive::Insets->new({top=>$_,bottom=>$_,right=>$_,left=>$_}) };
coerce "Padding", from "HashRef[PositiveInt]", via { Graphics::Primitive::Insets->new($_) };

#subtype "TitleOptions", as class_type("Hypatia::Chart::Clicker::Options::Title");
#coerce "TitleOptions", from "Str", via { Hypatia::Chart::Clicker::Options::Title->new({text=>$_}) };
#coerce "TitleOptions", from "HashRef", via { Hypatia::Chart::Clicker::Options::Title->new($_) };

#has [qw(domain_axis range_axis)]=>(isa=>"AxisOptions",is=>"ro",coerce=>1
#    ,default=>sub{ Hypatia::Chart::Clicker::Options::Axis->new });

has 'background_color'=>(isa=>"Color",is=>"ro",coerce=>1,default=>sub{ Graphics::Color::RGB->new({r=>1,g=>1,b=>1,a=>1}) });

#TODO: Border options

has 'format'=>(isa=>enum([qw(png pdf ps svg PNG PDF PS SVG Png Pdf Ps Svg)]),is=>'ro',default=>"PNG");

has 'height'=>(isa=>'PositiveInt',is=>'ro',default=>300);

#TODO: Legend options

enum "Position",[qw(n s e w c N S E W C north south east west center North South East West Center)];

has 'legend_position'=>(isa=>"Position",is=>'ro',default=>'s');

has "padding"=>(isa=>"Padding",is=>"ro",coerce=>1,default=>3);

#has "title"=>(isa=>"TitleOptions", is=>"ro", coerce=>1, default=>sub{ Hypatia::Chart::Clicker::Options::Title->new });

has "title_position"=>(isa=>"Position", is=>"ro",default=>"n");

has "width"=>(isa=>"PositiveInt", is=>"ro", default=>500);


sub apply_to
{
    my $self=shift;
    my $cc=shift;
    
    confess "Argument to sub apply_to is either missing or not a Chart::Clicker object" unless blessed($cc) eq "Chart::Clicker";
    
    foreach my $attr(__PACKAGE__->meta->get_all_attributes)
    {
	my $attr_name=$attr->name;
	my $attr_value = $self->$attr_name();
	
	eval{$cc->$attr_name($attr_value)};
	
	confess $@ if $@;
    }
    
    return $cc;
    
}

__PACKAGE__->meta->make_immutable;
1;