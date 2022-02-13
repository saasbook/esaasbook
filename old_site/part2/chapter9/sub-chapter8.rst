Fallacies and Pitfalls
====================================
**Pitfall: Using TDD and CRC to think only tactically and not strategically about design.**

The extreme version of CRC cards seems to fit well with Agile: design and build the simplest 
thing that could possibly work, and embrace the fact that you’ll need to change it later. 
But it’s possible to take this approach too far. One suggestion from accomplished software 
craftsman and engineer John Ousterhout is to “design it twice”: use CRC cards to come up with 
a design, then put it aside and try a different design from scratch, perhaps thinking a bit 
adversarially about how you want to beat the team that did the original design. If you’re 
unable to improve on the original design, you can be more confident that it represents a 
reasonable starting point. But surprisingly often, you’ll find a simpler or more elegant 
design after you’ve had a chance to think through the problem the first time.

**Pitfall: Conjoined Methods**

Ousterhout also advises Ousterhout 2018 warns against creating *conjoined methods*: two 
methods that collaborate tightly in accomplishing one goal, so that there is a lot of 
interaction between them and neither can be effectively understood without also understanding 
the other. This advice is consistent with the SOFA advice that a method should do **O**\ne thing 
(Ousterhout would say that each of the conjoined methods only does part of a thing) but is 
an easy pitfall to experience if you’re overzealous in making methods **S**\hort. One sign of 
this is that it’s nearly impossible to isolate one method from the other in tests; this 
is different from a helper method, which breaks out a well-defined subtask that can be 
individually tested.

**Pitfall: Conflating refactoring with enhancement.**

When you’re refactoring or creating additional tests (such as characterization tests) in 
preparation to improve legacy code, there is a great temptation to fix “little things” along 
the way: methods that look just a little messy, instance variables that look obsolete, dead 
code that looks like it’s never reached from anywhere, “really simple” features that look 
like you could quickly add while doing other tasks. *Resist these temptations!* First, the 
reason to establish ground-truth tests ahead of time is to bootstrap yourself into a position 
from which you can make changes with confidence that you’re not breaking anything. Trying to 
make such “improvements” in the absence of good test coverage invites disaster. Second, as 
we’ve said before and will repeat again, programmers are optimists: tasks that look trivial 
to fix may sidetrack you for a long time from your primary task of refactoring, or worse, may 
get the code base into an unstable state from which you must backtrack in order to continue 
refactoring. The solution is simple: when you’re refactoring or laying groundwork, focus 
obsessively on completing those steps *before* trying to enhance the code.

**Fallacy: It’ll be faster to start from a clean slate than to fix this design.**

Putting aside the practical consideration that management will probably wisely forbid you 
from doing this anyway, there are many reasons why this belief is almost always wrong. First, 
if you haven’t taken the time to understand a system, you are in no position to estimate how 
hard it will be to redesign, and probably will underestimate the effort vastly, given 
programmers’ incurable optimism. Second, however ugly it may be, the current system *works*; a
main tenet of doing short Agile iterations is “always have working code,” and by starting over 
you are immediately throwing that away. Third, if you use Agile methods in your redesign, you’ll 
have to develop user stories and scenarios to drive the work, which means you’ll need to 
prioritize them and write up quite a few of them to make sure you’ve captured at least the 
functionality of the current system. It would probably be faster to use the techniques in this 
chapter to write scenarios for just those parts of the system to be improved and drive new code 
from there, rather than doing a complete rewrite.

Does this mean you should *never* wipe the slate clean? No. As Rob Mee of Pivotal Labs points 
out, a time may come when the current codebase is such a poor reflection of the original 
design intent that it becomes a liability, and starting over may well be the best thing to 
do. (Sometimes this results from not refactoring in a timely way!) But in all but the most 
trivial systems, this should be regarded as the “nuclear option” when all other paths have 
been carefully considered and determined to be inferior ways to meet the customer’s needs.

**Pitfall: Rigid adherence to metrics or “allergic” avoidance of code smells.**

In Chapter 8 we warned that correctness cannot be assured by relying on a single type of 
test (unit, functional, integration/acceptance) or by relying exclusively on quantitative 
code coverage as a measure of test thoroughness. Similarly, code quality cannot be assured 
by any single code metric or by avoiding any specific code smells. Hence the :code:`metric_fu` gem 
inspects your code for multiple metrics and smells so you can identify “hot spots” where 
multiple problems with the same piece of code call for refactoring.