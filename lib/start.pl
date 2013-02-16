#!/usr/local/bin/perl
require "C:/Perl/Project/lib/Test.pl";
use strict;
use warnings;
use diagnostics;
use Tk; 
use Data::Dumper qw/Dumper/;
our ($directory,@answers,$count);
sub open_ask;
sub closed_ask;
sub ask;
sub test;
sub start{
  my $root = shift;
  
  my $f1= shift;
  if($$f1) {$$f1->destroy();
    $$f1=undef;
  }
  @answers=(); 
  $$f1=$root->Frame(
    -background => "red");
  $$f1->pack(-expand => 1,-fill => 'both',-side=>'bottom');
  my $variable=0;
  my $entry1 = $$f1->Entry(
  -textvariable =>\$variable,
   -justify => 'left',
   -width=> 10);
   $entry1->pack(-side=>'left',-padx=>0, -pady=>0);
 
  my $browse_button = $$f1->Button(
  -text =>"Browse..."
  );
    $browse_button->pack(-side=>'left',-padx=>5, -pady=>0); 
  
  $browse_button->configure(-command=>sub{$directory = $browse_button->getOpenFile();});
  my $test = $$f1->Button(
  -text =>"Test",
  -command=>sub{test($root,$f1,$directory,\$variable)}
  );
  $test->pack(-side=>'left',-padx=>5, -pady=>0); 
  
}
sub test{
    my $root=shift;
    my $f1=shift;
    my $directory = shift;
    my $test = Test::load($directory);
    $count = shift;
    $count = $$count;
    #print Dumper($count);
    my $array_questions = $test->{questions};
     if($$f1) {$$f1->destroy();
      $$f1=undef;
     }
    $$f1=$root->Frame(
      -background => "red");
    $$f1->pack(-expand => 1,-fill => 'both',-side=>'bottom');
    my $question;
    if ((!$count) or ($count > (scalar @$array_questions))){
      $count = (scalar @$array_questions);}
    my @test_questions;
   
    map{ push(@test_questions,$_ );} @$array_questions;
    my $i=1; 
    my $f2=$$f1->Frame(
      -background => "blue");
    $f2->pack(-expand => 1,-fill => 'both',-side=>'bottom');
    ask($f1,\$f2,$i,\@test_questions);
    
  }
  sub open_ask{
    my $f1=shift;
    my $f2 =shift;
    my $i= shift; 
    my $open = shift;
    my $test_questions=shift;
    if($$f2) {$$f2->destroy();
              $$f2=undef;
            }
    $$f2=$$f1->Frame(
      -background => "blue");
    $$f2->pack(-expand => 1,-fill => 'both',-side=>'bottom');
    $$f2 -> Label(-text=>($i.": ". $open->{question}."\n")) -> pack(-side=>'top',-padx=>0, -pady=>0);
    my $variable="Your Answer";
    my $entry1 = $$f2->Entry(
      -textvariable =>\$variable,
      -justify => 'left',
      -width=> 25);
   $entry1->pack(-side=>'top',-padx=>0, -pady=>10);
   if ($i == $count){
             my $finish = $$f2->Button(
               -text=>"Finish",
               -command=>sub { 
                 my $answer=\$variable;
                 push(@answers,new OpenAnswers($open,$$answer));
                 $$f2->destroy();
                 $$f2=undef;
                 my $wrong = 0;
                 for(my $i=0;$i<scalar @answers;$i++){ 
                  my $l = $i +1;
                  $$f1 -> Label(-text=>$l.". ".$answers[$i]->{response}) -> pack(-side=>'top');
                  if (!($answers[$i]->{tag})){$wrong++;}
                 }
                $$f1 -> Label(-text=>"You gave ".($count - $wrong)." correct answers and ".$wrong." wrong answers!\n") -> pack(-side=>'top');
             });
            $finish->pack(-side=>'top');
   }else{
     my $next = $$f2->Button(
      -text=>"Next",
     );
     $next->configure(-command=>sub{ 
           my $answer=\$variable;
           push(@answers,new OpenAnswers($open,$$answer));
           $i++;
           ask($f1,$f2,$i,$test_questions);}
           );
     $next->pack(-side=>'top');}
  }

  sub closed_ask{
    my $f1=shift;
    my $f2 =shift;
    my $i= shift; 
    my $closed = shift;
    my $test_questions=shift;
     if($$f2) {$$f2->destroy();
              $$f2=undef;
            }
    $$f2=$$f1->Frame(
      -background => "blue");
    $$f2->pack(-expand => 1,-fill => 'both',-side=>'bottom');
    $$f2 -> Label(-text=>($i.": ". $closed->{question}."\n")) -> pack(-side=>'top',-padx=>0, -pady=>0);
    my $options = 65;
    my $array_answers = $closed->{answers};
    my @user_answers;
    my @my_answers;
    my @my_buttons;
    for(my $j=1;$j<=scalar @$array_answers;$j++){
      $my_buttons[$j-1]= $$f2->Checkbutton(
      -text=> chr($options).": " .@$array_answers[$j-1],
      -variable => \$my_answers[$j-1],
      -command=>sub {
                   #push(@user_answers,$my_answers[$j]->get());
      })->pack(-side=>'top',-padx=>0,-pady=>10); 
      $options++;
    } 
    if ($i == $count){
       my $finish = $$f2->Button(
         -text=>"Finish",
         -command=>sub {
                 for(my $j=0;$j<scalar @my_buttons;$j++){
                 if($my_answers[$j]){
                    push(@user_answers,$j+1);
                  }
                 }
                 push(@answers,new ClosedAnswers($closed,\@user_answers));
                 $$f2->destroy();
                 $$f2=undef;
                 my $wrong = 0;
                 for(my $i=0;$i<scalar @answers;$i++){ 
                  my $l = $i +1;
                  $$f1 -> Label(-text=>$l.". ".$answers[$i]->{response}) -> pack();
                  if (!($answers[$i]->{tag})){$wrong++;}
                }
                 $$f1 -> Label(-text=>"You gave ".($count - $wrong)." correct answers and ".$wrong." wrong answers!\n") -> pack(-side=>'top');
          });
       $finish->pack(-side=>'top');
     } 
     else{
        my $next = $$f2->Button(
          -text=>"Next",
        );
        $next->configure(
          -command=>sub{ 
            for(my $j=0;$j<scalar @my_buttons;$j++){
              if($my_answers[$j]){
                push(@user_answers,$j+1);
              }
            }
            push(@answers,new ClosedAnswers($closed,\@user_answers));
            $i++;
            my $answer = ask($f1,$f2,$i,$test_questions);});
      $next->pack(-side=>'top');
     }   
  }
  
  sub ask{
    my $f1=shift;
    my $f2=shift;
    my $i=shift;
    my $test_questions = shift;
    if($$f2) {$$f2->destroy();
              $$f2=undef;
            }
     $$f2=$$f1->Frame(
      -background => "blue");
    $$f2->pack(-expand => 1,-fill => 'both',-side=>'bottom');
    #print Dumper($f1,$i,$test_questions);
    my $index = rand(scalar @$test_questions);
     my $question = $$test_questions[$index];
      splice(@$test_questions,$index,1);
    if (ref($question) eq ref(new ClosedQuestion("",[],[]))){return closed_ask($f1,$f2,$i,$question,$test_questions);}
    return open_ask($f1,$f2,$i,$question,$test_questions);
  }
  1;