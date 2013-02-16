#!/usr/local/bin/perl
#require 'C:\Perl\Project\Question.pl';
require "C:/Perl/Project/lib/Test.pl";
use strict;
use warnings;
use Tk;
use Data::Dumper qw/Dumper/;

our (@answers,@questions,$correct,$tag,$f2,$f1,$directory,$variable1);
sub more_entrys{
  my $variable2="Answer";
  my $entry = $f2->Entry(-textvariable =>\$variable2);
    $entry ->pack(-fill => 'both');
  
  push(@answers,\$variable2);
}

sub correct_entrys{
  my @buttons = @_;
 $correct = "Correct";
  map{ $_->destroy(); } @buttons;
  my $entry = $f2->Entry(-textvariable =>\$correct);
    $entry ->pack(-fill => 'both',-padx=>0, -pady=>10);
  
}

sub closed{
  my $root=shift;
  @answers = ();
  
  
 # buttons.map! { |x| x.destroy }
  if($f2){
    $f2->destroy();
    $f2=undef;} 
    $tag = 1;
  $f2 = $root->Frame( 
    -background=> "green");
    $f2->pack(-expand => 1,-fill => 'both',-side=>'top');
  $variable1="Question";
  my $entry1 = $f2->Entry( 
    -textvariable => \$variable1,
    -justify=> 'left',
    -width =>25);
    $entry1->pack(-fill => 'both',-side=>'top');
  
 my $variable2 = "Answer";
  
  my $entry2 = $f2->Entry(
    -justify =>'left',
    -width=> 25,
    -textvariable =>\$variable2);
    $entry2->pack(-fill => 'both',-side=>'top');

  push(@answers,\$variable2);
  
 my $more = $f2-> Button( 
    -text=> "More Answers" ,
    -command =>sub {more_entrys();});
    $more->pack(-side=>'bottom',-padx=>0, -pady=>10);  
  

 my $correct_button = $f2->Button( 
    -text=> "Correct Answers" ,
    );
    $correct_button->pack(-side=>'bottom',-padx=>0, -pady=>10); 
    $correct_button->configure(-command => sub{
    correct_entrys($correct_button,$more);});  
   
  #correct = []
  #$correct_button->{-command}=sub{ \&correct_entrys(\$correct_button,\$more);};
}


sub open_question{
  my $root = shift;
  @answers = ();
  
  $tag = 0;
 # buttons.map! { |x| x.destroy }
  if($f2){
    $f2->destroy();
    $f2=undef; } 
  $f2 = $root->Frame(
    -background=> "green");
    $f2->pack(-expand => 1,-fill => 'both',-side=>'top');
    $variable1="Question";
  my $entry1 = $f2->Entry(
  -textvariable =>\$variable1,
    -justify => 'left',
    -width=> 25);
    $entry1->pack(-fill => 'both',-side=>'top');
  
  my $variable2="Answer";
  my $entry2 = $f2->Entry(
    -justify =>'left',
    -width=> 25,
    -textvariable =>\$variable2);
    $entry2->pack(-fill => 'both',-side=>'top');
 
  push(@answers,\$variable2);
  
 my $more = $f2-> Button( 
    -text=> "More Answers" ,
    -command =>sub {more_entrys();}  );
    $more->pack(-side=>'bottom',-padx=>0, -pady=>10);  
   
}
sub save_question{ 
  print Dumper(@answers);
  @answers=map {$$_} @answers;
  print Dumper(@answers);
    if($tag == 1){ my @correct = split(/,* */,$correct);
                  @correct = map{ord($_) - 64} @correct;
                  my @som_answers = @answers;
                  print Dumper(\@som_answers);
                   push(@questions,(new ClosedQuestion($variable1,\@som_answers,\@correct)));
                    }
               else{
                  if($tag == 0){
                    print Dumper(\@answers);
                    my @som_answers = @answers;
                    print Dumper(\@som_answers);
                    push(@questions,(new OpenQuestion($variable1,\@som_answers)));}
                }
                 $tag = -1;
                 $f2->destroy();
                 $f2=undef;
                 }
sub create{
  my $root = shift;
  @questions=();
  @answers =();
  $tag = -1;
  $f1=shift;
  
  if($$f1) {$$f1->destroy();
    $$f1=undef;
  }
  if($f2) {$f2->destroy();
    $f2=undef;
  }
  $$f1 =$root->Frame(
    -background => "red");
    $$f1->pack(-expand => 1,-fill => 'both');
  my $finish = $$f1->Button(  
    -text =>"Finish"
    );
    $finish->pack(-side=>'bottom',-padx=>0, -pady=>0);
    $finish->configure(-command=>sub{$directory = $finish->getSaveFile();
    print Dumper(@questions);
     my $test = new Test(\@questions);
     print Dumper($test);
    $test->creat_file($directory); 
    $$f1->destroy();
    $$f1=undef;});
  my $closed_button=$$f1->Button(  
    -text => "Closed Question",
    -command=> sub {print Dumper(@questions);
      closed($root); }
    );
    $closed_button->pack(-side=>'bottom',-padx=>0, -pady=>0);   
  

  my $open_button=$$f1->Button( 
    -text => "Opened Question",
    -command=> sub {print Dumper(@questions);
      open_question($root);}
    );
    $open_button->pack(-side=>'bottom',-padx=>0, -pady=>0);    

  my $save_button=$$f1->Button(  
    -text=> "Save Qestion", 
    -command=> sub {save_question();});
   $save_button-> pack(-side=>'bottom',-padx=>0, -pady=>0);
 }
 1;