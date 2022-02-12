Other Testing Approaches and Terminology
====================================

The field of software testing is as broad and long-lived as software engineering and has 
its own literature. Its range of techniques includes formalisms for proving things about 
coverage, empirical techniques for selecting which tests to create, and directed-random 
testing. Depending on an organization’s “testing culture,” you may hear different terminology 
than we’ve used in this chapter. Ammann and Offutt’s *Introduction to Software Testing* 
(Ammann and Offutt 2008) is one of the best comprehensive references on the subject. Their 
approach is to divide a piece of code into **basic blocks**, each of which executes from the 
beginning to the end with no possibility of branching, and then join these basic blocks 
into a graph in which conditionals in the code result in graph nodes with multiple out-edges. 
We can then think of testing as “covering the graph”: each test case tracks which nodes in 
the graph it visits, and the fraction of all nodes visited at the end of the test suite is 
the test coverage. Ammann and Offutt go on to analyze various structural aspects of software 
from which such graphs can be extracted, and present systematic automated techniques for 
achieving and measuring coverage of those graphs.

One insight that emerges from this approach is that the levels of testing described in the 
previous section refer to control flow coverage, since they are only concerned with whether 
specific parts of the code are executed or not. Another important coverage criterion is 
*define–use coverage or DU-coverage*: given a variable x in some program, if we consider 
every place that x is assigned a value and every place that the value of x is used, 
DU-coverage asks what fraction of all *pairs* of define and use sites are exercised by 
a test suite. This condition is weaker than all-paths coverage but can find errors that 
control-flow coverage alone would miss.

Another testing term distinguishes **black-box tests**, whose design is based solely on the 
software’s external specifications, from **white-box tests** (also called *glass-box tests*), 
whose design reflects knowledge about the software’s implementation that is not implied 
by external specifications. For example, the external specification of a hash table might 
just state that when we store a key/value pair and later read that key, we should get 
back the stored value. A black-box test would specify a random set of key/value pairs to 
test this behavior, whereas a white-box test might exploit knowledge about the hash function 
to construct worst-case test data that results in many hash collisions. Similarly, white-box 
tests might focus on boundary values—parameter values likely to exercise different parts of 
the code.

**Mutation testing**, invented by Ammann and Offutt, is a test-automation technique in which 
small but syntactically legal changes are automatically made to the program’s source code, 
such as replacing :code:`a+b` with :code:`a-b` or replacing :code:`if (c)` with :code:`if (!c)`. Most such changes should 
cause at least one test to fail, so a mutation that causes *no* test to fail indicates either 
a lack of test coverage or a very strange program.

**Fuzz testing** consists of throwing random data at your application and seeing what breaks. 
In 2014, Google engineers reported that over a 2-year period, fuzz testing had helped find 
over 1,000 bugs in the open source video-processing utility :code:`ffmpeg`. Fuzz testing has been 
particularly useful for finding security vulnerabilities that are missed by both manual code 
inspection and formal analysis, including stack and buffer overflows and unchecked null 
pointers. While such memory bugs do not arise in interpreted languages like Ruby and Python 
or in type-safe and memory-safe compiled languages such as Rust, fuzz testing can still find 
interesting bugs in SaaS apps. *Random or black box fuzzing* either generates completely random 
data or randomly mutates valid input data, such as changing certain bytes of metadata in a 
JPEG image to test the robustness of the image decoder. *Smart fuzzing* incorporates knowledge 
about the app’s structure and possibly a way to specify how to construct “realistic but fake” 
fuzz data. For example, smart-fuzzing SaaS might include randomizing the variables and values 
occurring in form postings or URIs, or attempting various cross-site scripting or SQL injection 
attacks, which we’ll discuss in Chapter 12. Finally, *white-box fuzzing* uses **symbolic execution**, 
which simulates execution of a program observing the conditions under which each branch is taken 
or not, then generates fuzzed inputs to exercise the branch paths not taken during the simulated 
execution. White-box fuzzing requires no explicit knowledge of the app’s structure and can 
theoretically provide C2 (all paths) coverage, but in practice the size of the search space 
is huge, and white-box fuzzing relies on a diverse set of “seed inputs” to be effective. This 
combination of formal analysis and random directed testing is representative of the current state 
of the art in thorough software testing. For a short contemporary survey of fuzz testing, see 
Godefroid’s article in Communications of the ACM (Godefroid 2020).

**Self-Check 8.8.1.** *The Microsoft Zune music player had an infamous bug that caused all Zunes 
to “lock up” on December 31, 2008. Later analysis showed that the bug would be triggered on 
the last day of any leap year. What kinds of tests—black-box, glass-box, mutation, or 
fuzz—would have been likely to catch this bug?*

    A glass-box test for the special code paths used for leap years would have been effective. 
    Fuzz testing might have been effective: since the bug occurs roughly once in every 1460 days, 
    a few thousand fuzz tests would likely have found it.