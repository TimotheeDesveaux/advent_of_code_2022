#!/usr/bin/env perl

use strict;
use warnings;

my $file = "input.txt";

sub part_one {
    open(INPUT, "<", $file);

    my @stacks = ();
    while (my $line = <INPUT>) {
        if ($line eq "\n") {
            last;
        }
        for (my ($i, $j) = (1, 0); $i <= length($line); ($i, $j) = ($i + 4, $j + 1)) {
            my $crate = substr($line, $i, 1);
            if ($crate =~ /[A-Z]/) {
                unshift(@{$stacks[$j]}, $crate);
            }
        }
    }

    while (my $line = <INPUT>) {
        (my $n, my $from, my $to) = ($line =~ /move (\d+) from (\d+) to (\d+)/);
        for (1..$n) {
            my $crate = pop(@{$stacks[$from - 1]});
            push(@{$stacks[$to - 1]}, $crate);
        }
    }

    my $res = "";
    foreach (@stacks) {
        $res = $res.@{$_}[-1];
    }

    close(INPUT);

    $res;
}

sub part_two {
    open(INPUT, "<", $file);

    my @stacks = ();
    while (my $line = <INPUT>) {
        if ($line eq "\n") {
            last;
        }
        for (my ($i, $j) = (1, 0); $i <= length($line); ($i, $j) = ($i + 4, $j + 1)) {
            my $crate = substr($line, $i, 1);
            if ($crate =~ /[A-Z]/) {
                unshift(@{$stacks[$j]}, $crate);
            }
        }
    }

    while (my $line = <INPUT>) {
        (my $n, my $from, my $to) = ($line =~ /move (\d+) from (\d+) to (\d+)/);
        my @tmp = ();
        for (1..$n) {
            my $crate = pop(@{$stacks[$from - 1]});
            unshift(@tmp, $crate);
        }
        foreach (@tmp) {
            push(@{$stacks[$to - 1]}, $_);
        }
    }

    my $res = "";
    foreach (@stacks) {
        $res = $res.@{$_}[-1];
    }

    close(INPUT);

    $res;
}

print "part one: ", part_one(), "\n";
print "part two: ", part_two(), "\n";
