Introducing ECMAScript
====================================
    *Stop me if you think you’ve heard this before.*

    —variously attributed

Our fast-paced introduction to JavaScript follows the same structure proposed in Section 2.1 and used in Section 2.3 
to introduce Ruby. We’ll first review the things that are fairly standard about the language—syntax, types and names, 
control flow, and so on, as Figure 6.2 summarizes. We then introduce the idioms that are central to using the language 
but less common: prototypes, first-class functions, and higher-order functions. An excellent resource to lend depth 
to this brief overview is the JavaScript documentation maintained by the Mozilla Developer Network.

**Types and typing.** Almost everything is an object. There are only a few primitive (built-in) types: String, Number 
(64-bit double precision floating point), :code:`undefined` (having no value), :code:`null` (a specific value different from :code:`undefined`), 
Boolean (either :code:`true` or :code:`false`), and BigInt (rarely needed, for expressing integers of arbitrary magnitude that would 
overflow the :code:`Number` type). There is a new :code:`Symbol` type (which behaves similar to Ruby’s).

The most important compound type is Object, which is a collection of unordered key/value pairs; the keys are called 
*properties* or sometimes *slots*. JavaScript objects look and behave like Ruby hashes except that the property names must 
be strings, although JavaScript syntax allows omitting quotes around those strings under some circumstances. Properties 
can be added or removed after an object is created.

Finally, JavaScript has :code:`Array`s that can be indexed numerically, but they are actually implemented as objects (hashes) in 
which there is a particular relationship between property names that are integers and the array’s :code:`length` property.

**Variables and Names.** As in Ruby, variables don’t have types, but the objects they refer to do, so the same variable can 
refer to objects of different types at different times (though that’s rarely a good idea). Variable names must start with 
a letter, underscore, or dollar sign, and can also include digits, and idiomatically use :code:`UpperCamelCase` or :code:`lowerCamelCase` 
naming. A variable declaration preceded by :code:`var` or :code:`let` declares and optionally initializes the variable, as in :code:`var s="Hello world"`,
and sets the scope of that variable to be its enclosing block. Unlike Ruby, but like C, JavaScript allows blocks of code 
to be nested; a variable declared with var is visible to blocks nested inside the one in which it’s declared, whereas a 
variable declared with let is not. If your functions are short (as Chapter 9.5 suggests)

Functions are closures that carry their environment around with them, allowing them to execute properly at a different place 
and time than where they were defined. Just as anonymous blocks :code:`(do...end)` are ubiquitous in Ruby, anonymous functions 
:code:`(function() {...})` are ubiquitous in JavaScript. Classes and types matter even less than they do in Ruby—in fact, despite 
the syntactic appearance of much JavaScript code in the wild, JavaScript does not have classes that behave the way they 
would in class-oriented OO languages like Ruby and Java, despite the appearance of the new class keyword in ECMAScript 6.

Figure 6.2 shows JavaScript’s basic syntax and constructs, which should look familiar to Java and Ruby programmers. The 
Fallacies & Pitfalls section describes several JavaScript pitfalls associated with the figure; read them carefully after 
you’ve finished this chapter, or you may find yourself banging your head against one of JavaScript’s unfortunate misfeatures 
or a JavaScript mechanism that looks and works almost but not quite like its Ruby counterpart. For example, whereas Ruby 
uses nil to mean both “undefined” (a variable that has never been given a value) and “empty” (a value that is always false), 
JavaScript’s null is distinct from its :code:`undefined`, which is what you get as the “value” of a variable that has never been 
initialized.

As the first row of Figure 6.2 shows, JavaScript’s fundamental type is the :code:`object`, an
unordered collection of key/value pairs, or as they are called in JavaScript, *properties* or *slots*. The name of a 
property can be any string, including the empty string. The value of a property can be any JavaScript expression, 
including another object; it cannot be undefined.

.. code-block:: javascript

    let potatoReview = 
    {
        "potatoes": 5, 
        "reviewer": "armandofox", 
        "movie": {
            "title": "Casablanca",
            "description": "Casablanca is a classic and iconic film starring ...", 
            "rating": "PG",
            "release_date": "1942-11-26T07:00:00Z"
        } 
    };
    potatoReview['potatoes'] // => 5 
    potatoReview['movie'].title // => "Casablanca" 
    potatoReview.movie.title // => "Casablanca" 
    potatoReview['movie']['title'] // => "Casablanca" 
    potatoReview['blah'] // => undefined

JavaScript allows you to express *object literals* by specifying their properties and values directly, as Figure 6.3 shows. 
This simple object-literal syntax is the basis of **JSON**, or JavaScript Object Notation, which we introduced in Section 3.6. 
Despite its name, JSON has become a language-independent way to represent data that can be exchanged between SaaS services 
or between a SaaS client and server. In fact, lines 2–11 in the figure (minus the trailing semicolon on line 11) are a 
legal JSON representation. Officially, each property value in a JSON object can be a :code:`Number`, Unicode :code:`String`, Boolean 
(:code:`true` or :code:`false` are the only possible values), :code:`null` (empty value), or a nested :code:`Object` recursively defined. Unlike full 
JavaScript, though, in the JSON representation of an object all strings *must* be quoted, so the example in the top row 
of Figure 6.2 would need quotes around the word :code:`title` to comply with JSON syntax. Figure 6.4 summarizes a variety of 
tools for checking the syntax and style of both JavaScript code and JavaScript-related data structures and protocols 
that we’ll meet in the rest of this chapter.

The fact that a JavaScript object can have function-valued properties is used by well-engineered libraries to collect 
all their functions and variables into a single **namespace**. For example, as we’ll see in Section 6.4, jQuery defines a 
single global variable jQuery through which all features of the jQuery library are accessed, rather than littering the 
global namespace with the many objects in the library. We will follow a similar practice by defining a small number of 
global variables to encapsulate all our JavaScript code.

The term *client-side JavaScript* refers specifically to JavaScript code that is associated with HTML pages and therefore 
runs in the browser. Each page in your app that wants to use JavaScript functions or variables must include the necessary 
JavaScript code itself. The recommended and unobtrusive way to do this is using a :code:`script` tag referencing the file containing 
the code, as Figure 6.5 shows. The Rails view helper :code:`javascript_include_tag ’application’`, which generates the above tag, 
can be placed in your :code:`app/views/layouts/application.html.erb` or other layout template
that is part of every page served by your app. If you then place your code in one or more separate :code:`.js` files in 
:code:`app/assets/javascripts`, when you deploy to production Rails will do the following steps automatically:


1. Concatenate the contents of all JavaScript files in this directory;
2. Compress the result by removing blank space and performing other simple transformations (the :code:`uglifier` gem);
3. Place the result in a single large file in the :code:`public` subdirectory that will be served directly by the presentation tier with no Rails intervention;
4. Adjust the URLs emitted by :code:`javascript_include_tag` so that the user’s browser loads not only your own JavaScript files but also the jQuery library.


.. code-block:: html

    <script src="/public/javascripts/application.js"></script>


.. code-block:: html 

    <html>
        <head><title>Update Address</title></head> 
        <body>
            <!-- BAD: embedding scripts directly in page, esp. in body --> 
            <script>
            <!-- // BAD: "hide" script body in HTML comment
                // (modern browsers may not see script at all) 
            function checkValid() { // BAD: checkValid is global
                if !(fieldsValid(getElementById('addr'))) {
                // BAD: > and < may confuse browser's HTML parser 
                alert('>>> Please fix errors & resubmit. <<<');
            }
            // BAD: "hide" end of HTML comment (l.3) in JS comment: --> 
            </script>
            <!-- BAD: using HTML attributes for JS event handlers -->
            <form onsubmit="return checkValid()" id="addr" action="/update">
                <input onchange="RP.filter_adult" type="checkbox"/> 
                <!-- BAD: URL using 'javascript:' -->
                <a href="javascript:back()">Go Back</a>
            </form> 
        </body>
    </html>

This automatic behavior, supported by modern production environments including Heroku, is called the *asset 
pipeline*. Described more fully in this guide, the asset pipeline also allows us to use languages like 
CoffeeScript, as we’ll see later. You might think it wasteful for the user’s browser to load a single enormous 
JavaScript file, especially if only a few pages in your app use JavaScript and any given page only uses a small 
subset of your JavaScript code. But the user’s browser only loads the large file once and then caches it until 
you redeploy your app with changed .js files. Also, in development mode, the asset pipeline skips the “precompilation” 
process and just loads each of the JavaScript files separately, since they’re likely to be changing frequently while 
you’re developing.

**Self-Check 6.2.1.** *Is every valid JSON object parsable by JavaScript? If not, give an example of 
one that isn’t.*

    Yes, every valid JSON object is a valid JavaScript object. Whereas JSON requires quotes around every slot name, 
    JavaScript sometimes does and sometimes doesn’t, but it is always safe to use quotes.

**Self-Check 6.2.2.** *If we make sure to put slot names in quotes, is every valid JavaScript object a valid JSON 
object? If not, give an example of one that isn’t.*

    No, even if all the slot names are quoted, some JavaScript objects are *not* valid JSON. For example, if one of 
    the object’s slots is a function, that object would not be valid JSON, since JSON slot values are limited to 
    simple types (numbers, strings, Booleans) and collections (arrays or other JSON objects).