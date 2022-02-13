Establishing Ground Truth With Characterization Tests
======================================================
If there are no tests (or too few tests) covering the parts of the code affected by your 
planned changes, you’ll need to create some tests. How do you do this given limited 
understanding of how the code works now? One way to start is to establish a baseline for 
“ground truth” by creating **characterization tests**: tests written after the fact that 
capture and describe the *actual, current* behavior of a piece of software, even if that 
behavior has bugs. By creating a **R**\epeatable automatic test (see Section 8.1) that mimics 
what the code does right now, you can ensure that those behaviors stay the same as you 
modify and enhance the code, like a high-level regression test.

It’s often easiest to start with an integration-level characterization test such as a Cucumber 
scenario, since these make the fewest assumptions about how the app works and focus only on the 
user experience. Indeed, while good scenarios ultimately make use of a “domain language” rather 
than describing detailed user interactions in imperative steps (Section 7.8), at this point 
it’s fine to start with imperative scenarios, since the goal is to increase coverage and provide 
ground truth from which to create more detailed tests. Once you have some green integration 
tests, you can turn your attention to unit- or functional-level tests, just as TDD follows BDD 
in the outside-in Agile cycle.

.. code-block:: ruby

    # WARNING! This code has a bug! See text!
    class TimeSetter
        def self.convert(d)
            y = 1980
            while (d > 365) do
            if (y % 400 == 0 ||
                (y % 4 == 0 && y % 100 != 0))
                if (d > 366) 
                d -= 366
                y += 1
                end
            else
                d -= 365
                y += 1
            end
            end
            return y
        end
    end

Whereas integration-level characterization tests just capture behaviors that we observe without 
requiring us to understand *how* those behaviors happen, a unit-level characterization test seems 
to require us to understand the implementation. For example, consider the code in Figure 9.6. 
As we’ll discuss in detail in the next section, it has many problems, not least of which is 
that it contains a bug. The method :code:`convert` calculates the current year given a starting year 
(in this case 1980) and the number of days elapsed since January 1 of that year. If 0 days 
have elapsed, then it is January 1, 1980; if 365 days have elapsed, it is December 31, 1980, 
since 1980 was a leap year; if 366 days have elapsed, it is January 1, 1981; and so on. How 
would we create unit tests for :code:`convert` without understanding the method’s logic in detail?

Feathers describes a useful technique for “reverse engineering” specs from a piece of code we 
don’t yet understand: create a spec with an assertion that we know will probably fail, run 
the spec, and use the information in the error message to change the spec to match actual 
behavior. Essentially, we create specs that assert incorrect results, then fix the specs based 
on the actual test behavior. Our goal is to capture the current behavior as completely as 
possible so that we’ll immediately know if code changes break the current behavior, so we 
aim for 100% C0 coverage (even though that’s no guarantee of bug-freedom!), which is challenging 
because the code as presented has no seams. Doing this for convert results in the specs in 
Figure 9.7 and even finds a bug in the process!

.. code-block:: ruby 

    require 'simplecov' 
    SimpleCov.start
    require './time_setter' 
    describe TimeSetter do
        { 365 => 1980, 366 => 1981, 900 => 1982 }.each_pair do |arg,result| 
            it "#{arg} days puts us in #{result}" do
                expect(TimeSetter.convert(arg)).to eq(result) 
            end
        end 
    end

Feathers describes a useful technique for “reverse engineering” specs from a piece of code 
we don’t yet understand: create a spec with an assertion that we know will probably fail, 
run the spec, and use the information in the error message to change the spec to match actual 
behavior. Essentially, we create specs that assert incorrect results, then fix the specs based 
on the actual test behavior. Our goal is to capture the current behavior as completely as 
possible so that we’ll immediately know if code changes break the current behavior, so we 
aim for 100% C0 coverage (even though that’s no guarantee of bug-freedom!), which is challenging 
because the code as presented has no seams. Doing this for :code:`convert` results in the specs in 
Figure 9.7 and even finds a bug in the process!

**Self-Check 9.3.1.** *State whether each of the following is a goal of unit and functional 
testing, a goal of characterization testing, or both:a*

*i Improve coverage*

*ii Test boundary conditions and corner cases*

*iii Document intent and behavior of app code*

*iv Prevent regressions (reintroduction of earlier bugs)*

    (i) and (iii) are goals of unit, functional, and characterization testing. (ii) and 
    (iv) are goals of unit and functional testing, but non-goals of characterization testing.

