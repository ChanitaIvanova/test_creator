#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
require "./lib/Test.pl";
use Data::Dumper qw/Dumper/;
package TestCreatorInterface;
require "./lib/generate_test.pl";
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
use Getopt::Long;
use Pod::Usage;
#execute parses the line given
#from STDIN and executes the corresponding command
  sub execute{
    my $line = shift;
      if($line =~ m/^create\s+(.+)\s*$/) { 
        return creat_test($1);}
      if($line=~ m/^start\s+(.+?)\b\s*(\d*)\s*$/) {
        if ($2) {  return test(Test::load($1),$2);}
        else{return test(Test::load($1));}}
      if($line=~ m/^generate\s+(.+?)\b\s*(\d*)\s*$/ ){
        #print Dumper($1,$2);
        if($2){ return generate($1,$2);}
        else{return generate($1);}
      }
      if($line eq 'help') {pod2usage(-verbose => 2,-exitval=>'NOEXIT' ); return; }
      if($line eq 'exit') { exit(0); }
      print "Not valid command! Try typeing 'help'\n";
  }
#create_test takes questions and answers from the
#command line and creates closed or open questions
#withch are put in a test and the test is saved in the given
#directory
  sub creat_test{
    my $address = shift;
    my @questions;
    print "When you've given all the answers you wanted write
\"last\" as an answer and you will go back to creating your next question
or you will have to write witch are the correct answers if you are craeting
an closed question.
Write help for other information.\n";
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
        when m/\s*help\s*/ {pod2usage(-verbose => 2,-exitval=>'NOEXIT' );}
        when m/\s*exit\s*/ { exit(0);}
        default {print "Not valid command! Try typeing 'help'\n";}
      }
    }
  }
  #with this function the user could create a closed question
  #the user inputs a question, answers and correct answers
  #and the function creates a ClosedQuestion to put in the test
  #that the user is creating
  sub creat_closed_question{
    print "Write question:\n" ;
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
      if($line=~ m/last/) { last;}
      push(@$answers,$line);
    }
    print "Correct answers\n";
    $line = <>;
    chomp $line;
    my @correct = split(/,* */,$line);
    @correct = map{
    (ord $_) - 64} @correct;
    return new ClosedQuestion($question,$answers,\@correct);
  }
  #with this function the user could create an open question
  #the user inputs a question and possible answers 
  #and the function creates an OpenQuestion to put in the test
  #that the user is creating
  sub creat_open_question{
    print "Write question:\n"; 
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
  #open_ask is given an open question
#it prints the question 
#and takes the user's answer
#then it produces an OpenAnswer
#so that a response could be given to the user
  sub open_ask{
    my $open = shift;
    print $open->{question}."\n";
    my $line =<>;
    chomp $line;
    return (new OpenAnswers($open,$line));
  }
#closed_ask is given a closed question
#it prints the question and the answers
#so that the user could see them
#and takes the user's answer
#then it produces a ClosedAnswer
#so that a response could be given to the user
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
 #ask helps find out what kind of question
#is going to be asked the user -open or closed
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
    if ((!$count) or ($count > (scalar @$array_questions))){
      $count = (scalar @$array_questions);}
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
    my $title =<>;
    chomp $title;
    print "Address for the test: ";
    my $address_test =<>;
    chomp $address_test;
    print "Address for the answers: ";
    my $line =<>;
    chomp $line;
    generate_test($address,$address_test,$line,$title,$count);
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
__END__;
=head1 NAME

    Test Creator - A program to help you create tests and test your 
   knowledge on allready existing tests.


=cut

=head1 SYNOPSIS

      Test Creator helps you create tests, with witch later you could
    test yours or someone else's knowledge or you could create text 
    files with questions from the tests and text files with the 
    corresponding answers to those questions.


=cut

=head1 OPTIONS



=head2 - create DIRECTORY

      With this you create new test in DIRECTORY 
        (you should append the name of the test to DIRECTORY)
      
   Here you have four options:
   
=over 12

=item B<closed>  

Starts the creation of a closed question.
   
=item B<open>  

Starts the creation of an open question.
   
=item B<finish>  

Saves the test you've created!
   
=item B<exit>   

Exits the program without saving the test.

  
=back

=cut



=head2 - start DIRECTORY [COUNT]

        With this you start the test pointed thru DIRECTORY 
      if you have pointed a COUNT- this number of questions 
      will be taken from the test.

=cut
=head2 - generate DIRECTORY [COUNT]

        With this you generate a test in a text file pointed thru DIRECTORY 
      if you have pointed a COUNT- this number of questions 
      will be taken from the test and put in the text file.

=cut

