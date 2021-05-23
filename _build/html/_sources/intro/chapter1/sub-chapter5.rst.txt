Productivity: Conciseness, Synthesis, Reuse, and Tools
====================================
Moore’s Law meant hardware resources have doubled every 18 months for 
nearly 50 years. These faster computers with much larger memories could 
run much larger programs. To build bigger applications that could take 
advantage of the more powerful computers, software engineers needed to 
improve their productivity.

Engineers developed four fundamental mechanisms to improve their productivity:

1. Clarity via conciseness
2. Synthesis
3. Reuse
4. Automation via Tools

One of the driving assumptions of improving productivity of programmers is that 
if programs are easier to understand, then they will have fewer bugs and to be 
easier to evolve. A closely related corollary is that if the program is smaller, 
it’s generally easier to understand. We capture this notion with our motto of 
“clarity via conciseness.”

Programming languages do this two ways. The first is simply offering a syntax 
that lets programmers express ideas naturally and in fewer characters. For example, 
below are two ways to express a simple assertion:

:code:`assert_greater_than_or_equal_to(a, 7)` vs. :code:`expect(a).to be >= 7`

It’s easy to imagine momentary confusion about the order of arguments in the first 
version in addition to the higher cognitive load of reading twice as many characters. 
The second version (which happens to be legal Ruby) is shorter and easier to read and 
understand, and will likely be easier to maintain.

The other way to improve clarity is to raise the level of abstraction. That initially 
meant the invention of higher-level programming languages such as Fortran and COBOL. 
This step raised the engineering of software from assembly language for a particular 
computer to higher-level languages that could target multiple computers simply by 
changing the compiler.

As computer hardware performance continued to increase, more programmers were willing 
to delegate tasks to the compiler and runtime system that they formerly performed themselves. 
For example, Java and similar languages took over memory management from the earlier C and 
C++ languages. Scripting languages like Python and Ruby have raised the level of abstraction 
even higher. Examples are **reflection**, which allows programs to observe themselves, and **higher 
order functions**, which allows higher-level behaviors to be reused by passing functions as 
arguments to other functions. This higher level of abstractions made programs more concise 
and therefore (usually) easier to read, understand, and maintain. To highlight examples that 
improve productivity via conciseness, we will use the “Concise” icon.

The second productivity mechanism is synthesis; that is, code that is generated automatically 
rather than created manually. Logic synthesis for hardware engineers meant that they
could describe hardware as Boolean functions and receive highly optimized transistors 
that implemented those functions. The classic software synthesis example is **Bit blit**. This graphics 
primitive combines two bitmaps under control of a mask. The straightforward approach would include 
a conditional statement in the innermost loop to chose the type of mask, but it was slow. The 
solution was to write a program that could synthesize the appropriate special-purpose code 
*without* the conditional statement in the loop. We’ll highlight examples that improve productivity 
by generating code with this “CodeGen” gears icon. The Rails framework makes extensive use of the 
Ruby language’s facilities for **metaprogramming**, which allows Ruby programs to automatically 
synthesize code at runtime.

The third productivity mechanism is to reuse portions from past designs rather than write everything 
from scratch. As it is easier to make small changes in software than in hardware, software is even 
more likely than hardware to reuse a component that is almost but not quite a correct fit. We highlight 
examples that improve productivity via reuse with this “Reuse” recycling icon.

Procedures and functions were invented in the earliest days of software so that different parts of the 
program could reuse the same code with different parameter values. Standardized libraries for 
input/output and for mathematical functions soon followed, so that programmers could reuse code developed by others.

Procedures in libraries let you reuse implementations of individual tasks. But more com- monly, programmers want 
to reuse and manage **collections** of tasks. The next step in software reuse was therefore **object-oriented programming**, 
where you could reuse the same tasks with different objects via the use of inheritance in languages like C++ and Java.

While inheritance supported reuse of implementations, another opportunity for reuse is a general strategy for doing 
something even if the implementation varies. **Design patterns**, inspired by work in civil architecture (Alexander et al. 
1977), arose to address this need. Language support for reuse of design patterns includes **dynamic typing**, which 
facilitates composition of abstractions, and **mix-ins**, which offer ways to collect functionality from multiple methods 
without some of the pathologies of multiple inheritance found in some object oriented programming. Python and Ruby 
are examples of languages with features that help with reuse of design patterns.

Note that reuse does *not* mean copying and pasting code so that you have very similar code in many places. The problem 
with copying and pasting code is that you may not change all the copies when fixing a bug or adding a feature. Here 
is a software engineering guideline that guards against repetition:

*Every piece of knowledge must have a single, unambiguous, authoritative representation within a 
system.*
    —Andy Hunt and Dave Thomas, 1999

This guideline has been captured in the motto and acronym: **Don’t Repeat Yourself (DRY)**. We’ll use a towel as the 
“DRY” icon to show examples of DRY in the following chapters.

Ruby and JavaScript, which we use in this book, are typical of modern scripting languages in including automatic memory 
management, dynamic typing, support for higher-order func- tions, and various mechanisms for code reuse. By including 
important advances in program- ming languages, Ruby goes beyond languages like Perl in supporting multiple programming 
paradigms such as object-oriented and **functional programming**.

Finally, a core value of computer engineering is finding ways to replace tedious manual tasks with tools to save time, 
improve accuracy, or both. Obvious Computer Aided Design (CAD) tools for software development are compilers and interpreters 
that raise the level of abstraction and generate code as mentioned above, but there are also more subtle productivity 
tools like Makefiles and version control systems (see Section 10.3) that automate tedious tasks. We highlight tool examples 
with the hammer icon.

The tradeoff is always the time it takes to learn a new tool versus the time saved in applying it. Other concerns are the 
dependability of the tool, the quality of the user experience, and how to decide which one to use if there are many choices. 
Nevertheless, one of the software engineering tenets of faith is that a new tool can make our lives better.

Your authors embrace the value of automation and tools. That is why we show you several tools in this book to make you more 
productive. The good news is that any tool we show you will have been vetted to ensure its dependability and that time to 
learn will be paid back many times over in reduced development time and in the improved quality of the final result. For 
example, Chapter 7 shows how **Cucumber** helps automate turning user stories into integration tests and how **Pivotal Tracker** 
automatically measures **Velocity**, which is a measure of the rate of adding features to an application. Chapter 8 introduces 
**RSpec**, which helps automate the unit testing process. The bad news is that you’ll need to learn several new tools. However, 
we think the ability to quickly learn and apply new tools is a requirement for success in engineering software, so it’s a 
good skill to cultivate.

Thus, our fourth productivity enhancer is automation via tools. We highlight examples that use automation with the robot icon, although 
they are often also associated with tools.

**Self-Check 1.5.1.** *Which mechanism is the weakest argument for productivity benefits of compilers for high-level programming languages: 
Clarity via conciseness, Synthesis, Reuse, or Automation and Tools?*

    Compilers make high-level programming languages practical, enabling programmers to improve productivity via writing the more concise code 
    in a HLL. Compilers do synthesize lower-level code based on the HLL input. Compilers are definitely tools. While you can argue that HLL 
    makes reuse easier, reuse is the weakest of the four for explaining the benefits of compilers.