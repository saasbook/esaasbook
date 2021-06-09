Concluding Remarks: TDD vs. Conventional Debugging
===================================================
In this chapter we’ve used RSpec to develop a method using TDD with unit tests. Although 
TDD may feel strange at first, most people who try it quickly realize that they already 
use the unit-testing techniques it calls for, but in a different workflow. Often, a typical 
developer will write some code, assume it probably works, test it by running the whole 
application, and hit a bug. As an MIT programmer lamented at the first software engineering 
conference in 1968: “We build systems like the Wright brothers built airplanes—build the whole 
thing, push it off a cliff, let it crash, and start over again.”

Once a bug has been hit, if inspecting the code doesn’t reveal the problem, the typical 
developer would next try inserting print statements around the suspect area to print out the 
values of relevant variables or indicate which path of a conditional was followed. The TDD 
developer would instead write assertions using :code:`expect`.

If the bug still can’t be found, the typical developer might isolate part of the code by 
carefully setting up conditions to skip over method calls they don’t care about or change 
variable values to force the code to go down the suspected buggy path. For example, they 
might do this by setting a breakpoint using a debugger and manually inspecting or manipulating 
variable values before continuing past the breakpoint. In contrast, the TDD developer would 
isolate the suspect code path using stubs and mocks to control what happens when certain 
methods are called and which direction conditionals will go.

By now, the typical developer is absolutely convinced that he’ll certainly find the bug and 
won’t have to repeat this tedious manual process, though this usually turns out to be wrong. 
The TDD developer has isolated each behavior in its own spec, so repeating the process just 
means re-running the spec.

In other words: If we write the code first and have to fix bugs, we end up using the same 
techniques required in TDD, but less efficiently and more manually, hence less productively.

But if we use TDD, bugs can be spotted immediately as the code is written. If our code works 
the first time, using TDD still gives us a regression test to catch bugs that might creep
into this part of the code in the future.

• *How Google Tests Software* (Whittaker et al. 2012) is a rare glimpse into how Google has scaled up and adapted the techniques described in this chapter to instill a culture of testing that is widely admired by its competitors.
• The online RSpec documentation gives complete details and additional features used in advanced testing scenarios.
• *The RSpec Book* (Chelimsky et al. 2010) is the definitive published reference to RSpec and includes examples of features, mechanisms and best practices that go far beyond this introduction.