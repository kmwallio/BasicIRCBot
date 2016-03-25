# Basic Bot

Just an example of using Acme::Skynet with Net::IRC::Bot and some other things we found on the Internet.

This code is very much under development at the moment.  All of this is an attempt to learn and play with Perl 6.

### Notes of Interest (or Observations)

#### Pop

You might notice the pop command has 6 training points (at this time of writing).  Pop takes one argument, so in total, each training point is 2 words.  With 2 training points (one 'get' example and one 'pop' example), it wasn't enough to learn the command.  So we needed more examples to reinforce it.

#### Push

For the push command, we needed a cue word between the key and value.  The current implementation needs dividing words between arguments.  We could add some tracking to see that the training set only has one word keys.  But this could break something like reminders, where a reminder or time could be a lot of words, and we'd have to make sure the training data covered a wide spectrum so it wouldn't generate that rule.

## Acknowledgements

* [Net::IRC::Bot](https://github.com/TiMBuS/Net--IRC)
* [Text::Markov](https://github.com/bbkr/text_markov)
* [Acme::Skynet](https://github.com/kmwallio/Acme-Skynet)
* [Lingua::Conjunction](https://github.com/zoffixznet/perl6-Lingua-Conjunction)
* [WebService::Food2Fork](https://github.com/kmwallio/p6-WebService-Food2Fork)
