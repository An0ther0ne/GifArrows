=head1 NAME

GifArrow.pl - Animated arrows GIF maker.

Several modes supported: WEB and interactive and for both ones are various options (passed throught HTTP GET/POST or from command line). There are several limitations for security reasons, when this tool run in WEB mode. For example, saving resulting GIF to file does not work - I sure you know why.

=cut

# Copyright (c) by An0ther0ne 2019
# Github gifarrow progect

use GD;
use constant DEBUG => 0;
use strict;
use warnings 'all';

BEGIN {
	use Cwd;
	my $currentdir = cwd;	
	push (@INC,$currentdir);
	print "Current folder : ".$currentdir."\n" if DEBUG;
}
use PolyVectors;
print "Pi equals : ", PolyVectors::PI, "...\n" if DEBUG;
my $progname = $0;
$progname = $1 if $progname=~m|[/\\]([^/\\]+?)$|g;

my $webmode= 0;
my $width  = 320;
my $height = 320;

ParseOptions();

exit;

my $cx  = $width >> 1;
my $cy  = $height >> 1;
my $frames = 50;
my $delay  = 3;
my $polybase  = $cx > $cy ? $cy : $cx;
my $pmodul = 100000;

# $image->setPixel($x,$y,$color)	
	# $image->line($x1,$y1,$x2,$y2,$color)
	# $image->dashedLine($x1,$y1,$x2,$y2,$color)
	# $image->rectangle($x1,$y1,$x2,$y2,$color)
	# $image->filledRectangle($x1,$y1,$x2,$y2,$color) =item $image->setTile($otherimage)
	# $image->ellipse($cx,$cy,$width,$height,$color)
	# $image->filledEllipse($cx,$cy,$width,$height,$color)
	# $image->arc($cx,$cy,$width,$height,$start,$end,$color)
	# $image->filledArc($cx,$cy,$width,$height,$start,$end,$color [,$arc_style])
		# gdArc           connect start & end points of arc with a rounded edge
		# gdChord         connect start & end points of arc with a straight line
		# gdPie           synonym for gdChord
		# gdNoFill        outline the arc or chord
		# gdEdged         connect beginning and ending of the arc to the center
	# $image->fill($x,$y,$color)
	# $image->fillToBorder($x,$y,$bordercolor,$color)

my $image = GD::Image->new($width,$height,GD::Image->trueColor(0));
my $black=  $image->colorAllocate(0,0,0);
my $blue =  $image->colorAllocate(0,128,255);
my $white = $image->colorAllocate(255,255,255);
$image->transparent($black);
my $gifdata = $image->gifanimbegin(1,0);		  # gifanimbegin([$GlobalCM [, $Loops]])
#$gifdata .= $image->gifanimadd(0,0,0,$delay);
my $pvect1 = new PolyVectors(-10,0,-3,7,-3,3,10,3,10,-3,-3,-3,-3,-7);
my $pvect2 = new PolyVectors();
my $psize = $pvect1->maxsize;
for my $i (1..$frames){
	$pvect2->copyfrom($pvect1);
	$pvect2->mul($pmodul);
	my $angle = 90*cos($i*2*(PolyVectors->PI)/$frames)+90;
	print "i:$i, a=$angle\n";
	$pvect2->rot($angle);
	$pvect2->div($psize*$pmodul/$polybase);
	$pvect2->move($cx,$cy);

	my $frame = GD::Image->new($image->getBounds);
	$frame->transparent($black);
	$frame->filledPolygon($pvect2,$blue);
	
	$gifdata .= $frame->gifanimadd(0,0,0,$delay,1); # gifanimadd([$LocalCM [, $LeftOfs [, $TopOfs [, $Delay [, $Disposal [, $previm]]]]]])
}
print "\n";
$gifdata .= $image->gifanimend();
open(GIF, '>', 'animatedarrow.gif') || die "Can't create file: $!\n'";
binmode(GIF);
print GIF $gifdata;
close(GIF);
exit;

sub ParseOptions{
	my %q;
	my $qs;
	if ($ENV{'REQUEST_METHOD'} eq "GET") { 
		$webmode++;
		$qs = $ENV{'QUERY_STRING'}; 
	}elsif ($ENV{'REQUEST_METHOD'} eq "POST") { 
		$webmode++;
		read(STDIN, $qs, $ENV{'CONTENT_LENGTH'}); 
	}
	if ($webmode){
		my @spq = split (/&/, $qs);
		my $query_key;
		my $query_value;	
		foreach my $spi (@spq) {
			($query_key, $query_value) = split (/=/, $spi);
			$query_value =~ tr/+/ /;
			$query_value =~ s/%([\dA-Fa-f][\dA-Fa-f])/ pack ("C", hex ($1))/eg;
			$q{$query_key} = $query_value;
		}
	}else{
		die `perldoc $progname` if @ARGV==0;
		for (my $i=@ARGV;$i>0;$i--){
			my $option = shift;
			if ($option=~/^-w:(\d+)/){	# parse command line options
				
			}
		}
	}
}


__END__

=head1 SYNOPSIS:

	gifarrow.pl -w:50 -h:50 -f:100

Create 100 freames of animated GIF with 50 pixels width and height.
The same thing to do for WEB mode looks like:

	http://example.com/cgi-bin/gifarrow.pl?w=50&h=50&f=100

=head1 AUTHOR

Copyright (c) 2019, An0ther0ne.
This tool is free software. You can redistribute it and/or modify it under the same terms
as Perl itself.

=head1 SEE ALSO

perl(1), GD::Polygon, GD::Image, GD.


















