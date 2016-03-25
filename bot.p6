#!/usr/bin/env perl6
use v6;
use Acme::Skynet;
use Net::IRC::Bot;
use Net::IRC::Modules::Autoident;
use Text::Markov;
use Lingua::Conjunction;

my $nick = 'BottyBot';
my $channel = '#hashtag';
my $server = 'irc.freenode.net';

my $brain = Intent.new(True);
my %memory;
my %kv;
my %observations;

sub is-a(@args, $context) {
  my $key = @args[1];
  my $value = @args[0];
  %memory.push: ($key => $value);
  $context.msg($context.who<nick> ~ ": I'll remember '" ~ $value ~ "' is '" ~ $key ~ "'.");
}

$brain.add(&is-a, "remember boys are dumb", "boys", "dumb");
$brain.add(&is-a, "remember kim is a woman", "kim", "a woman");
$brain.add(&is-a, "remember that jacob is a man", "jacob", "a man");

sub what-was(@args, $context) {
  my $key = @args[0];
  if (%memory{$key}:exists) {
    my $possible = conjunction(%memory{$key});
    my $isa = (%memory{$key}.elems == 1) ?? " is " !! " are ";
    $context.msg($context.who<nick> ~ ": " ~ $possible ~ $isa ~ $key ~ ".");
  } else {
    $context.msg($context.who<nick> ~ ": I got nothing on that.");
  }
}

$brain.add(&what-was, "who's dumb", "dumb");
$brain.add(&what-was, "who are weird", "weird");
$brain.add(&what-was, "who was smart", "smart");
$brain.add(&what-was, "what's sideways", "sideways");
$brain.add(&what-was, "what was down", "down");

sub key-in(@args, $context) {
  my $key = @args[1];
  my $value = @args[0];
  %kv.push: ($key => $value);
  $context.msg("Got: " ~ $value);
}

$brain.add(&key-in, "push lizards on reptiles", "lizards", "reptiles");
$brain.add(&key-in, "put mice in rodents", "mice", "rodents");
$brain.add(&key-in, "push legs on win", "legs", "win");
$brain.add(&key-in, "put dogs in mammals", "dogs", "mammals");

sub pop-out(@args, $context) {
  my $key = @args[0];
  if (%kv{$key}:exists) {
    my $val = %kv{$key}.pop();
    $val = ($val) ?? $val !! "Nil";
    $context.msg($context.who<nick> ~ ": " ~ $val);
  } else {
    $context.msg($context.who<nick> ~ ": Nil");
  }
}

$brain.add(&pop-out, "pop trike", "trike");
$brain.add(&pop-out, "pop fish", "fish");
$brain.add(&pop-out, "get losers", "losers");
$brain.add(&pop-out, "pop corn", "corn");
$brain.add(&pop-out, "get hyped", "hyped");
$brain.add(&pop-out, "get fun", "fun");

sub roll($context) {
  $context.msg($context.who<nick> ~ " rolls " ~ [1..20].pick(1));
}

$brain.add(&roll, "roll die");
$brain.add(&roll, "roll");

sub wwjs (@args, $context) {
  my ($jesus, @sin) = @args[0].split(/\s+/);
  if (%observations{$jesus}:exists) {
    $context.msg('"' ~ %observations{$jesus}.read([8..12].pick(1)[0]) ~ '" -- ' ~ $jesus);
  }
}

$brain.add(&wwjs, "what would jesus say", "jesus");
$brain.add(&wwjs, "what's something miles says", "miles");
$brain.add(&wwjs, "what's something josh would say", "josh");

sub thanks($context) {
  my @responses = "you're welcome", "no, thank you", "don't mention it", "it was nothing";
  $context.msg($context.who<nick> ~ ": " ~ @responses.pick(1));
}

$brain.add(&thanks, "thanks");
$brain.add(&thanks, "thank you");
$brain.add(&thanks, "thank you very much");

sub help($context) {
  my @response = "Help:", "roll - roll a 20 sided die", "remember <value> is <key> - store information", "what is <key> - get values stored in key", "push <value> on <key> - push on stack", "pop <key> - pop from stack", "what would <nick> say - random sentence from previoud responses";
  for @response -> $line {
    $context.msg($line);
  }
}

$brain.add(&help, "help");
$brain.add(&help, "what can you do");
$brain.add(&help, "your capabilities");
$brain.add(&help, "are you a bot");

$brain.learn();

class BasicBot {
  multi method said ($e) {
    my $input = $e.what;
    if ($input ~~ m:i/^$nick/) {
      $input ~~ s:i/^$nick\s*':'?\s*//;
      $input ~~ s:g/'.'|','|'?'|'"'|'!'|'|'|'$'//;
      $brain.hears($input.lc, $e);
    } else {
      if (%observations{$e.who<nick>}:exists) {
        %observations{$e.who<nick>}.feed($e.what.split(/\s+/));
      } else {
        %observations{$e.who<nick>} = Text::Markov.new;
        %observations{$e.who<nick>}.feed($e.what.split(/\s+/));
      }
    }
  }
}

Net::IRC::Bot.new(
       nick     => $nick,
       server   => $server,
       channels => $channel,
       modules  => (
               BasicBot.new()
       ),
).run;
