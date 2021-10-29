#!/usr/bin/env perl

use strict;
use warnings;
use Test2::V0;
use Test2::Tools::Explain;

# simple checks.
my $data = <<"EOF";
# 1
44447600
44447600
55777660
55999990
85993333
81113222
88813222
88811122
# 2
88883333
88003222
88003222
99011122
99016665
91116755
94444755
94444777
EOF

subtest formatting => sub {
  # entries are separated by a comment of some sort.
  my %entries;
  my $key;
  foreach my $entry_line (split (/\n/, $data)) {
    if($entry_line =~ /#\s+(\d)+/) {
      $key = "entry_$1";
      next;
    }
    push @{$entries{$key}}, $entry_line;
  }

  is (scalar keys  %entries, 2, "we have the correct number of entries") or diag explain \%entries;
  foreach my $key (keys %entries) {
    my $entry = $entries{$key};
    is (scalar @$entry, 8, "entry has 8 lines") or diag explain $entry;
    foreach my $line (@$entry) {
      like ($line, qr/^\d{8}$/, "each entry line is 8 digits");
    }
  }
};

# do we have 0 through 9 represented in the right numbers??
subtest simple_checks => sub {
  my $check = hash{
    field "0" => 6;
    field "1" => 7;
    field "2" => 8;
    field "3" => 6;
    field "4" => 8;
    field "5" => 5;
    field "6" => 4;
    field "7" => 5;
    field "8" => 8;
    field "9" => 7;
    end;
  };

  foreach my $key (keys %entries) {
    my $entry = $entries{$key};
    my %sizes;
    foreach my $line (@$entry) {
      my @digits = split(//, $line);
      $sizes{"$_"}++ foreach @digits;
    }

    is (\%sizes, $check, "correct counts for each piece");
  }
};

done_testing();
