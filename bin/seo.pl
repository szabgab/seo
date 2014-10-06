#!perl
use strict;
use warnings;
use 5.010;


# An experimental script to check some SEO features of a single html page
# and to provide some recommendations.
# The actual recommendations (eg. for title length are only experimental here,
# don't take them seriously.
# For now.


use LWP::Simple qw(get);
use Path::Tiny qw(path);
use HTML::TreeBuilder::XPath;

my $url = shift or die "Usage: $0 [URL|FILE]\n";
main($url);
exit;


sub main {
	my ($url) = @_;
	my $html;
	
	if ($url =~ m{^https?://}) {
		$html = get $url;
	} else {
		$html = path($url)->slurp_utf8;
	}
	
	my $tree= HTML::TreeBuilder::XPath->new;
	$tree->parse($html);
	
	say 'Checking title';
	my $title = $tree->findvalue( '/html/head/title');
	my $TITLE_MAX = 100;
	my $TITLE_MIN = 30;
	if (not $title) {
		_warn('<title> not found or empty');
	} elsif (length $title > $TITLE_MAX) {
		_warn("<title> might be too long to be effective (should be < $TITLE_MAX)");
	} elsif (length $title < 30) {
		_warn("<title> might be too short to be effective (should be > $TITLE_MIN)");
	}
	# TODO textual analyzis, eg. word count ?
	#say $title;
}

sub _warn {
	my ($text) = @_;
	say "WARN $text";
}
