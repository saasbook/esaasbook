Introducing Ruby,an Object-Oriented Language
====================================

Ruby is a minimalist language: while its libraries are rich, there are relatively few mechanisms *in the 
language itself*. Its world view might be described as “extreme object orienta- tion.” Two principles will 
help you quickly learn to read and write Ruby:

1. Everything is an object—even an integer—and it is literally the case that every operation is a method call on some object and every method call returns a value.
2. Like Java and Python, Ruby has conventional classes; but unlike Java public attributes or Python instance variables, only a class’s instance methods—not its instance variables—are visible outside the class. In other words, *all* access to instance variables from outside the class must take place via public **accessor methods**; instance variables lacking public accessor methods are effectively private. (Python supports a similar approach but doesn’t make it mandatory.)

Let’s break down our investigation of Ruby according to the elements proposed in the previous section and in light of the above principles.

Types, typing, and names. Ruby is dynamically typed: variables don’t have types, though the objects they refer to do. Hence 
:code:`x=’foo’ ; x=3` is legal. As row1 of Figure2.2 shows, a single or double @-sign precedes names of instance or class (static) variables, while local variables are “barewords”; all must begin with lowercase letters, and :code:`snake_case` is strongly 
preferred over :code:`camelCase`. Row 2 shows the syntax for other named entities such as classes and constants; all except globals (which you should never use anyway) *must* begin with a capital letter, with :code:`UpperCamelCase` used for class names. 
(So even though strictly speaking :code:`lowerCamelCase` is legal for local and instance variables, it’s *highly* discouraged because it is visually difficult to distinguish from :code:`UpperCamelCase` and because of the ease with which a typo can 
change the former into the latter and cause errors.) The namespaces for each kind of named entity are separate, so that foo, :code:`@foo, @@foo, FOO, Foo, $FOO` are all distinct.

In learning any new language, an annoying type-related eye-poke is having to memorize how the language handles Boolean evaluation of non-Boolean expressions. 
Some languages have special Boolean types and values, such as Python’s :code:`True` and :code:`False` (which have special type :code:`Bool`), JavaScript :code:`true` and :code:`false` (type :code:`boolean`), 
and Ruby’s :code:`true` and :code:`false` (:code:`TrueClass` and :code:`FalseClass` respectively). To avoid confusion with such actual Boolean literals, developers often say *truthy* or *falsy* 
to describe the value of a non-Boolean expression :code:`e` when used in a conditional of the form :code:`if (e)...`. Unfortunately, the rules for truthiness are different and largely 
arbitrary in each language. In Ruby, the literals :code:`false` and :code:`nil` are falsy, but *all other values*, including the number zero, the empty string, the empty array, 
and so forth, are truthy. In contrast, in Python, zero is falsy, but the empty string is truthy; in JavaScript, zero and the empty string are both falsy, as are 
the special values :code:`undefined` and :code:`null`, but the empty array is truthy; and so on. In languages that include both a true Boolean type and unary logical negation 
(usually !), writing as :code:`!!x` forces the expression to have a Boolean-valued result (for example, if :code:`x` is falsy, then :code:`!!x` is the actual Boolean value for false.

**Primitives**. Figure 2.2 shows the mostly-unsurprising syntax of basic Ruby elements. Ruby has special Boolean values (row 3) including the special value :code:`nil`, which is the usual 
result of an operation that otherwise would yield no meaningful return value, such as looking up a nonexistent key in a hash or a nonexistent value in an array.

Ruby has no separate “empty result” value such as Python :code:`none` or JavaScript :code:`null`.
That is to say: a JavaScript variable whose value is :code:`null` means that the variable references nothing in particular, 
rather than signifiying “falseness” in a Boolean sense, whereas Ruby :code:`nil` may signal either Boolean falseness or a variable that refers to nothing.

In addition to strings (row 4), Ruby also includes a type called **symbol** (row 4), such as :code:`:octocat`, essentially an immutable “token” whose value is itself. It is 
typically used for enumerations, like an :code:`enum` type in C or Java, though it has other purposes as well. A
symbol is not the same as a string, but as the figure shows, strings and symbols can be easily converted to each other.

Row 6 and Figure 2.3 summarize Ruby’s straightforward support for manipulating regu- lar expressions and capturing the results of regex matches. 
Given the amount of text handling done by modern SaaS apps, mastering regexes and understanding how a new language provides access to a regex 
engine is *de rigeur* for programmers.

Collections (rows 7–9: arrays and hashes) can combine keys and values of different types. Hashes in particular, also called associative arrays or 
hashmaps in other languages, are ubiquitous in Ruby.

Every Ruby statement is an expression that returns a value; assignments return the value of their left-hand side, that is, the value of the variable 
or other** L-value** that was just assigned to.

**Methods**. A method is defined with def :code:`method_name(arg1,...,argN)` and ends with :code:`end`. All statements in between are the method definition. All methods 
return a value; if a method doesn’t have an explicit :code:`return` statement, the value of the last expression evaluated in the method is its return value, 
which is always well-defined since every Ruby state- ment results in a value.

Everything in Ruby, even a lowly integer, is a full-fledged object that is an instance of some class. Every operation, without exception, are performed by calling a 
method on an object. The notation :code:`obj.meth()` calls method :code:`meth` on the object :code:`obj`, which is said to be the *receiver* and is expected to be able to *respond to* :code:`meth`. 
For example, the expression :code:`5.class()` *sends* the method call :code:`class` with no arguments to the object :code:`5`. The :code:`class` method happens to return the class that an object 
belongs to, in this case :code:`Fixnum`.

As we’ll see in more detail in the next section, Ruby allows omitting parentheses around argument lists when doing so does not result in ambiguous parsing. 
Hence :code:`5.class` is equivalent to :code:`5.class()`.

Furthermore, since everything is an object, the result of every expression is, by definition, something on which you can call other methods. Hence :code:`(5.class).superclass` 
tells you what :code:`Fixnum`’s superclass is, by sending the :code:`superclass` method call with no arguments to :code:`Fixnum`, an object representing the class to which :code:`5` belongs. 
Method calls associate to the left, so this example could be written :code:`5.class.superclass`. Such *method chaining* is extremely idiomatic in Ruby.

As Figure 2.4 shows, even basic math operations and array references are actually method calls on their receivers. Hence, concepts such as **type casting** rarely apply in Ruby: 
while you can certainly call :code:`5.to_s` or :code:`"5".to_i` to convert between strings and integers, for example, writing :code:`a+b` means calling method :code:`+` on receiver a, so the behavior depends 
entirely on how :code:`a`’s class (or one of its ancestors or mix-ins) implements the instance method :code:`+`. Hence, both :code:`3+2` and :code:`"foo"+"bar"` are legal Ruby expressions, but the first one 
calls :code:`+` as defined in :code:`Numeric` (the ancestor class of :code:`Fixnum`) whereas the second calls :code:`+` as defined
in :code:`String`. Rubyists write :code:`ClassName#method` to indicate the instance method :code:`method` in :code:`ClassName` and :code:`ClassName.method` to indicate the class (static) method method in :code:`ClassName`. 
We can therefore say that the expression :code:`3+2` results in calling :code:`Fixnum#+` on the receiver :code:`3`.

**Abstraction and encapsulation.** Ruby supports traditional inheritance, using the notation :code:`class SubFoo<Foo` to indicate that :code:`SubFoo` is a subclass of :code:`Foo`. A class can 
inherit from at most one superclass (Ruby lacks multiple inheritance), and all classes ultimately inherit from :code:`BasicObject`, sometimes called the *root class*, which has 
no superclass. As with most languages that support inheritance, if an object receives a call for a method not defined in its class, the call will be passed up to the superclass, 
and so on until the root class is reached or an *undefined method* exception is raised. The default constructor for a class must be a method named :code:`initialize`, but it is always 
called as :code:`Foo.new`—that is an idiosyncrasy of the language. Classes can have both class (static) methods and instance methods, and both class (static) variables and instance 
variables. Class variable names begin with :code:`@@` and instance variable names begin with :code:`@`. Class and instance method names look the same.

Probably most surprising thing to newcomers learning about Ruby’s class machinery is that there is *no direct access* to class or *instance variables* from outside the class at all. 
In other languages, certain instance variables of a class can be declared public, such as attributes in Java. In Ruby, access to class or instance state must be through **getter 
and setter methods**, also collectively called *accessor methods*. Figure 2.5 shows examples of getters (lines 10–12, 16), setters (lines 13–15: note that setter methods conventionally 
have names ending in :code:`=`, allowing syntax such as line 33 shows), and a simple instance method that accesses other instance variables (line 18). From the caller’s point of view in 
lines 33–34, it is impossible to tell whether a given method simply “wraps” access to an instance variable (as :code:`title` does) or produces its result by computing something 
(as :code:`full_title` does). This design choice illustrates Ruby’s hard-line position on the **Uniform Access Principle**, which concerns one aspect of **encapsulation** in object-oriented programming: 
It should be impossible to determine the implementation details of an object’s state or its operations from outside the object.

Beware! If you’re used to Java or Python, it’s very easy to think of the syntax in line 33
as *assignment to an attribute or instance variable*, but it is just a method call, and in fact could be written as :code:`beautiful.send(’title=’, ’La vita e bella’)`. 
Furthermore, note that any instance variable that has not previously been assigned to will silently evaluate to :code:`nil`.

.. code-block:: ruby

    class Movie
        def initialize(title, year)
            @title = title
            @year = year
        end
        # class (static) methods - 'self' refers to the actual class
        def self.find_in_tmdb(title_words)
            # call TMDb to search for a movie...
        end
        def title
            @title
        end
        def title=(new_title)
            @title = new_title
        end
        def year ; @year ; end
        # note: no way to modify value of @year after initialized
        def full_title ; "#{@title} (#{@year})"; end
    end

    # A more concise and Rubyistic version of class definition:
    class Movie
        def self.find_in_tmdb(title_words)
            # call TMDb to search for a movie...
        end
        attr_accessor :title # can read and write this attribute
        attr_reader :year    # can only read this attribute
        def full_title ; "#{@title} (#{@year})"; end
    end

    # Example use of the Movie class
    beautiful = Movie.new('Life is Beautiful', '1997')
    beautiful.title = 'La vita e bella'
    beautiful.full_title    #   => "La vita e bella (1997)"
    beautiful.year = 1998   # => ERROR: no method 'year='


.. code-block:: ruby

   #  Time#now, Time#+ and Time#- represent time as 'seconds since 1/1/70'
   class Fixnum
        def seconds  ; self ; end
        def minutes  ; self * 60 ; end
        def hours    ; self * 60 * 60 ; end
        def ago      ; Time.now - self ; end
        def from_now ; Time.now + self ; end
   end

   Time.now                # => 2018-11-22 16:58:04 +0100
   5.minutes.ago           # => 2018-11-22 16:53:12 +0100
   5.minutes - 4.minutes   # => 60
   3.hours.from_now        # => 2018-11-22 19:58:45 +0100

**Self-Check 2.3.1.** *What is the explicit-send equivalent of each of the following 
expressions:*  :code:`a<b, a==b, x[0], x[0]=’foo’`.

    :code:`a.send(:<,b), a.send(:==,b), x.send(:[],0), x.send(:[]=,0,’foo’)`

**Self-Check 2.3.2.** *Verify in an interactive Ruby interpreter that* :code:`5/4` *gives 1, but* :code:`5/4.0` *and* 
:code:`5.0/4` *both give* 1.25. *Explain this behavior by identifying which class’s / method is called 
in each case, and how you think it handles its argument.*

    In :code:`5/4` and :code:`5/4.0`, the Integer class’s / instance method is called on the receiver 5. That method performs integer 
    division if its argument is also an integer, but if its argument is a float, it converts the receiver to a float and 
    performs floating-point division. In :code:`5.0/4`, the :code:`Float` class’s / method is called, which always performs floating-point division.

**Self-Check 2.3.3.** *Why is* :code:`movie.@year=1998` *not a substitute for* :code:`movie.year=1998`?

    The notation :code:`a.b` always means “call method :code:`b` on receiver :code:`a`”, but :code:`@year` is the name of an instance variable, 
    whereas :code:`year=` is the name of an instance method.

**Self-Check 2.3.4.** *Suppose we delete line 12 from Figure 2.5. What would be the result of executing* :code:`Movie.new(’Inception’,2011).year` *?*

    Ruby would complain that the year method is undefined.

**Self-Check 2.3.5.** *In Figure 2.6, is* :code:`Time.now` *a class method or an instance 
method?*

    The fact that its receiver is a class name :code:`(Time)` tells us it’s a class method.

**Self-Check 2.3.6.** *Why does* :code:`5.superclass` *result in an “undefined method” error? (Hint: consider the 
difference between calling* :code:`superclass` *on* 5 *itself vs. calling it on the object returned by* :code:`5.class` *.
)*

    :code:`superclass` is a method defined on classes. The object :code:`5` is not itself a class, so you can’t call 
    :code:`superclass` on it

**Self-Check 2.3.7.** *Which of the following Ruby expressions are equal to each other: (a)* :code:`:foo` *(b)* :code:`%q{foo}` *(c)* :code:`%Q{foo}` *(d)* :code:`’foo’.to_sym` *(e)* :code:`:foo.to_s`

    **(a)** and **(d)** are equal to each other; (b), (c), and (e) are equal to each others

**Self-Check 2.3.8.** *What is captured by $1 when the string 25 to 1 is matched against each of the following 
regexps:*
(a) :code:`/(\d+)$/`
(b) :code:`/^\d+([^0-9]+)/`

    **(a)** the string “1” **(b)** the string “ to ” (including the leading and trailing spaces)

**Self-Check 2.3.9.** *Consider line 18 of Figure 2.5. Explain why the following would be an acceptable alternative way to define the* :code:`full_title` *method, 
and the pros and cons compared to the way it appears in the figure:*
:code:`def full_title ; "#title (#year)"; end`

    This version calls the accessor methods title and year rather than accessing the instance variables directly. Doing so decouples the 
    implementation of this method from the implementations of the underlying state of the movie (title and year).




