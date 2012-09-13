package Hypatia::Chart::Clicker;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

extends 'Hypatia::Base';

#ABSTRACT: Hypatia Bindings for Chart::Clicker

=head1 SYNOPSIS

This module extends L<Hypatia::Base>, so all of the methods and attributes are inherited. The currently-supported C<graph_type>s are:

=over 4

=item * Area (stacked or not)

=item * Bar (stacked or not)

=item * Bubble

=item * Line (stacked or not)

=item * Pie

=item * Point

=back

=head1 EXAMPLES

Take a look at the C<examples> folder included with this distribution.

=head1 KNOWN ISSUES

For reasons I don't understand, not all systems seem to render the C<Chart::Clicker> objects correctly. I've tested the examples on Open SuSE, Windows 7, and CentOS. The first system rendered the graphics correctly, the second renders almost correctly save for missing axis ticks, and the third only seems to render blank white rectangles.

=attr input_data (overridden from L<Hypatia>)

This data, if provided, must be a hash reference of array references, where the keys represent the "column names" and the array references represent the (numeric) values of the given column.  Furthermore, if this attribute is set, then each column type in the C<columns> attribute must appear in the keys of C<input_data> and all of the array references must be of the same length and cannot contain any C<undef> entries.

=cut

has 'input_data'=>(isa=>'HashRef[ArrayRef[Num]]',is=>'ro',predicate=>'has_input_data');    


=attr data_series_names

In C<Chart::Clicker>, every chart has one or more data set (ie L<Chart::Clicker::Data::Set>) and each data set has one or more data series (ie L<Chart::Clicker::Data::Series>).  Each data series has an optional C<name> attribute.  The value(s) for this attribute (either a string or an array reference of strings) is passed directly into the C<name> attribute for each data series.  This attribute is optional, and if it's not used, then a submodule-dependent default will be supplied (usually the relevant C<y> column name).

=cut



has 'data_series_names'=>(isa=>'Str|ArrayRef[Str]',is=>'ro',predicate=>'has_data_series_names');


sub _get_data
{
	my $self=shift;
	my @columns;
	
	$self->_guess_columns unless $self->using_columns;
	
	if(@_)
	{
		@columns=grep{defined}map{$self->columns->{$_}}@_;
	}
	else
	{
		@columns = @{$self->columns->column_types};
	}
	
	if($self->use_dbi)
	{	
		return $self->dbi->data(@columns);
	}
	else
	{
		return $self->input_data;
	}
}

# This can be thought of as a quasi-abstract method.
# Unless you're calling a class that overrides it, you better have your columns set.
sub _guess_columns
{
	confess "The attribute 'columns' is required";
}

# This is a setup method for methods overriding _guess_columns.
# Yes, I know about the Moose keyword 'after', but I'm not
# sure offhand how to run the code in _setup_guess_columns
# except if _guess_columns is being overridden.
sub _setup_guess_columns
{
	my $self=shift;
	
	my $query=$self->dbi->_build_query;
	
	my $dbh=$self->dbh;
	my $sth=$dbh->prepare($query) or die $dbh->errstr;
	$sth->execute or die $dbh->errstr;
	
	my @return = @{$sth->{NAME}};
	
	$sth->finish;
	
	return \@return;
}

sub BUILD
{
	my $self=shift;
	
	if($self->has_input_data)
	{
		#dying instead of confessing so that the warning messages are easier to spot
		die "Validation of input_data unsuccessful" unless $self->_validate_input_data($self->input_data);
	}
}

sub _validate_input_data
{
	my $self=shift;
	
	my $data=shift;
	
	return undef unless defined $data;
	
	my $first=1;
	my $num_rows;
	
	my @column_list;
	
	$self->_guess_columns unless $self->using_columns;

	foreach my $type(keys %{$self->columns})
	{
		my $col=$self->columns->{$type};
		
		if(ref $col eq ref [])
		{
			foreach my $c(@$col)
			{
				push @column_list,$c unless grep{$c eq $_}@column_list;
			}
		}
		else
		{
			push @column_list,$col unless grep{$col eq $_}@column_list;
		}
	}
	
	foreach my $col(@column_list)
	{ 
		unless(grep{$_ eq $col}(keys %$data))
		{
			warn "WARNING: Column \"$col\" not found as a key in the input_data attribute\n";
			return undef;
		}
		
		
		my @column=@{$data->{$col}};
		
		unless(@column == grep{defined $_}@column)
		{
			warn "WARNING: Undefined values found in the input_data for column $col";
			return undef;
		}
		
		if($first)
		{
			$num_rows=scalar(@column);
			$first=0;
		}
		else
		{
			unless(@{$data->{$col}} == $num_rows)
			{
				warn "WARNING: Mismatch for number of elements in input_data values";
				return undef;
			}
		}
	}
	
	return 1;
}

1; 
