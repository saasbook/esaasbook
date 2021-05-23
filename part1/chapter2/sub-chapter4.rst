Ruby Idioms: Poetry Mode, Blocks, Duck Typing
====================================
A **programming idiom** is a way of doing or expressing something that occurs frequently in code 
written by experienced users of a given programming language. While there may be other ways to 
accomplish the same task, the idiomatic way is the one that is most readily intention-revealing 
to other experienced users of the language. Your goal when learning a new language should be to 
learn to “think in” that language by understanding and using its idioms well, or in other words, 
to avoid the well-known pitfall that “you can write FORTRAN in any language”. In this section we 
explore three key Ruby idioms: passing arguments to methods (“poetry mode” and named parameters), 
blocks, and duck typing.

.. code-block:: ruby

    link_to('Edit', {:controller => 'students', :action => 'edit'})
    link_to 'Edit',  :controller => 'students', :action => 'edit'
    link_to 'Edit', controller: 'students', action: 'edit'

**Poetry mode and named parameters.** Figures 2.7 and 2.8 show two pervasive idioms related to Ruby
method calls. The first, *poetry mode*, allows omitting parentheses around the arguments to a method
call when the parsing is unambiguous. In addition, when the last argument to a method call is a
hash, the curly braces around the hash literal can be omitted.

In early versions of Ruby, hash arguments were often used to emulate the **named parameter** feature 
(also called *keyword* *arguments*) available in languages such as Python, C#, and others. For example, 
the documentation for the :code:`link_to` method used in Figure 2.7 tells us that :code:`:controller` and :code:`:action` are 
just two of many possible additional (and optional) values that can be passed to the method. True named 
parameters became available in Ruby 2.0, as Figure 2.8 shows; nonetheless, a great deal of Ruby code written 
prior to Ruby 2.0 still uses hashes to pass optional arguments or provide default values for arguments.

**Blocks.** Ruby uses the term *block* somewhat differently than other languages do. In Ruby, a block is just a 
method without a name, or an **anonymous lambda expression** in programming-language terminology. Like a regular 
named method, it has arguments and can use local variables.

As Figure 2.9 shows, one of the most common uses of blocks is to implement data structure traversal. The instance method 
:code:`each`, available in all Ruby classes that are collection-like, takes a single argument consisting of a block (anonymous lambda) 
to which each member of the collection will be passed. :code:`each` is an example of an **internal iterator**. Rubyists like to say 
that Ruby collections “manage their own traversal,” because it’s up to the receiver
of :code:`each` to decide how to implement that method to yield each collection element. (Indeed, in Figure 2.9, we can’t even tell what 
the underlying type of :code:`movie_list` is.)

.. code-block:: ruby

    # Using 'named keyword' arguments
    def greet(name, last_name: "", greeting: "Hi")
        "#{greeting}, #{name} #{last_name}!"
    end
    greet("Dave")               # => "Hi, Dave! "
    greet("Dave", last_name: "Fox") # => "Hi, Dave Fox!"
    greet("Dave", greeting: "Yo")   # => "Yo, Dave!"
    greet("Dave", greeting: "Hey", last_name: "Patterson")
            # => "Hey, Dave Patterson!" - order of keyword args irrelevant
    greet(greeting: "Yo")              # ArgumentError, since first arg is required

.. code-block:: ruby

    def print_movies(movie_list)
        movie_list.each do |m|
            puts "#{m.title} (rated: #{m.rating})"
        end
    end

Figure 2.10 shows a simple example of such a collection operator, which can be used with any collection that 
implements :code:`each` as a way of traversing itself. Note once again that we have no idea how the collection is 
implemented: all we need to know is that it implements the instance method :code:`each` to enumerate its elements. 
Ruby provides a wide variety of such collection methods; Figure 2.11 lists some of the most useful. With some 
practice, you will automatically start to express operations on collections in terms of these functional idioms 
rather than in terms of imperative loops. Although Ruby allows :code:`for i in collection`, :code:`each` allows us to take better 
advantage of **duck typing**, which we’ll see shortly, to improve code reuse.

**Duck Typing.** You may be surprised to learn, though, that the collection methods summarized in Figure 2.11 (and several 
others not in the figure) aren’t part of Ruby’s :code:`Array` class. In fact, they aren’t even part of any superclass from which 
Array and other collection types inherit. Instead, they take advantage of an even more powerful reuse mechanism: A **mix-in** 
is a named collection of related methods that can be added to any class fulfilling some “contract” with the mixed-in methods. 
A *module* is Ruby’s method for packaging together a group of methods as a mix-in. The Ruby statement include :code:`ModuleName` inside 
a class definition mixes the instance methods, class methods, and variables of the module into that class. The collection methods 
in Figure 2.11 are defined in a module called :code:`Enumerable` that is part of Ruby’s standard library and is mixed in to all of Ruby’s 
collection classes. As its documentation states, :code:`Enumerable` requires the class mixing it in to provide an :code:`each` method, since 
:code:`Enumerable`’s collection methods are implemented in terms of :code:`each`. It doesn’t matter what class you mix it into as long as that 
class defines the :code:`each` instance method, and neither the class nor the mix-in have to declare their intentions in advance. For 
example, the :code:`each`
method in Ruby’s :code:`Array` class iterates over the array elements, whereas the :code:`each` method in the :code:`IO` class iterates over the lines of a 
file or other I/O stream. Mix-ins thereby allow reusing whole collections of behaviors across classes that are otherwise unrelated.

.. code-block:: ruby

    # find largest element in a collection
    def maximum(collection)
        result = collection.first
        collection.each do |item|
            result = item if item > result
        end
        result
    end
    maximum([3,4,2,1])     # => 4
    maximum(["a","x","b"]) # => "x"
    max([RomanNumeral.new('XL'), RomanNumeral.new('LI')] # => 'LI'

    class RomanNumeral
        include Comparable
        def initialize(roman_numeral_string)
            @orig_string = roman_numeral_string
            @value = RomanNumeral.convert_from_roman(roman_numeral_string)
        end
        def <=>(other)
            @value <=> other
        end
        def to_s
            @orig_string
        end
        def self.convert_from_roman(str)
            # ...code to convert Roman numerals from strings...
        end
    end

Similarly, a class that defines the “spaceship operator” :code:`<=>`, which returns −1,0,1 depending on whether its second argument 
is less than, equal to, or greater than its first argument, can mix in the :code:`Comparable` module, which defines :code:`<, <=, >, >=, ==,`
and :code:`between?` in terms of :code:`<=>`. For example, the :code:`Time` class defines :code:`<=>` and mixes in :code:`Comparable`, allowing you 
to write :code:`Time.now.between?(Time.parse("19:00"), Time.parse("23:15"))`.

The term “duck typing” is a popular description of this capability, because “if something looks like a duck and quacks like a duck, it might 
as well be a duck.” From :code:`Enumerable`’s point of view, if a class has an :code:`each` method, it might as well be a collection, thus allowing :code:`Enumerable` 
to provide other methods implemented in terms of :code:`each`. When Ruby programmers say that some class “quacks like an :code:`Array`,” they usually mean that 
it’s not necessarily an :code:`Array` nor a descendant of :code:`Array`, but it responds to most of the same methods as :code:`Array` and can therefore be used wherever 
an :code:`Array` would be used.

**Self-Check 2.4.1.** *Write one line of Ruby that checks whether a string s is a palindrome, that is, it reads the same backwards as forwards.* **Hint:** 
*Use the methods in Figure 2.11, and don’t forget that upper vs. lowercase shouldn’t matter: ReDivider is a palindrome.*

    :code:`s.downcase == s.downcase.reverse`

You might think you could say :code:`s.reverse=~Regexp.new(s)`, but that would fail if s happens to contain regexp metacharacters such as $.

**Self-Check 2.4.2.** *Suppose you mix* :code:`Enumerable` *into a class* :code:`Foo` *that does not provide the* :code:`each` *method. What error will be*
*raised when you call* :code:`Foo.new.map { |elt| puts elt }` *?*

    The map method in :code:`Enumerable` will attempt to call each on its receiver, but since the new :code:`Foo` object doesn’t define each, Ruby will raise an Undefined Method error.    

**Self-Check 2.4.3.** *Which statement is correct and why: (a) include ’enumerable’ (b) include* :code:`Enumerable`

    **(b)** is correct, since include expects the name of a module, which (like a class name) is a constant rather than a string.