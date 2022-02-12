Fallacies and Pitfalls
====================================
**Pitfall: Always watching the driver while pair programming.**

If one member of the pair has much more experience, the temptation is to let the more 
senior member do all the driving, with the more junior member becoming essentially the 
permanent observer. This relationship is not healthy, and will likely lead to 
disengagement by the junior member.


**Pitfall: Blindly following “cookbook” tutorials when learning a new language.**

Computer science legend and Turing Award winner Donald Knuth, who literally wrote the book(s) 
on the foundations of theoretical computer science, says that writing code is “harder than 
anything else I’ve ever had to do.” And Peter Norvig, Google’s Director of Research, has eloquently 
said that there is no shortcut around such a challenge: it requires deep study and lots of ongoing 
practice. Following a step-by-step tutorial without an understanding of the underlying mechanisms 
being explained will put something on the screen quickly, but you won’t understand how it got 
there nor be able to replicate this success with your own apps.

**Pitfall: Forgetting that the compiler won’t save you.**

In strongly-typed or statically-typed languages, the compiler can usually detect if a variable of one 
type is erroneously being assigned a value of an incompatible type, for example, writing :code:`x=foo()` where 
:code:`foo` returns a numeric value but :code:`x` has been declared as a string variable. In weakly-typed or dynamically-typed 
languages (Ruby is both), there are no such “compile-time” checks—instead you’ll get a runtime error. 
So you must be that much more
careful in your testing and in the design of your code. Chapter 8 will introduce techniques for ensuring 
your code is well tested. The debate over the relative merits of static vs. dynamic typing is a long-running 
“holy war” among programmers that we won’t wade into here.

**Pitfall: Writing Python in Ruby.**

It takes some mileage to learn a new language’s idioms and how it fundamentally differs
from other languages. Common examples for Python programmers new to Ruby include:

• Reading an expression such as :code:`person.age` as “the :code:`age` attribute of the :code:`person` object” rather than “call the instance method :code:`age` on the object :code:`person`.”
• Thinking that :code:`person.age=40` as *assignment* *to an attribute* when in fact it is a method call. In fact, the :code:`age= method` called on :code:`person` is passed the argument (40), and can *do whatever it wants*. Ruby code often uses this mechanism as a way to provide syntactic sugar for “assignments” that cause side effects.
• Forgetting that any instance variable that has not previously been assigned will silently evaluate to :code:`nil`.
• Thinking of :code:`attr_accessor` as a declaration of attributes. This shortcut and related ones save you work *if* you want to make an attribute publicly readable or writable. But you don’t need to “declare” an attribute in any way at all (the existence of the instance variable is sufficient) and in all likelihood some attributes *shouldn’t* be publicly visible. Resist the temptation to use :code:`attr_accessor` as if you were writing attribute declarations in Java.
• Writing explicit for-loops rather than using an iterator such as :code:`each` and the collection methods that exploit it via mix-ins such as :code:`Enumerable`. Use functional idioms like :code:`select, map, any?, all?,` and so on.
• Using :code:`lowerCamelCase` rather than :code:`snake_case` to name variables. It seems trivial, but experienced programmer find it jarring to read code that violates the typographical conventions of a language, just as experienced musicians wince when they hear a note played out of tune. If in doubt, find other Ruby code with an example of what you want to do, and emulate it.

**Pitfall: Thinking of symbols and strings as interchangeable.**

While many Rails methods are explicitly constructed to accept either a string or a symbol, the two are not in general interchangeable. 
A method expecting a string may throw an error if given a symbol, or depending on the method, it may simply fail. For example, :code:`[’foo’,’bar’].include?(’foo’)` is 
truthy, whereas :code:`[’foo’,’bar’].include?(:foo)` is falsy.

**Pitfall: Naming a local variable when you meant a local method.**

Suppose class C defines a method :code:`x=`. In an instance method of C, writing :code:`x=3` will not have the desired effect of calling the :code:`x=` method with 
the argument 3; rather, it will set a local variable :code:`x` to 3, which is probably not what you wanted. To get the desired effect, write 
:code:`self.x=3`, which makes the method call explicit.

**Pitfall: Confusing require with include.**

:code:`require` loads an arbitrary Ruby file (typically the main file for some gem), whereas :code:`include` mixes in a module. In both cases, Ruby has its own rules for 
locating the files containing the code; the Ruby documentation describes the use of :code:`$LOAD_PATH`, but you should rarely if ever need to manipulate it 
directly if you use Rails as your framework and Bundler to manage your gems.