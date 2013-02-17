#!/usr/local/bin/perl
use strict;
use warnings;
use diagnostics;
use Tk; 
use Tk::Help;
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
$root -> bind('<Key-F1>', sub {showhelp();});
sub exiting{
  exit(0);
}
my $file_menu = $menu-> cascade(-label=>"File", -underline=>0, -tearoff => 0);
my $help_menu = $menu->cascade(-label =>"Help", -underline=>0, -tearoff => 0);


$file_menu->command(
              -label     => "Start",
              -command   => sub{create($root,\$f1)},
              -underline => 0);
$file_menu->command(
              -label     => "Start",
              -command   => sub{start($root,\$f1)},
              -underline => 0);
$file_menu->command(
              -label     => "Generate",
              -command   => sub{generate($root,\$f1)},
              -underline => 0);
$file_menu->separator();
$file_menu->command(
              -label     => "Exit",
              -command   => \&exiting,
              -underline => 3);

$help_menu->command(
              -label     => "Help",
              -command   => sub {showhelp();},
              -underline => 0);
MainLoop;
sub showhelp {
        my @helparray = ([{-title  => "Test Crator Help",
                           -header => "Test Creator Help",
                           -text   => "This will help you use Test Creator.\nChoose the option you would like to learn about."}],
                         [{-title  => "start",
                           -header => "\n\nIf you've pressed start you should be seing one entry, a button \"Browse\" and a button \"Test\"",
                           -text   => ""},
                          {-title  => "The Entry",
                           -header => "Entry",
                           -text   => "Thru the entry you could choose how many questions from the test to be taken.
In the begining in the entry there is the value 0 you could change it if you want.If you don't or you give a 
greater value then the number of questions in the test, the value will be set to the number of questions in the test."},
                          {-title  => "Button Browse",
                           -header => "Browse",
                           -text   => "You choose the test that will be started."},
                          {-title  => "Button Test",
                           -header => "Test",
                           -text   => "Starts the testing."}],
                         [{-title  => "create",
                           -header => "\n\nStarts the creation of a test.",
                           -text   => ""},
                          {-title  => "Button Save Question",
                           -header => "Save Question",
                           -text   => "Adds the question you've crated to the test."},
                          {-title  => "Button Open Question",
                           -header => "Open Question",
                           -text   => "Starts the crating of an open question."},
                           {-title  => "Button Closed Question",
                           -header => "Closed Question",
                           -text   => "Starts the crating of a closed question."},
                           {-title  => "Button Finish",
                           -header => "Finish",
                           -text   => "Saves the test in the directory you've choosen."}],
                           [{-title  => "generate",
                           -header => "\n\n Starts the crating of a text file with questions from a test you've choosen.",
                           -text   => ""},
                          {-title  => "Entry Count",
                           -header => "Count",
                           -text   => "By passing a number in the top entry you could choose how many questions
to be printed in the text file."},
                          {-title  => "Entry Title",
                           -header => "Title",
                           -text   => "By passing a text to this entry you could set a title for the test."},
                           {-title  => "Button From Test",
                           -header => "From Test",
                           -text   => "You choose from which test to crate a text file."},
                           {-title  => "Button Save Test In",
                           -header => "Save Test In",
                           -text   => "Saves the text file in the directory and under the name you've choosen."},
                           {-title  => "Button Save Answers In",
                           -header => "Save Answers In",
                           -text   => "This button is optional. You could choose a file where to save
the corresponding answers to the questions saved in the text file."}]);

        #my $helpicon = $main->Photo(-file => "/path/to/some/gif/or/bmp");
        my $help = $root->Help(
                               -title    => "My Application - Help",
                               -variable => \@helparray);
    }
#"EOF test_creator_grafic.pl"