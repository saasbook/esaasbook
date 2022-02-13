Fallacies and Pitfalls
====================================
**Pitfall: Over-reliance or under-reliance on patterns.**

As with every tool and methodology we’ve seen, slavishly following design patterns is a 
pitfall: they can help point the way when your problem could take advantage of a proven 
solution, but they cannot by themselves ensure beautiful code. In fact, the GoF authors 
specifically warn *against* trying to evaluate the soundness of a design based on the number 
of patterns it uses. In addition, if you apply design patterns too early in your design 
cycle, you may try to implement a pattern in its full generality even though you may not 
need that generality for solving the current problem. That will complicate your design 
because most design patterns call for *more* classes, methods, and levels of indirection than 
the same code would require without this level of generality. In contrast, if you apply 
design patterns too late, you risk falling into antipatterns and extensive refactoring.

What to do? Develop taste and judgment through learning by doing. You will make some mistakes 
as you go, but your judgment on how to deliver working and maintainable code will quickly 
improve.

**Pitfall: Over-reliance on UML or other diagrams.**

A diagram’s purpose is communication of intent. Reading UML diagrams is not necessarily easier 
than reading user stories or well-factored TDD tests. Create a diagram when it
helps to clarify a class architecture; don’t rely on them as a crutch.

**Fallacy: SOLID principles aren’t needed in dynamic languages.**

As we saw in this chapter, some of the problems addressed by SOLID don’t really arise in 
dynamically-typed languages like Ruby. Nonetheless, the SOLID guidelines still represent 
good design; in static languages, there is simply a much more tangible up-front cost to 
ignoring them. In dynamic languages, while the opportunity exists to use dynamic features 
to make your code more elegant and DRY without the extra machinery required by some of the 
SOLID guidelines, the corresponding risk is that it’s easier to fall into sloth and end up 
with ugly antipattern code.

**Pitfall: Lots of private methods in a class.**

You may have already discovered that methods declared :code:`private` are hard to test, because by 
definition they can only be called from within an instance method of that class—meaning they 
cannot be called directly from an RSpec test. Although you can use a hack to temporarily make 
the method public (:code:`MyClass.send(:public,:some_private_method)`), private methods complex enough 
to need their own tests should be considered a smell: the methods themselves may be too long, 
violating the **S**\hort guideline of SOFA, and the class containing these methods may be violating 
the **Single Responsibility Principle**. In this case, consider extracting a collaborator class 
whose methods are public (and therefore easy to test and easy to shorten by refactoring) but 
are only called from the original class, thereby improving maintainability and testability.

**Pitfall: Using** :code:`initialize` **to implement factory patterns.**

In Section 11.4, we showed an example of Abstract Factory pattern in which the correct subclass 
constructor is called directly. Another common scenario is one in which you have a class A with 
subclasses A1 and A2, and you want calls to A’s constructor to return a new object of the correct 
subclass. You usually cannot put the factory logic into the :code:`initialize` method of A, because that 
method must by definition return an instance of class A. Instead, give the factory method a 
different name such as :code:`create`, make it a class method, and call it
from A’s constructor:

.. code-block:: ruby
    :linenos:
    
    class A
        def self.create(subclass, *args) # subclass must be either 'A1' or 'A2'
            return Object.const_get(subclass).send(:new, *args) 
        end
    end