package Hypatia::Chart::Clicker::Line;
use Moose;
use MooseX::Aliases;
use Moose::Util::TypeConstraints;
use Scalar::Util qw(blessed);
use Chart::Clicker;
use Chart::Clicker::Data::DataSet;
use namespace::autoclean;

extends 'Hypatia::Chart::Clicker';


#ABSTRACT: Line Charts with Hypatia and Chart::Clicker

=head1 SYNOPSIS

This module extends L<Hypatia::Chart::Clicker>.  The C<graph> method (also known as the C<chart> method) returns the C<Chart::Clicker> object built from the relevant data and options provided.

=attr columns

The required column types are C<x> and C<y>.  Each of the values for this attribute may be either a string (indicating one column) or an array reference of strings (indicating several columns).  In the latter case, the number of C<x> and C<y> columns must match and each respective C<x> and C<y> column will form its own line graph.  In the former case, the single C<x> column will act as the same C<x> column for all of the C<y> columns.

If the C<columns> attribute is B<not> set, then the C<graph> method will look at the column names from your table or query I<in the order in which they appear>


=attr stacked

A boolean value indicating whether or not the graph should be a stacked line graph (ie whether or not the y values should be treated cumulatively).  This is disabled by default.

=cut

has 'stacked'=>(isa=>'Bool',is=>'ro',lazy=>1,default=>0);



=method chart([$data]), a.k.a graph([$data])

This method returns the relevant L<Chart::Clicker> object.  If neither the C<dbi> nor the C<input_data> attributes have been set, then you can input your data as an argument here.

=cut

sub chart
{
	my $self=shift;
	my $data_arg=shift;
	
	my $data;
	
	if(defined $data_arg and $self->_validate_input_data($data_arg))
	{
		$data=$data_arg;
	}
	else
	{
		$data=$self->_get_data(qw(x y));
	}
	
	my $cc=Chart::Clicker->new;
	
	my $dataset=$self->_build_data_set($data);
	
	
	unless(blessed($dataset) eq "Chart::Clicker::Data::DataSet")
	{
		confess "Returned value from the _build_data_set method is not a Chart::Clicker::Data::DataSet";
	}
	
	$cc->add_to_datasets($dataset);
	
	
	my $dc=$cc->get_context("default");    
	$dc->renderer->additive($self->stacked);        
	
	return $cc;
}

alias graph=>'chart';

override '_guess_columns' =>sub
{
	my $self=shift;
	
	my @columns=@{$self->_setup_guess_columns};
	
	my $col_types={};
	
	if(@columns < 2)
	{
		confess "One column is insufficient to form a chart";
	}
	elsif(@columns == 2)
	{
		$col_types->{x}=$columns[0];
		$col_types->{y}=$columns[1];
	}
	elsif(scalar(@columns) % 2)
	{
		$col_types->{x}=$columns[0];
		$col_types->{y}=[@columns[1..$#columns]];
	}
	else
	{
		while(@columns)
		{
			push @{$col_types->{x}}, shift @columns;
			push @{$col_types->{y}}, shift @columns;
		}
	}
	
	$self->columns(Hypatia::Columns->new(columns=>$col_types));
};


with 'Hypatia::Chart::Clicker::Role::XY';

__PACKAGE__->meta->make_immutable;

1;
