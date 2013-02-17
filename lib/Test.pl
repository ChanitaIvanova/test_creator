#!/usr/bin/perl
require "C:/Perl/Project/lib/Question.pl";
require "C:/Perl/Project/lib/Answers.pl";
use strict;
use warnings;
use diagnostics;
use utf8;
no warnings 'redefine';
package Test;
#new creates a new test filled
#with open and closed questios
  sub new{
    my $class = shift;
    my $self= { questions => shift};
    bless $self, $class;
    return $self;
  }
#load opens a text file, and from it parses each question
#putting it in an array -@questions, an then creates a
#test from the found questions
  sub load{
    my $address = shift;
    open FILE, $address;
    binmode FILE, ":utf8";
    my $whole_file = join('',<FILE>);
    my @questions;
    my $question;
    while($whole_file =~ m/QU: (.*?) :QUEND/sg){
      $question = OpenQuestion::read($1);
      if(!$question) {
        $question = ClosedQuestion::read($1);
      }
     push(@questions,$question);
    }
    return new Test(\@questions);
  }

#creat_file takes a test and puts in text file 
#each question with a special format so
#later will be easyer the questions to be parsed
  sub creat_file{
    my $self = shift;
    my $address = shift;
    my $array = $self->{questions};
    my($array_answers,$array_correct);
    open FILE,">",$address;
    map{
      if(ref($_) eq ref(new OpenQuestion("",[]))){
        print FILE "QU: Q O: ".$_->{question}." :QOEND \nA O: \n";
        $array_answers = $_->{answers};
        map{
          print FILE "AN: ".$_." :ANEND\n";
        } @$array_answers;
        print FILE " :AOEND :QUEND\n\n";
      }else{
        print FILE "QU: Q C: ".$_->{question}." :QCEND \nA C: \n";
        $array_answers = $_->{answers};
        map{
        print FILE "AN: ".$_." :ANEND\n";
        } @$array_answers;
        print FILE " :ACEND\n C C: ";
        $array_correct= $_->{correct};
        map{
          print FILE $_." ";
        } @$array_correct;
        print FILE " :CCEND :QUEND\n\n";
      }
    } @$array;
    close FILE;
  }
 1;