Coverage Concepts and Types of Tests
====================================

How much testing is enough? A poor but unfortunately widely-given answer is “As much 
as you can before the release deadline.” A very coarse-grained alternative is the 
*code-to-test ratio*, the number of non-comment lines of code divided by number of 
lines of tests of all types. In production systems, this ratio is usually less than 1, 
that is, there are more lines of test than lines of app code. The command :code:`rake stats` 
issued in the root directory of a Rails app computes this ratio based on the number of 
lines of RSpec tests and Cucumber scenarios.

Another widely-used metric that is more conservative is “when the rate of new bug reports 
falls below some threshold.” This formulation acknowledges that while code can never be 
proven bug-free, bugs are getting harder to find. But a more precise way to approach the 
question is to combine such metrics with **code coverage**. Since the goal of testing is to 
exercise the subject code in at least the same ways it would be exercised in production, 
what fraction of those possibilities is actually exercised by the test suite? Surprisingly, 
measuring coverage is not as straightforward as you might suspect. Figure 8.12 shows a simple 
fragment of code that we will use to illustrate the definitions of several commonly-used 
coverage terms.

.. code-block:: ruby

    class MyClass 
        def foo(x,y,z)
            if x
                if (y && z) then bar(0) end
            else
                bar(1)
            end 
        end
        def bar(x) ; @w = x ; end 
    end

• S0 or Method coverage: Is every method executed at least once by the test suite? Satisfying S0 requires calling :code:`foo` and :code:`bar` at least once each.
• S1 or Call coverage or Entry/Exit coverage: Has each method been called from every place it could be called? Satisfying S1 requires calling bar from both line 4 and line 6.
• C0 or Statement coverage: Is every statement of the source code executed at least once by the test suite, counting both branches of a conditional as a single statement? In addition to calling :code:`bar`, satisfying C0 would require calling :code:`foo` at least once with :code:`x` true (otherwise the statement in line 4 will never be executed), and at least once with :code:`y` false.
• C1 or Branch coverage: Has each branch been taken in each direction at least once? Satisfying C1 would require calling :code:`foo` with both false and true values of :code:`x` and with values of :code:`y` and :code:`z` such that :code:`y && z` in line 4 evaluates once to true and once to false. A more stringent condition, *decision coverage*, requires that each *subexpression* that independently affects a conditional expression be evaluated to true and false. In this example, a test would additionally have to separately set :code:`y` and :code:`z` so that the condition :code:`y && z` fails once for :code:`y` being false and once for :code:`z` being false.
• C2 or Path coverage: Has every possible route through the code been executed? In this simple example, where :code:`x,y,z` are treated as booleans, there are 8 possible paths.
• Modified Condition/Decision Coverage (MCDC) combines a subset of the above levels: Every point of entry and exit in the program has been invoked at least once, every decision in the program has taken all possible outcomes at least once, and each condi- tion in a decision has been shown to independently affect that decision’s outcome.

Achieving C0 coverage is relatively straightforward, and a goal of 100% C0 coverage is not 
unreasonable. Achieving C1 coverage is more difficult since test cases must be constructed 
more carefully to ensure each branch is taken at least once in each direction. C2 coverage 
is most difficult of all, and not all testing experts agree on the additional value of 
achieving 100% path coverage. Therefore, code coverage statistics are most valuable to the 
extent that they highlight undertested or untested parts of the code and show the overall 
comprehensiveness of your test suite. The SimpleCov gem is easy to configure and measures 
and displays the C0 and C1 coverage of your specs, allowing you to browse file-by-file to 
see which lines of your app were exercised by your test suites. If you have multiple suites, 
such as a set of Cucumber features as well as a set of specs, you must decide whether you need 
to know only whether a particular line of your app is exercised by *some* test, which may be 
either a Cucumber scenario or an RSpec example, or whether you need to know which type of 
test exercised it. SimpleCov does the former by default, but its instructions tell you how 
to do the latter.

This chapter, and the above discussion of coverage, have focused on unit tests. Chapter 7 
explained how user stories could become automated acceptance tests; we can think of a Cucumber 
scenario as both a **system test**, because it exercises code in many different parts of the 
application in the same ways a user would, as well as an **acceptance test**, because a 
properly-written scenario reflects and verifies the behavior the user said they wanted. 
In SaaS, such tests may also be called *full-stack tests*, since a typical scenario exercises 
every part of the app from the browser-based UI to the database. Unlike unit tets, system 
tests rarely rely on test doubles to isolate behavior; on the contrary, the goal is to simulate 
real users as closely as possible.

Any test that covers more than one method but is not a full-stack test is generically an 
**integration test**. For example, an RSpec test of a controller action would probably stub out 
calls to the database and bypass the routing mechanism, neither of which is central to testing 
the controller action itself, but would probably include interactions with mechanisms such as 
parsing form input, which clearly are outside the controller action.

System and integration tests are important, but insufficient. Their resolution is poor: if an 
integration test fails, it is harder to pinpoint the cause since the test touches many parts 
of the code. Especially for system tests, coverage also tends to be poor because even though 
a single scenario touches many classes, it executes only a few code paths in each class. For 
the same reason, system and integration tests also tend to take longer to run. On the other 
hand, while unit tests run quickly and can isolate the subject code with great precision 
(improving both coverage resolution and error localization), because they rely on fake objects 
to isolate the subject code, they may mask problems that would only arise in integration tests. 
In other words, high assurance requires both good coverage and a mix of all three kinds of 
tests. Figure 8.13 summarizes the relative strengths and weaknesses of different types of tests.

We have focused on testing for correctness (“did you build the thing right,”) but in practice, 
other flavors of tests are part of any comprehensive test suite:

• A **smoke test** consists of a minimal attempt to operate the software, to see whether anything is obviously wrong before running the rest of the test suite. For example, if a low-level coding error prevents a SaaS app from displaying its home page or accepting logins, there is no point in running further tests.
• **Compatibility testing** is less prominent in SaaS since the app developers control the server environment, but may still be important for testing the app’s UI in different browsers. For example, Sauce Labs supports running SaaS integration tests on a variety of browsers and operating systems to check correct client behavior, and even captures a screencast of each run so you can visually check behaviors such as whether the same fonts look good in different browsers.
• **Regression testing** ensures that previously-fixed bugs do not reappear. We return to regression tests in Section 10.6.
• **Performance, stress,** and w[Computer security]security testing are types of **non-functional testing** that ensure the software meets these operational criteria, which are particularly important for SaaS. We return to these in Chapter 12.
• **Accessibility testing** ensures that the software is usable by persons with disabilities. In SaaS, accessibility testing focuses primarily on the client-side user experience.

**Self-Check 8.7.1.** *Why does high test coverage not necessarily imply a well-tested 
application?*

    Coverage says nothing about the quality of the tests. However, low coverage certainly 
    implies a poorly-tested application.

**Self-Check 8.7.2.** *What is the difference between C0 code coverage and code-to-test 
ratio?*

    C0 coverage is a *dynamic* measurement of what fraction of all statements are executed by a 
    test suite. Code-to-test ratio is a *static* measurement comparing the total number of lines 
    of code to the total number of lines of tests.