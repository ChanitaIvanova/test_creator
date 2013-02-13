#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
require "./test.pl";
#require './generate_test';
package TestCreatorInterface;

use Switch 'Perl6';
sub creat_test;
sub creat_closed_question;
sub creat_open_question;
sub open_ask;
sub closed_ask;
sub ask;
sub test;
sub generate;
sub run;
  sub execute{
    my $line = shift;
      if($line =~ m/^creat\s+(.+)\s*$/) { 
        return creat_test($1);}
      if($line=~ m/^start\s+(.+?)\s*(\d*)\s*$/) {
        
        if ($2) {  return test(Test::load($1),$2);}
        else{
        return test(Test::load($1));}}
      if($line=~ m/^generate\s+(.+?)\s*(\d*)\s*$/ ){
        if (!$2) { return generate($1,$2);}
        else{
        return generate($1);}
      }
      if($line eq 'help') { }
      if($line eq 'exit') { exit(0); }
      print "Not valid command! Try typeing \'help\'\n";
   
  }

  sub creat_test{
    my $address = shift;
    my @questions ;
    while(1) {
      print '~~';
      my $line =<>;
      chomp $line;
      given $line {
        when m/\s*closed\s*/ { push(@questions,creat_closed_question);}
        when m/\s*open\s*/ {push(@questions,creat_open_question);}
        when m/\s*finish\s*/ { 
           my $test = new Test(\@questions); 
          return $test->creat_file($address); }
        when m/\s*exit\s*/ { exit(0);}
        default {print "Not valid command! Try typeing \'help\'\n";}
        }
      }
  }
  
  sub creat_closed_question{
    print "Write question:\n~~" ;
    my $line =<>;
     chomp $line;
     my $question =  $line;
    print "Write Answers:\n";
    my $options = 65;
    my $answers=[];
    while(1) {
      print chr($options).": ";
      $options++;
      $line =<>;
      chomp($line);
     
      if ($line=~ m/last/) { last;}
      
      push(@$answers,$line);
    }
    print "Correct answers\n~~";
    $line = <>;
    chomp $line;
    my @correct = split(/,* */,$line);
    @correct = map{
    (ord $_) - 64} @correct;
    return new ClosedQuestion($question,$answers,\@correct);
  }
  
  sub creat_open_question{
    print "Write question:\n~~"; 
    my $line =<>;
     chomp $line;
     my $question = $line;
    print "Write Answers:\n";
    my $options = 65;
    my @answers;
    while(1) {
      print chr($options).": ";
      $options++;
      $line =<>;
      chomp $line;
      if( $line eq 'last') {last;}
      push(@answers,$line);
    }
    return (new OpenQuestion($question,\@answers));
  }

  sub open_ask{
    my $open = shift;
    print $open->{question}."\n";
    my $line =<>;
    chomp $line;
    return (new OpenAnswers($open,$line));
  }

  sub closed_ask{
    my $closed = shift;
    print $closed->{question}."\n";
    my $options = 65;
    my $array_answers = $closed->{answers};
    map{ print chr($options).": " .$_. "\n"; 
       $options++;
     } @$array_answers;
    my $line =<>;
    chomp $line;
    my @user_answers= split(/,* */, $line);
    @user_answers = map{ord($_) - 64} @user_answers;
    return (new ClosedAnswers($closed,\@user_answers));
  }
  
  sub ask{
    my $question = shift;
    if (ref($question) eq ref(new ClosedQuestion("",[],[]))){return closed_ask($question);}
    return open_ask($question);
  }

  sub test{
    my $test = shift;
    my $count = shift;
    my $array_questions = $test->{questions};
    my $question;
    if ((!$count) or ($count > (scalar @$array_questions))){$count = (scalar @$array_questions);}
    my @test_questions;
    my @answers;
    map{ push(@test_questions,$_ );} @$array_questions;
    for(my $i =1;$i<=$count;$i++)
    { print $i.": ";
      my $index = rand(scalar @test_questions);
      $question = $test_questions[$index];
      splice(@test_questions,$index,1);
      my $answer = ask($question);
      push(@answers,$answer);
    }
    my $wrong = 0;
    for(my $i=0;$i<scalar @answers;$i++){ 
      my $l = $i +1;
      print $l.". ".$answers[$i]->{response};
      if (!($answers[$i]->{tag})){$wrong++;}
    }
    print "You gave ".($count - $wrong)." correct answers and ".$wrong." wrong answers!\n";
  }

  sub generate{
    my $address = shift;
    my $count = shift;
    print "Title of the test: ";
    my $line =<>;
    my $title = chomp $line;
    print "Address for the test: ";
    $line =<>;
    my $address_test = chomp $line;
    print "Address for the answers: ";
    $line =<>;
    my $address_answers = chomp $line;
    my $test = Test::load($address);
    #Generate::create($test,$count,$address_test,$address_answers,$title);
  }

  sub run{
    while(1) {
      print '>> ';
      my $line =<>;
      chomp($line);
      execute($line);
    }
  }
run;
