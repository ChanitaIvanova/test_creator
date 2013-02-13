
#!/usr/bin/perl
use strict;
use warnings;
package OpenQuestion;
#use Data::Dumper qw/Dumper/;
  sub new{
    my $class = shift;
    my $self = {
        question => shift,
        answers  => shift
    };
    bless $self, $class;
    return $self;
  }  

  sub OpenQuestion::read{
    my $string = shift;
    my ($question,$answers_part);
    if($string =~ m/Q O: (.*?) :QOEND/s) { 
      $question = $1; 
    }
    if($string =~ m/A O: (.*?) :AOEND/s) { 
       $answers_part = $1;
    }
    #print Dumper($question);
    #print Dumper($answers_part);
    if(!($question ) or !($answers_part)){ return ; }
    my $answers = [];
    while($answers_part =~ m/AN: (.*?) :ANEND/sg) {
      push(@$answers,$1);
    } 
    return new OpenQuestion($question,$answers);
  }



package ClosedQuestion;
  sub new{
    my $class = shift;
    my $self = {
        question => shift,
        answers  => shift,
	correct => shift
    };
    my $answers_count = ($self->{answers});
    $self->{answers_count} = scalar @$answers_count;
    bless $self, $class;
    return $self;
  }

  sub ClosedQuestion::read{
    my $string = shift;
    my ($question,$answers_part,$correct);
    if($string =~ m/Q C: (.*?) :QCEND/s) { $question = $1; }
    if($string =~ m/A C: (.*?) :ACEND/s) { $answers_part = $1; }
    if($string =~ m/C C: (.*?) :CCEND/s) { $correct = [split(' ', $1)];}
    if(!($question) or !($answers_part)){ return ; }
    my $answers = [];
    while($answers_part =~ m/AN: (.*?) :ANEND/sg) {
      push(@$answers,$1);
    } 
    return new ClosedQuestion($question,$answers,$correct);
  }
package main;
1;
