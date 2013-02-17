#!/usr/local/bin/perl
require "C:/Perl/Project/lib/generate_test.pl";
use strict;
use warnings;
use diagnostics;
use Tk; 
use Data::Dumper qw/Dumper/;

sub generate{
	my $root = shift;
	my $f1 = shift;
	if($$f1) {$$f1->destroy();
		$$f1=undef;
	}
	$$f1=$root->Frame(
		-background => "red");
	$$f1->pack(-expand => 1,-fill => 'both',-side=>'bottom');
	my $variable=0;
	my $entry1 = $$f1->Entry(
		-textvariable =>\$variable,
		-justify => 'left',
		-width=> 10);
	$entry1->pack(-side=>'top',-padx=>0, -pady=>10);
	my $variable2="Title";
	my $entry2 = $$f1->Entry(
		-textvariable =>\$variable2,
		-justify => 'left',
		-width=> 10);
	$entry2->pack(-side=>'top',-padx=>0, -pady=>10);
	my $directory_from; 

	my $from_button = $$f1->Button(
		-text =>"From Test"
	);
	$from_button->pack(-side=>'top',-padx=>0, -pady=>0);
	$from_button->configure(-command=>sub{$directory_from = $from_button->getOpenFile();});
	$$f1-> Entry(-textvariable =>\$directory_from,-state=>'disabled',-width=> 15) -> pack(-side=>'top',-padx=>0, -pady=>2);
	my $to_button = $$f1->Button(
		-text =>"Save Test In"
	);
	$to_button->pack(-side=>'top',-padx=>0, -pady=>0);
	my $directory_to;  
	$to_button->configure(-command=>sub{$directory_to = $to_button->getSaveFile();});
	$$f1-> Entry(-textvariable =>\$directory_to,-state=>'disabled',-width=> 15) -> pack(-side=>'top',-padx=>0, -pady=>2);
	my $answers_button = $$f1->Button(
		-text =>"Save Answers In"
	);
	$answers_button->pack(-side=>'top',-padx=>0, -pady=>0);
	my $directory_answers="";  
	$answers_button->configure(-command=>sub{$directory_answers = $answers_button->getSaveFile();});
	$$f1-> Entry(-textvariable =>\$directory_answers,-state=>'disabled',-width=> 15) -> pack(-side=>'top',-padx=>0, -pady=>2);
	my $save_button = $$f1->Button(
		-text =>"Save "
	);
	$save_button->pack(-side=>'top',-padx=>0, -pady=>10); 
	$save_button->configure(-command=>sub{
		if(!$directory_from){
			$$f1 -> messageBox(-message=>"You have not choosen a test!\n",-type=>'ok',-icon=>'warning');
			return;}
		if(!$directory_to){
			$$f1 -> messageBox(-message=>"You have not pointed where \nto be saved the test!\n",-type=>'ok',-icon=>'warning');
			return;}
		my $count = \$variable;
		my $title = \$variable2;
		generate_test($directory_from,$directory_to,$directory_answers,$$title,$$count);
		$$f1->destroy();
		$$f1 = undef;});
		
	}