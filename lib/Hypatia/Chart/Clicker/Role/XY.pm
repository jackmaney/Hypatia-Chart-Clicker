package Hypatia::Chart::Clicker::Role::XY;
use Moose::Role;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Data::DataSet;
use Hypatia::Columns;

requires qw(data_series_names _setup_guess_columns);

override '_guess_columns' =>sub
{
    my $self=shift;
    
    my @columns = @{$self->_setup_guess_columns};
    
    my $col_types={};
    
    if(@columns < 2)
    {
	confess "One column is insufficient to form a chart";
    }
    elsif(@columns == 2)
    {
	$col_types->{x} = $columns[0];
        $col_types->{y} = $columns[1];
    }
    elsif(scalar(@columns) % 2)
    {
        $col_types->{x} = $columns[0];
        $col_types->{y} = [@columns[1..$#columns]];
    }
    else
    {
        while(@columns)
        {
    	    push @{$col_types->{x}}, shift @columns;
    	    push @{$col_types->{y}}, shift @columns;
        }
    }
    
    $self->cols(Hypatia::Columns->new({columns=>$col_types}));
};

sub _build_data_set
{
    my $self=shift;
    my $data=shift;
    
    my ($x,$y)=($self->columns->{x}, $self->columns->{y} );
    my $series_array_ref=[];
    
    confess "Unable to grab 'x' and 'y' columns" unless defined $x and defined $y;
    
    foreach($x,$y)
    {
	$_=[$_] unless ref($_);
    }
    
    my $x_cols; #Either n copies of $x->[0] (if there's only one $x column) or just $x (if there's more than one $x column)
    
    if(scalar(@$x)==1)
    {
	foreach(@$y)
	{
	    push @$x_cols,$x->[0];
	}
    }
    else
    {
	$x_cols=$x;
    }
    
    my @names=@$y;
    
    if($self->has_data_series_names)
    {
	foreach my $i(0..(scalar(@{$self->data_series_names})-1))
	{
	    if (defined($self->data_series_names->[$i]) and $i<@$y)
	    {
		$names[$i]=$self->data_series_names->[$i];
	    }
	}
    }
    
    foreach(0..(scalar(@$y)-1))
    {
	my @x_data;
	my @y_data;
	
	if($self->has_input_data)
	{
	    my @raw_x_data=@{$data->{$x_cols->[$_]}};
	    my @raw_y_data=@{$data->{$y->[$_]}};
	    
	    @x_data=sort{$a<=>$b}@raw_x_data;
	    #sorting y by the values of x:
	    @y_data=@raw_y_data[sort{$raw_x_data[$a]<=>$raw_x_data[$b]}0..$#raw_x_data];
	}
	else
	{
	    @x_data=@{$data->{$x_cols->[$_]}};
	    @y_data=@{$data->{$y->[$_]}};
	}
	
	push @$series_array_ref,Chart::Clicker::Data::Series->new(
	    keys=>\@x_data,
	    values=>\@y_data,
	    name=>$names[$_]
	);
    }
    
    return Chart::Clicker::Data::DataSet->new(series=>$series_array_ref);
}

1;