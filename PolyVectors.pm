package PolyVectors;
use base GD::Polygon;
use strict;
use vars '$VERSION';
$VERSION = '1.0';
use constant PI    => 4 * atan2(1, 1);

sub new { # If param numbers of params in @points not odd - the last will be dropped
	my ($class,@points)=@_;
	my $self = new GD::Polygon;
	bless ($self, $class);
	my $size = @points;
	my ($x,$y);
	for (my $i=0;$i<$size;$i++){ 
		if ($i%2){
			$y = $points[$i];
			$self->addPt($x,$y);
		}else{
			$x = $points[$i];
		}
	}
	return $self;
}
sub newcopy {
	my $self = shift;
	my $poly = new PolyVectors;
	my $size = $self->length;
	for (my $i=0;$i<$size;$i++){
		my ($x,$y) = $self->getPt($i);
		$poly->addPt($x,$y);
	}
	return $poly;
}
sub copyfrom {
	my $self = shift;
	my $poly = shift;
	my $size = $poly->length;
	$self->clear;
	for (my $i=0;$i<$size;$i++){
		my ($x,$y) = $poly->getPt($i);
		$self->addPt($x,$y);
	}
	return $self;
}
sub print{
	my $self = shift;
	my $size = $self->length;
	for (my $i=0;$i<$size;$i++){
		my($x,$y)=$self->getPt($i);
		my $xs = "$x";
		my $ys = "$y";
		$xs=' '.$xs while (length($xs)<5);
		$ys=' '.$ys while (length($ys)<5);
		print "$i => (x=$xs, y=$ys)\n";
	}
}
# This is procedural variant
# sub printpoly{
	# my $polygon = shift;
	# for ($i=0;$i<($polygon->length);$i++){
		# ($x,$y) = $polygon->getPt($i);
		# $xs = "$x";
		# $ys = "$y";
		# $xs=' '.$xs while (length($xs)<5);
		# $ys=' '.$ys while (length($ys)<5);
		# print "$i => (x=$xs, y=$ys)\n";
	# }
# }
sub move {
	my ($self,$xs,$ys) = @_;
	my $size = $self->length;
	for (my $i=0;$i<$size;$i++){
		my($x,$y)=$self->getPt($i);
		$self->setPt($i,$x+$xs,$y+$ys);
	}
	return $self;
}
sub mul {
	my $self	= shift;
	my $modul = shift;
	my $size = $self->length;
	for (my $i=0;$i<$size;$i++){
		my($x,$y)=$self->getPt($i);
		$self->setPt($i,$x*$modul,$y*$modul);
	}
	return $self;
}
# This is procedural variant
# sub mulpoly {
	# my $modul = shift;
	# my $polygon = shift;
	# for ($i=0;$i<($polygon->length);$i++){
		# ($x,$y) = $polygon->getPt($i);
		# $polygon->setPt($i,$x*$modul,$y*$modul);
	# }
	# return $polygon;
# }
sub scalex {
	my $self  = shift;
	my $modul = shift;
	my $size  = $self->length;
	for (my $i=0;$i<$size;$i++){
		my($x,$y)=$self->getPt($i);
		$self->setPt($i,$x*$modul,$y);
	}
	return $self;
}
sub div {
	my $self  = shift;
	my $modul = shift;
	my $size  = $self->length;
	for (my $i=0;$i<$size;$i++){
		my($x,$y)=$self->getPt($i);
		$self->setPt($i,$x/$modul,$y/$modul);
	}
	return $self;
}
# This is procedural variant
# sub divpoly {
	# my $modul = shift;
	# my $polygon = shift;
	# for ($i=0;$i<($polygon->length);$i++){
		# ($x,$y) = $polygon->getPt($i);
		# $polygon->setPt($i,int($x/$modul),int($y/$modul));
	# }
	# return $polygon;
# }
sub rot {
	my $self  = shift;
	my $angle = shift;
	my $size  = $self->length;
	my $cos   = cos(PI*$angle/180);
	my $sin   = sin(PI*$angle/180);	
	for (my $i=0;$i<$size;$i++){
		my($tx,$y)=$self->getPt($i);
		my $x = int($tx*$cos - $y*$sin);
		$y = int($tx*$sin + $y*$cos);
		$self->setPt($i,$x,$y);
	}
	return $self;
} 
# This is procedural variant
# sub rotate {
	# my $angle = shift;
	# my $polygon = shift;
	# my $cos = cos(PI*$angle/180);
	# my $sin = sin(PI*$angle/180);	
	# print "cos=$cos\tsin=$sin\n";
	# for ($i=0;$i<($polygon->length);$i++){
		# ($tx,$y) = $polygon->getPt($i);
		# $x = int($tx*$cos - $y*$sin);
		# $y = int($tx*$sin + $y*$cos);
		# $polygon->setPt($i,$x,$y);
	# }
	# return $polygon;
# } 
sub sizexy {
	my $self  = shift;
	my ($sizex,$sizey,$minx,$miny,$maxx,$maxy) = (0,0,0,0,0,0);
	my $size  = $self->length;
	for (my $i=0;$i<$size;$i++){
		my($x,$y)=$self->getPt($i);
		$minx = $x if $minx > $x;
		$miny = $y if $miny > $y;
		$maxx = $x if $maxx < $x;
		$maxy = $y if $maxy < $y;
	}
	$sizex = $maxx - $minx;
	$sizey = $maxy - $miny;
	return ($sizex,$sizey);
}
# This is procedural variant
# sub getpolysizexy {
	# my $polygon = shift;
	# my ($sizex,$sizey,$minx,$miny,$maxx,$maxy) = (0,0,0,0,0,0);
	# for ($i=0;$i<($polygon->length);$i++){
		# ($x,$y) = $polygon->getPt($i);
		# $minx = $x if $minx > $x;
		# $miny = $y if $miny > $y;
		# $maxx = $x if $maxx < $x;
		# $maxy = $y if $maxy < $y;
	# }
	# $sizex = $maxx - $minx;
	# $sizey = $maxy - $miny;
	# return ($sizex,$sizey);
# }
sub maxmod{ 
	my $self = shift;
	my $size  = $self->length;
	my $mod = 0;
	for (my $i=0;$i<$size;$i++){
		my($x,$y)=$self->getPt($i);
		my $mod2 = $x*$x + $y*$y;
		$mod = $mod2 if $mod2 > $mod;
	}
	return 2*sqrt($mod);
}
sub maxsize{
	my $self = shift;
	my ($xs, $ys) = $self->sizexy();
	$xs = $ys if $xs < $ys;
	return $xs;
}
# This is procedural variant
# sub getpolysize{
	# my $polygon = shift;
	# my ($xs, $ys) = getpolysizexy($polygon);
	# $xs = $ys if $xs < $ys;
	# return $xs;
# }
sub printxy{
	my $self = shift;
	my ($xs, $ys) = $self->sizexy();
	print "$xs / $ys\n";
}
# This is procedural variant
# sub printpolysizexy{
	# my $polygon = shift;
	# my ($xs, $ys) = getpolysizexy($polygon);
	# print "$xs / $ys\n";
# }
1;
