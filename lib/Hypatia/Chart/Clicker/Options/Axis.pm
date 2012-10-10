package Hypatia::Chart::Clicker::Options::Axis;
use strict;
use warnings;
use Moose;
use MooseX::Aliases;
use Hypatia::Types qw(PositiveInt NumBetween0And1);
use Hypatia::Chart::Clicker::Types qw(Color Font Orientation Position AxisRange);
use Graphics::Color::RGB;
use Graphics::Primitive::Font;

#ABSTRACT: Options to apply to axes in Chart::Clicker via Hypatia

=head1 NOTE

Attributes of the following object types can be coerced from the following:

=over 4

=item * L<Graphics::Color::RGB> from either a hash reference with keys of C<r>, C<g>, C<b>, and C<a>
(and values between 0 and 1) or a number between 0 and 1 that is passed in for each of
C<r>, C<g>, C<b>, and C<a>.

=item * L<Chart::Clicker::Data::Range> (for axis ranges) from an array reference of two numbers, the first of which
needs to be smaller than the second. The numbers in question are passed into the C<min> and C<max> attributes of the
L<Chart::Clicker::Data::Range> object in question.

=item * L<Graphics::Primitive::Font> from a hash reference.

=back

Also, the attributes denoting B<positions> are L<enum|https://metacpan.org/module/Moose::Util::TypeConstraints>s with values of C<north>, C<south>, C<east>, C<west>, and C<center>.

=attr color

The color of the axis. Of course, this is a L<Graphics::Color::RGB> object.

=cut

has "color"=>(isa=>Color, is=>"ro",coerce=>1,default=>sub{ Graphics::Color::RGB->new({r=>0,g=>0,b=>0,a=>1}) });

=attr format

Either a format string that is passed to each tick label via L<sprintf|http://perldoc.perl.org/functions/sprintf.html> or
a code reference that is used to format the label values. See L<Chart::Clicker::Axis> for more information.

The default is C<< %s >>.

=cut

has "format"=>(isa=>"Str|CodeRef", is=>"ro",default=>"%s");

=attr fudge_amount

The percentage (expressed as a number between 0 and 1) by which the axis will grow at both ends (as a "fudge factor").

The default is 0.

=cut

has "fudge_amount"=>(isa=>NumBetween0And1, is=>"ro", default=>0);

=attr hidden

A boolean value to determine whether or not the axis will be hidden on the plot. The default is 0.

=cut

has "hidden"=>(isa=>"Bool", is=>"ro", default=>0);

=attr label

The label of the axis. This attribute is optional.

=cut

has "label"=>(isa=>"Str", is=>"ro",predicate=>"has_label_option");

=attr label_color

A L<Graphics::Color::RGB> object representing the color of the label.

=cut

has "label_color"=>(isa=>Color, is=>"ro", coerce=>1,default=>sub{ Graphics::Color::RGB->new({r=>0,g=>0,b=>0,a=>1}) });

=attr label_font

A L<Graphics::Primitive::Font> object representing the font of the label. See L<Graphics::Primitive::Font> for the particulars.

=cut

has "label_font"=>(isa=>Font, is=>"ro", coerce=>1,default=>sub{ Graphics::Primitive::Font->new });

=attr position

The position of the axis on the chart. This attribute is optional.

=cut

has "position"=>(isa=>Position, is=>"ro", predicate=>"has_position_option");

=attr range

A L<Chart::Clicker::Data::Range> object representing the range of the axis. This attribute is optional.

=cut

has "range"=>(isa=>AxisRange, is=>"ro", predicate=>"has_range_option");

=attr show_ticks

A boolean representing whether or not ticks and labels should be shown for the given axis. The default is 1.

=cut

has "show_ticks"=>(isa=>"Bool", is=>"ro", default=>1);

=attr staggered

A boolean representing whether or not the tick labels alternate between one side of the axis and the other. The default is 0.

=cut

has "staggered"=>(isa=>"Bool", is=>"ro", default=>0);

=attr skip_range

A L<Chart::Clicker::Data::Range> object. If supplied, this range of values will be skipped completely on the axis. See L<Chart::Clicker::Axis> for more details.

=cut

has "skip_range"=>(isa=>AxisRange, is=>"ro", predicate=>"has_skip_range_option");

=attr tick_font

A L<Graphics::Primitive::Font> object representing the font for the tick labels.

=cut

has "tick_font"=>(isa=>Font, is=>"ro", coerce=>1,default=>sub{ Graphics::Primitive::Font->new });

=attr tick_label_angle

The angle--measured in radians--to rate the tick labels. The default is 0.

=cut

has "tick_label_angle"=>(is=>"ro",isa=>"Num",default=>0);

=attr tick_label_color

A L<Graphics::Color::RGB> object representing the color of the tick labels. The default is black.

=cut

has "tick_label_color"=>(isa=>Color, is=>"ro", coerce=>1,default=>sub{ Graphics::Color::RGB->new({r=>0,g=>0,b=>0,a=>1}) });

=attr tick_labels

An array reference of labels to apply to ticks (in order). See L<Chart::Clicker::Axis> for more details.

=cut

has "tick_labels"=>(isa=>"ArrayRef", is=>"ro", predicate=>"has_tick_labels_option");

=attr tick_values

An array reference of values denoting where the ticks should be on the axis. See L<Chart::Clicker::Axis> for more details.

=cut

has "tick_values"=>(isa=>"ArrayRef", is=>"ro", predicate=>"has_tick_values_option");

=attr ticks (a.k.a. num_ticks)

The number of ticks to show. See L<Chart::Clicker::Axis> for more details.

has "ticks"=>(isa=>PositiveInt, is=>"ro", predicate=>"has_ticks_option", alias=>"num_ticks");

=cut

__PACKAGE__->meta->make_immutable;
1;