#!/usr/bin/perl
require "./Question.pl" ;
require "./Answers.pl"  ;
use strict;
use warnings;
package Test;
  #attr_reader :questions
  sub new{
    my $class = shift;
    my $self= { questions => shift};
    bless $self, $class;
    return $self;
  }

  sub load{
    my $address = shift;
    open FILE, $address;
    my $whole_file = join('',<FILE>);
    my $questions=[];
    my $question;
    while($whole_file =~ m/QU: (.*?) :QUEND/sg)
    {$question = OpenQuestion::read($1);
	if(!$question) {
	   $question = ClosedQuestion::read($1);
	 }
     push(@$questions,$question);
     }
    return new Test($questions);
  }

  sub creat_file{
    my $self = shift;
    my $address = shift;
    my $array = $self->{questions};
    my($array_answers,$array_correct);
    open FILE,">>",$address;
    map{
      if(ref($_) eq ref(new OpenQuestion("",[])) ){
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
  }
#test = Test.load('C:\Ruby193\Project\Test.tst.txt')
#puts test.questions
#test.questions.map{|x| puts x.question}
#test.creat_file('C:\Ruby193\Project\Test2.txt')
#test2 = Test.load('C:\Ruby193\Project\Test2.txt')
#test.questions.map{|x| puts x.question}