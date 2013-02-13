#!/usr/bin/perl
use strict;
use warnings;
package List;
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
      {$response = "Correct!\n\n";
      }
      } @$array;
    if (!(($response))){
      $self->{tag} = 0;
      $response = "WRONG! \nPossible answers:\n\n";
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
  sub new{
    my $class = shift;
    my $question = shift;
    my $answers = shift;
    my $self ={ tag => 1};
    my $array = $question->{correct};
    my $response;
    if (List::list_compare($array,$answers)) {$response = "Correct!\n\n";}
	if (!(defined( $response))){
	  $self ->{tag}=0;
	  $response = "WRONG! \nCorrect answer/s:\n";
	  $response = $response . join(", ",@$array);  
	  $response = $response . "\n\nYour answer/s:\n" . join(" ",@$answers) . "\n\n";
	 }
    $self->{response} = $response;
    bless $self, $class;
    return $self;
     }
package main;
1;