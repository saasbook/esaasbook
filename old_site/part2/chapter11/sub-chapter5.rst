Liskov Substitution Principle
====================================

The **Liskov Substitution Principle** (LSP) is named for Turing Award winner Barbara Liskov, 
who did seminal work on subtypes that heavily influenced object-oriented programming. 
Informally, LSP states that a method designed to work on an object of type :math:`T` should also 
work on an object of any subtype of :math:`T` . That is, all of :math:`T`’s subtypes should 
preserve :math:`T`’s “contract.”

.. code-block:: ruby
    :linenos:

    class Rectangle
        attr_accessor :width, :height, :top_left_corner
        def new(width,height,top_left) ... ; end
        def area ... ; end
        def perimeter ... ; end
    end
    # A square is just a special case of rectangle...right?
    class Square < Rectangle
        # ooops...a square has to have width and height equal
        attr_reader :width, :height, :side
        def width=(w)  ; @width = @height = w ; end
        def height=(w) ; @width = @height = w ; end
        def side=(w)   ; @width = @height = w ; end
    end
    # But is a Square really a kind of Rectangle?
    class Rectangle
        def make_twice_as_wide_as_high(dim)
            self.width = 2*dim
            self.height = dim           # doesn't work!
        end
    end

This may seem like common sense, but it’s subtly easy to get wrong. Consider the code 
in Figure 11.16, which suffers from an LSP violation. You might think a :code:`Square` is just a
special case of :code:`Rectangle` and should therefore inherit from it. But *behaviorally*, a square 
is *not* like a rectangle when it comes to setting the length of a side! When you spot this 
problem, you might be tempted to override :code:`Rectangle#make_twice_as_wide_as_high` within :code:`Square`, 
perhaps raising an exception since this method doesn’t make sense to call on a :code:`Square`. But 
that would be a *refused bequest*—a design smell that often indicates an LSP violation. The 
symptom is that a subclass either destructively overrides a behavior inherited from its 
superclass or forces changes to the superclass to avoid the problem (which itself should 
indicate a possible OCP violation). The problem is that inheritance is all about implementation 
sharing, but if a subclass won’t take advantage of its parent’s implementations, it might not 
deserve to be a subclass at all.

The fix, therefore, is to again use composition and delegation rather than inheritance, as 
Figure 11.17 shows. Happily, because of Ruby’s duck typing, this use of composition and 
delegation still allows us to pass an instance of :code:`Square` to most places where a :code:`Rectangle` 
would be expected, even though it’s no longer a subclass; a statically-typed language would 
have to introduce an explicit interface capturing the operations common to both :code:`Square` and 
:code:`Rectangle`.

.. code-block:: ruby
    :linenos:

    # LSP-compliant solution: replace inheritance with delegation
    # Ruby's duck typing still lets you use a square in most places where
    #  rectangle would be used - but no longer a subclass in LSP sense.
    class Square
        attr_accessor :rect
        def initialize(side, top_left)
            @rect = Rectangle.new(side, side, top_left)
        end
        def area      ; rect.area      ; end
        def perimeter ; rect.perimeter ; end
        # A more concise way to delegate, if using ActiveSupport (see text):
        #  delegate :area, :perimeter, :to => :rectangle
        def side=(s) ; rect.width = rect.height = s ; end
    end

**Self-Check 11.5.1.** *Why is* :code:`Forwardable` *in the Ruby standard library provided as a 
module rather than a class?*

    Modules allow the delegation mechanisms to be mixed in to any class that wants to use them, 
    which would be awkward if :code:`Forwardable` were a class. That is, :code:`Forwardable` is itself an example 
    of preferring composition to inheritance!