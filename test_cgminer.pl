#!/usr/bin/perl
use strict;
use warnings;

use lib './CGminer/';
use CGminer;
use Data::Dumper;

print Dumper(CGminer::pools());
