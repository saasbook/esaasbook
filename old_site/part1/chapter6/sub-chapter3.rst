Classes, Functions and Constructors
====================================
In Chapter 2 we mentioned that object-orientation and class inheritance are distinct language design concepts, 
although many people mistakenly conflate them because popular languages like Java use both. While JavaScript is 
object-oriented and supports inheritance, *it does not have classes*, despite the addition of a new :code:`class` keyword 
in the ECMAScript 6 standard. However, classes have *not* been added to JavaScript; the keyword is **syntactic sugar** 
for JavaScript’s built-in mechanism of **prototype inheritance**, in which every object inherits from some 
prototype object and delegates to its prototype any slot lookup that fails on the object itself.

Unfortunately, the design of this mechanism has led to confusion for newcomers to JavaScript, especially regarding 
the behavior of the keyword this. We will concern ourselves with three common uses of :code:`this`. In this section we 
introduce the first two of these uses, and an associated pitfall. In Section 6.6 we introduce the third use.

Lines 1–8 of Figure 6.6 show a function called :code:`Movie`. This syntax for defining functions may be unfamiliar, whereas 
the alternate syntax in lines 9–11 looks comfortably familiar. Nonetheless, we will use the first syntax for two 
reasons. First, unlike Ruby, functions in JavaScript are true **first-class objects**—you can pass them around, assign 
them to variables, and so on. The syntax in line 1 makes it clear that :code:`Movie` is simply a variable whose value happens 
to be a function. Second, although it’s not obvious, the variable :code:`Movie` in line 9 is being declared in JavaScript’s 
global namespace—hardly beautiful. In general we want to minimize clutter in the global namespace, so we will usually 
create one or a few objects
named by global variables associated with our app, and all of our JavaScript functions will be the values of properties 
of those objects.

.. code-block:: javascript
    :linenos:

    let Movie = function(title,year,rating) {
        this.title = title;
        this.year = year;
        this.rating = rating;
        this.full_title = function() { // "instance method"
            return(this.title + ' (' + this.year + ')');
        };
    };
    function Movie(title,year,rating) {  // this syntax may look familiar...
    // ...
    }
    // using 'new' makes Movie the new objects' prototype:
    pianist = new Movie('The Pianist', 2002, 'R');
    pianist.full_title;   // => function() {...}
    pianist.full_title(); // => "The Pianist (2002)"
    // BAD: without 'new', 'this' is bound to global object in Movie call!!
    juno = Movie('Juno', 2007, 'PG-13'); // DON'T DO THIS!!
    juno;               // undefined
    juno.title;         // error: 'undefined' has no properties
    juno.full_title();  // error: 'undefined' has no properties

If we call the Movie function using JavaScript’s new keyword (line 13), the value of this in the function body 
will be a new JavaScript object that will eventually be returned by the function, similar to Ruby’s :code:`self` inside 
an :code:`initialize` constructor method. In this case, the returned object will have properties :code:`title`, :code:`year`, 
:code:`rating`, and :code:`full_title`, the last of which is a property whose value is a function. If line 14 looks like a function call to you, 
then you’ve been hanging around Ruby too long; since functions are first-class objects in JavaScript, this line just 
returns the value of :code:`full_title`, which is the function itself, not the result of calling it! To actually call it, we 
need to use parentheses, as in line 15. When we make that call, within the body of :code:`full_title`, this will refer to the 
object whose property the function is, in this case :code:`pianist`.

Remember, though, that while these examples look just like calling a class’s constructor and calling an instance method in 
Ruby, JavaScript has no concept of classes or instance methods. In fact, there is nothing about a particular JavaScript 
function that makes it a constructor; instead, it’s the use of new when calling the function that makes it a constructor, 
causing it to create and return a new object. The reason this works is because of JavaScript’s **prototype inheritance** 
mechanism, which we don’t discuss further (but see the Elaboration below to learn more). Nonetheless, forgetting this subtle 
distinction may confuse you when you expect class-like behaviors and don’t get them.

However, a JavaScript misfeature can trip us up here. It is (unfortunately) perfectly legal to call :code:`Movie` as a plain old 
function *without* using the :code:`new` keyword, as in line 17. If you do this, JavaScript’s behavior is completely different in 
two horrible, horrible ways. First, in the body of :code:`Movie`, :code:`this` will not refer to a brand-new object but instead to the 
*global object*, which defines various special constants such as :code:`Infinity`, :code:`NaN`, and :code:`null`, and supplies various other parts 
of the JavaScript environment. When JavaScript is run in a browser, the global object happens to be a data structure 
representing the browser window. Therefore, lines 2–5 will be creating and setting new properties of this object—clearly 
not what we intended,
but unfortunately, when :code:`this` is used in a scope where it would otherwise be undefined, it refers to the global object, a 
serious design defect in the language. (See Fallacies and Pitfalls and To Learn More if you want to learn about the reasons 
for this odd behavior, a discussion of which is beyond the scope of this introduction to the language.)

Second, since :code:`Movie` doesn’t explicitly return anything, its return value (and therefore the value of :code:`juno`) will be :code:`undefined`. 
Whereas a Ruby function returns the value of the last expression in the function by default, a JavaScript function returns 
:code:`undefined` unless it has an explicit :code:`return` statement. (The :code:`return` in line 6 belongs to the :code:`full_title` function, not to :code:`Movie` 
itself.) Hence, lines 19–20 give errors because we’re trying to reference a property (:code:`title`) on something that isn’t even 
an object.

You can avoid this pitfall by rigorously following the widespread JavaScript convention that a function’s name should be 
capitalized if and only if the function is intended to be called as a constructor using :code:`new`. Functions that are not 
“constructor-like” should be given names beginning with lowercase letters.

**Self-Check 6.3.1.** *What is the difference between evaluating* :code:`square.area` *and* :code:`square.area()` *in the following 
JavaScript code?*

.. code-block:: javascript

    let square = {
        side: 3, 
        area: function() { 
            return this.side*this.side;
        }
    };

\

    :code:`square.area()` is a function call that in this case will return 9, whereas square.area is an unapplied function object.

**Self-Check 6.3.2.** *Given the code in Self-Check 6.3.1, explain why it’s is incorrect to write* :code:`s=new square`.

    :code:`square` is just an object, not a function, so it cannot be called as a constructor (or at all).

**Self-Check 6.3.3.** *In Ruby, when a method call takes no arguments, the empty parentheses following the method call are 
optional. Why wouldn’t this work in JavaScript?*

    Because JavaScript functions are first-class objects, a function name without parentheses would be an expression whose 
    value is the function itself, rather than a call to the function.

