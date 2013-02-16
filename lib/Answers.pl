#!/usr/bin/perl
use strict;
use warnings;
package List;
#this function compares lists it helps as find out
# if the user has given the correct answers
sub list_compare{
  my $a = shift;
  my $b = shift;
  if(scalar @$a != scalar @$b) { return 0; }
  for( my $i = 0;$i< scalar @$a;$i++){
    if(not(@$a[$i] eq @$b[$i])){
      return 0;
      }
  }
  return 1;
}
package OpenAnswers;
#new creates an object- OpenAnsewrs, it compaers the given answer
#with the possible correct answers and prepaers a positive or negative
#response, depending on the user's answer
  sub new{
   my $class = shift;
   my $question = shift;
   my $answer = shift;
   my ($response);
   
   my $self = {
      tag => 1 };
   my $array = $question->{answers};
   map{ 
      if( $_ eq $answer) 
      {$response = $question->{question}."\nCorrect!\n\n";
      }
      } @$array;
    if (!($response)){
      $self->{tag} = 0;
      $response = $question->{question}."\nWRONG! \nPossible answers:\n\n";
      my $options = 65;
      map{ $response = $response. chr ($options). ": " .$_ . "\n\n" ;
        $options +=1;
      } @$array;
      $response = $response . "Your answer:\n" . $answer ."\n\n";
    }
    
    $self->{response} = $response;
    bless $self, $class;
    return $self;
  }

package ClosedAnswers;
#new creates an object- ClosedAnsewrs, it compaers the given answers
#with the correct answers and prepaers a positive or negative
#response, depending on the user's answer
  sub new{
    my $class = shift;
    my $question = shift;
    my $answers = shift;
    my $self ={ tag => 1};
    my $array = $question->{correct};
    my $array_answers = $question->{answers};
    my $response;
    if (List::list_compare($array,$answers)) {$response = $question->{question}."\nCorrect!\n\n";}
	if(!($response)){
	  $self ->{tag}=0;
	  $response = $question->{question}."\nWRONG! \nCorrect answer/s:\n";
	  for(my $j=0;$j<scalar @$array;$j++){
	    $response = $response.chr(@$array[$j] + 64).": ".@$array_answers[@$array[$j]-1]."\n";}
	  $response = $response . "\n\nYour answer/s:\n";
	  for(my $j=0;$j<scalar @$answers;$j++){
	    $response = $response.chr(@$answers[$j] + 64).": ".@$array_answers[@$answers[$j]-1]."\n";}
	 }
    $self->{response} = $response;
    bless $self, $class;
    return $self;
  }
package main;
1;