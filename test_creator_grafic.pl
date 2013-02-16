#!/usr/local/bin/perl
use strict;
use warnings;
use diagnostics;
use Tk; 
require "C:/Perl/Project/lib/create.pl";
require "C:/Perl/Project/lib/generate.pl";
require "C:/Perl/Project/lib/start.pl";
our $root = new MainWindow(-title=> "Test Creator");
my $f1=$root->Frame(
    -background => "red");
$f1->pack(-expand => 1,-fill => 'both',-side=>'bottom');
my $btn_start = $root->Button(-text =>"Start",-command=>sub{start($root,\$f1)});
$btn_start->pack(-fill=>'x');
my $btn_create = $root->Button(-text =>"Create",-command=>sub{create($root,\$f1)});
$btn_create->pack(-fill=>'x');
my $btn_generate = $root->Button(-text =>"Generate",-command=>sub{generate($root,\$f1)});
$btn_generate->pack(-fill=>'x');
my $menu= $root->Menu();
$root->configure(-menu=>$menu);

sub exiting{
  exit(0);
}
my $file_menu = $menu-> cascade(-label=>"File", -underline=>0, -tearoff => 0);
my $help_menu = $menu->cascade(-label =>"Help", -underline=>0, -tearoff => 0);


$file_menu->command(
              -label     => "New...",
              -command   => {},
              -underline => 0);
$file_menu->command(
              -label     => "Start...",
              -underline => 0);
$file_menu->command(
              -label     => "Close",
              -command   => {},
              -underline => 0);
$file_menu->separator();
$file_menu->command(
              -label     => "Save",
              -command   => {},
              -underline => 0);
$file_menu->command(
              -label     => "Save As...",
              -command   => {},
              -underline => 5);
$file_menu->separator();
$file_menu->command(
              -label     => "Exit",
              -command   => \&exiting,
              -underline => 3);

$help_menu->command(
              -label     => "Help",
              -command   => {},
              -underline => 0);
MainLoop;
#"EOF test_creator_grafic.pl"