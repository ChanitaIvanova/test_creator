#!/usr/local/bin/perl
require "C:/Perl/Project/lib/Test.pl";
use strict;
use warnings;
use Data::Dumper qw/Dumper/; 
use utf8;
#generate_test take's a text file-$directory_from
#and loads a test, if is given $count it randomly takes
#count questions and prints them in a file -$director_to,
#if $count is not given or is more then the questions in the test
#all the questions randomly are printed in the file. 
#If is given Title its printed in the begining of 
#the file. if is given $directory_answers the corresponding
#answers to the questions written in the file are written
#to $directory_answers
sub generate_test{
  my $directory_from = shift;
  my $directory_to = shift;
  my $directory_answers=shift;
  my $title=shift;
  my $count = shift;
  my $test = Test::load($directory_from);
  #print Dumper($test);
  my $array_questions = $test->{questions};
  if ((!$count) or ($count > (scalar @$array_questions))){
  $count = (scalar @$array_questions);}
   my @test_questions;
   map{ push(@test_questions,$_ );} @$array_questions;
   #print $directory_to;
   open FILE,">". $directory_to or die $!;
   #print Dumper($directory_to,$count);
   #print Dumper($directory_answers);
   binmode FILE, ":utf8";
   print FILE $title."\n\n\n";
   if($directory_answers){
     open FILE2,">". $directory_answers or die $!;
     binmode FILE2, ":utf8";
     print FILE2 $title."\n\n\n";}
   for(my $i=1;$i<=$count;$i++){
    my $index = rand(scalar @test_questions);
    my $question = $test_questions[$index];
    splice(@test_questions,$index,1);
    print FILE $i.": ".$question->{question}."\n";
    if($directory_answers){
      print FILE2 $i.": ".$question->{question}."\n";}
    if (ref($question) eq ref(new ClosedQuestion("",[],[]))){
      my $options = 65;
      my $possible_answers = $question->{answers};
      for(my $j=0;$j<$question->{answers_count};$j++){
        print FILE chr($options).": ".@$possible_answers[$j]."\n";
        $options++;
      }
      if($directory_answers){
        my $correct_answers = $question->{correct};
        for(my $j=0;$j<scalar @$correct_answers;$j++){
           print FILE2 chr(@$correct_answers[$j]+64)." ";}
        print FILE2 "\n\n";
      }
      print FILE "\n\n";
    }
    else{
      if($directory_answers){
        my $correct_answers = $question->{answers};
        my $options = 65;
        for(my $j=0;$j<scalar @$correct_answers;$j++){
           print FILE2 chr($options).": ".@$correct_answers[$j]."\n";
           $options++;}
        print FILE2 "\n";
      }
      print FILE "\n\n\n\n";}
    }
    if($directory_answers){close FILE2;}
    close FILE;
  }
  1;