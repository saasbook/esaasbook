Prelude: Learning to Learn Languages and Frameworks
====================================
We will use the term *stack* to refer loosely to any set of technologies—typically languages, 
frameworks, and subsystems—used in the development of a particular type of application. A major 
part of most stacks is a *framework* for building a particular type of app using a particular language 
and relying on other elements in the stack. Today, most developers learn new programming languages 
not to use them standalone, but because they want to use a particular framework or stack: Native mobile 
apps for iOS are written in Objective C; React.js apps are written in JavaScript; and the Ruby language 
had existed for 10 years before the highly productive Rails framework made it popular.

As Figure 1.6 showed, though, stacks and frameworks come and go. Thus, our approach is inspired 
by a Chinese proverb:

*Give a man a fish and you feed him for a day. Teach a man to fish and you feed him for 
a lifetime.*
    —Chinese proverb

Following this advice, our goal is not so much to give you a fish (introduce you as quickly as 
possible to a particular framework or stack) but rather to help you learn to fish—by giving you 
guidance on how to develop the conceptual vocabulary to rapidly learn new ones. In this chapter 
and the next, we will also give you a starter fish, in the form of the Ruby language and Rails 
framework. In Chapter 6, we will do the same for JavaScript and jQuery.

For concreteness, we will limit our discussion of learning a new language to imperative, object-oriented
(OO) languages. Besides Ruby and JavaScript, which we introduce in this book, other languages in this 
family include Java, Python, C++, C#, Scala, Perl, PHP, Lua, Tcl, and dozens more. As you will see, from 
the point of view of learning new languages, all of these languages are far more alike than they are 
different, because they all foster an imperative (linear, step-by-step) approach to solving programming 
problems and they all provide comparable facilities for managing complexity by encapsulating data along 
with the operations on that data.

Proficient software engineers can rapidly learn new languages, and the stacks or frame- works that use them, 
by mastering a technical vocabulary consisting of three main components:

1. Learn what’s different about the language: Most imperative OO langauges have straightforward machinery for primitives (variables, types, control flow), reuse (inheritance, interfaces), complexity management (composition, inheritance, data hiding), debugging, and library usage (importing, package/dependency management). What idioms or facilities are *different* from other recently-popular languages? How does the language manage libraries, the learning of which typically consumes far more time than learning the language itself?
2. Understand the app architecture implied by the framework: What is the application structure or set of patterns **reified** by the framework? What are the major “moving parts” of an application built using that framework, and how does their arrangement influence the way we formulate an application’s functionality in terms of that framework?
3. Associate the language’s features with the frameworks’ structure. How does the lan- guage help application writers by using language mechanisms to expose the framework’s architecture and patterns? One example, as we will see, is that the Rails frame- work relies heavily on *convention over configuration*: if you follow certain naming rules, you need not provide configuration files explaining (for example) which class in your app mediates access to which database table. Ruby supports convention over configuration through its use of reflection and metaprogramming.

Here, then, is our 8-point plan for learning a new imperative object-oriented language:


1. **Types and typing.** Is the language strongly or weakly typed, and is typing static or (as in Ruby and JavaScript) **dynamic**? In C++ and Java, a variable’s type must be declared at compile time and cannot change during program execution (static typing), and only objects of that type or a compatible subtype may ever be assigned to the variable (strong typing). In Java, for example, within the same scope, the same variable cannot be assigned first to an integer and later to a string. In Ruby, as we will see, a variable does not have a type declared at compile time (dynamic typing) and can be assigned to an object of any type (weak typing). This policy makes certain kinds of type errors easier to commit, but also enables an extremely powerful kind of code reuse called mix-ins, which are analogous to interfaces in Java but far more flexible.
2. **Primitives.**. What are primitive types (numbers, strings, collections, and so on)? What are the rules or conventions for naming things (variables, functions, classes, names- paces, and so on)? What are the basic mechanisms for variable assignment, variable scope, and control flow? What are the basic ways in which strings are manipulated, including the use of **regular expressions** and **string interpolation**?
3. **Methods.** How are methods (functions, procedures) defined and called? How are they named? How are class (static) methods differentiated from instance methods?
4. **Abstraction and Encapsulation.** How are classes defined, subclassed, and composed? What are the mechanics of specifying instance methods and variables, class (static) methods and variables, interfaces, and so on?
5. **Idioms.** What idioms differentiate the language from others you probably know, and how are they used? Prominent examples in Ruby include symbols (akin to immutable strings), blocks (also known as anonymous lambdas or closures, and heavily used in Ruby to implement **iterators**), and functional-programming idioms for operating on collections.
6. **Libraries.** What facilities does the language have for managing libraries? How are libraries and the functions available in them named, imported, and used? What tools for **package management** (also called *dependency management*) are available to ensure that an application can be reproducibly deployed by other developers or on production systems with the correct versions of all the libraries on which it depends? We return to this topic in Chapter 12.
7. **Debugging.** What debugging tools are available? Can you drop into an interactive debugger from a running program? Can you set **breakpoints** or watchpoints (data-value-based breakpoints) to stop a running program and inspect or modify its state? Is there easy access to an interactive console, **read-eval-print loop** (REPL), or other mechanism to try out short bits of code interactively?
8. **Testing**. How do you create and run automated tests? We will introduce the topic here but we will have much more to say about it in Chapter 8.

Heeding Confucius’ “I do and I understand,” we also ask: what tools are available to allow a new developer to quickly 
start experimenting with the language features and come up to speed, perhaps without requiring an elaborate installation 
procedure on their own computer?

We will use the above steps to learn just enough Ruby to allow us to dive into the popular server-side SaaS framework 
called Rails. Beware, though: while experience in other languages can help you more quickly learn a new language, 
avoid the pitfall of trying to map everything directly over. It’s common for two languages to have some features in 
common or at least some features that are analogous, but if there were *no* conceptual differences between two languages, 
one of the two would be redundant. Therefore, resist the temptation to ask “Is feature *x* in Ruby the same as feature *y* 
in Python or Java?” Look for analogies and similarities, but don’t expect complete isomorphism.

