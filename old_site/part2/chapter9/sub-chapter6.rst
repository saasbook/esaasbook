Method-Level Refactoring: Replacing Dependencies With Seams
====================================
    *2. Increasing Complexity - As [a software] system evolves, its complexity increases 
    unless work is done to maintain or reduce it.*

    —Lehman’s second law of software evolution

With the characterization specs developed in Section 9.3, we have a solid foundation on 
which to base our refactoring to repair the problems identified in Section 9.5. The term 
*refactoring* refers not only to a general process, but also to an instance of a specific 
code transformation. Thus, just as with code smells, we speak of a catalog of refactorings, 
and there are many such catalogs to choose from. We prefer Fowler’s catalog, so the examples 
in this chapter follow Fowler’s terminology and are cross-referenced to Chapters 6, 8, 9, 
and 10 of his book *Refactoring: Ruby Edition* (Fields et al. 2009). While the correspondence 
between code smells and refactorings is not perfect, in general each of those chapters 
describes a group of method-level refactorings that address specific code smells or problems,
and further chapters describe refactorings that affect multiple classes, which we’ll learn 
about in Chapter 11.

Each refactoring consists of a descriptive name and a step-by-step process for transforming 
the code via small incremental steps, testing after each step. Most refactorings will cause 
at least temporary test failures, since unit tests usually depend on implementation, which 
is exactly what refactoring changes. A key goal of the refactoring process is to minimize t
he amount of time that tests are failing (red); the idea is that each refactoring step is 
small enough that adjusting the tests to pass before moving on to the next step is not 
difficult. If you find that getting from red back to green is harder than expected, you must 
determine if your understanding of the code was incomplete, or if you have really broken 
something while refactoring.

Getting started with refactoring can seem overwhelming: without knowing what refactorings 
exist, it may be hard to decide how to improve a piece of code. Until you have some experience 
improving pieces of code, it may be hard to understand the explanations of the refactorings 
or the motivations for when to use them. Don’t be discouraged by this apparent chicken-and-egg 
problem; like TDD and BDD, what seems overwhelming at first can quickly become familiar.

As a start, Figure 9.15 shows four of Fowler’s refactorings that we will apply to our code. 
In his book, each refactoring is accompanied by an example and an extremely detailed list 
of mechanical steps for performing the refactoring, in some cases referring to other 
refactorings that may be necessary in order to apply this one. For example, Figure 9.16 shows 
the first few steps for applying the Extract Method refactoring. With these examples in 
mind, we can refactor Figure 9.6.

Long method is the most obvious code smell in Figure 9.6, but that’s just an overall symptom 
to which various specific problems contribute. The high ABC score (23) of :code:`convert` suggests 
one place to start focusing our attention: the condition of the if in lines 6–7 is difficult 
to understand, and the conditional is nested two-deep. As Figure 9.15 suggests, a hard-to-read 
conditional expression can be improved by applying the very common refactoring *Decompose 
Conditional*, which in turn relies on *Extract Method*. We move some code
into a new method with a descriptive name, as Figure 9.17 shows. Note that in addition to making 
the conditional more readable, the separate definition of :code:`leap_year?` makes the leap year 
calculation separately testable and provides a seam at line 6 where we could stub the method 
to simplify testing of :code:`convert`, similar to the example in the Elaboration at the end of 
Section 8.4. In general, when a method mixes code that says *what to do* with code that *says 
how to do it*, this may be a warning to check whether you need to use Extract Method in order 
to maintain a consistent level of **A**\bstraction.

.. code-block:: ruby
    :linenos:

    # NOTE: line 7 fixes bug in original version
    class TimeSetter
        def self.convert(d)
            y = 1980
            while (d > 365) do
            if leap_year?(y)
                if (d >= 366) 
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
        private
        def self.leap_year?(year)
            year % 400 == 0 ||
            (year % 4 == 0 && year % 100 != 0)
        end
    end

The conditional is also nested two-deep, making it hard to understand and increasing :code:`convert`\’s 
ABC score. The *Decompose Conditional* refactoring also breaks up the complex condition by 
replacing each arm of the conditional with an extracted method. Notice, though, that the two 
arms of the conditional correspond to lines 4 and 6 of the pseudocode in Figure 9.14, both 
of which have the *side effects* of changing the values of :code:`d` and :code:`y` (hence our use of :code:`!` in the 
names of the extracted methods). In order for those side effects to be visible to :code:`convert`, we 
must turn the local variables into class variables throughout :code:`TimeSetter`, giving them more 
descriptive names :code:`@@year` and :code:`@@days_remaining` while we’re at it. Finally, since :code:`@@year` is now 
a class variable, we no longer need to pass it as an explicit argument to :code:`leap_year?`. Figure 
9.18 shows the result.

.. code-block:: ruby
    :linenos:

    # NOTE: line 7 fixes bug in original version
    class TimeSetter
        ORIGIN_YEAR = 1980
        def self.calculate_current_year(days_since_origin)
            @@year = ORIGIN_YEAR
            @@days_remaining = days_since_origin
            while (@@days_remaining > 365) do
            if leap_year?
                peel_off_leap_year!
            else
                peel_off_regular_year!
            end
            end
            return @@year
        end
        private
        def self.peel_off_leap_year!
            if (@@days_remaining >= 366) 
            @@days_remaining -= 366 ; @@year += 1
            end
        end
        def self.peel_off_regular_year!
            @@days_remaining -= 365 ; @@year += 1
        end
        def self.leap_year?
            @@year % 400 == 0 ||
            (@@year % 4 == 0 && @@year % 100 != 0)
        end
    end

As long as we’re cleaning up, the code in Figure 9.18 also fixes two minor code 
smells. The first is uncommunicative variable names: :code:`convert` doesn’t describe very 
well what this method does, and the parameter name :code:`d` is not useful. The other is 
the use of “magic number” literal constants such as 1980 in line 4; we apply *Replace 
Magic Number with Symbolic Constant* (Fowler chapter 8) to replace it with the more 
descriptive constant name :code:`STARTING_YEAR`. What about the other constants such as 365 
and 366? In this example, they’re probably familiar enough to most programmers to 
leave as-is, but if you saw 351 rather than 365, and if line 26 (in :code:`leap_year?`) used 
the constant 19 rather than 4, you might not recognize the leap year calculation for 
the **Hebrew calendar**. Remember that refactoring only improves the code for human readers; 
the computer doesn’t care. So in such cases use your judgment as to how much refactoring is enough.

In our case, re-running flog on the refactored code in Figure 9.18 brings the ABC score
for the newly-renamed :code:`calculate_current_year` from 23.0 down to 6.6, which is well below 
the suggested NIST threshold of 10.0. Also, reek now reports only two smells. The first is 
“low cohesion” for the helper methods :code:`peel_off_leap_year` and :code:`peel_off_regular_year`; this 
is a design smell, and we will discuss what it means in Chapter 11. The second smell is 
declaration of class variables inside a method. When we applied Decompose Conditional and 
Extract Method, we turned local variables into class variables :code:`@@year` and :code:`@@days_remaining` 
so that the newly-extracted methods could successfully modify those variables’ values. Our 
solution is effective, but clumsier than *Replace Method with Method Object* (Fowler chapter 6). 
In that refactoring, the original method :code:`convert` is turned into an object *instance* (rather 
than a class) whose instance variables capture the object’s state; the helper methods then 
operate on the instance variables.

.. code-block:: ruby
    :linenos:

    # An example call would now be:
    #  year = TimeSetter.new(367).calculate_current_year
    # rather than:
    #  year = TimeSetter.calculate_current_year(367)
    class TimeSetter
        ORIGIN_YEAR = 1980
        def initialize(days_since_origin)
            @year = ORIGIN_YEAR
            @days_remaining = days_since_origin
        end
        def calculate_current_year
            while (@days_remaining > 365) do
            if leap_year?
                peel_off_leap_year!
            else
                peel_off_regular_year!
            end
            end
            return @year
        end
        private
        def peel_off_leap_year!
            if (@days_remaining >= 366) 
            @days_remaining -= 366 ; @year += 1
            end
        end
        def peel_off_regular_year!
            @days_remaining -= 365 ; @year += 1
        end
        def leap_year?
            @year % 400 == 0 ||
            (@year % 4 == 0 && @year % 100 != 0)
        end
    end

Figure 9.19 shows the result of applying such a refactoring, but there is an important 
caveat. So far, none of our refactorings have caused our characterization specs to fail, 
since the specs were just calling :code:`TimeSetter.convert`. But applying *Replace Method With 
Method Object* changes the calling interface to :code:`convert` in a way that makes tests fail. 
If we were working with real legacy code, we would have to find every site that calls :code:`convert`,
change it to use the new calling interface, and change any failing tests accordingly. In a 
real project, we’d want to avoid changes that needlessly break the calling interface, so we’d 
need to consider carefully whether the readability gained by applying this refactoring would 
outweigh the risk of introducing this breaking change.

**Self-Check 9.6.1.** *Which is not a goal of method-level refactoring: (a) reducing code 
complexity, (b) eliminating code smells, (c) eliminating bugs, (d) improving testability?*

    (c). While debugging is important, the goal of refactoring is to preserve the code’s 
    current behavior while changing its structure.