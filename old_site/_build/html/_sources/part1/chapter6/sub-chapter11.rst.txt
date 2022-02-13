Fallacies and Pitfalls
====================================
**Pitfall: Disregarding the credibility of a source of information about JavaScript.**

When JavaScript was embedded into browsers, it immediately became the one programming language that 
literally anyone with a browser could code in, and their creations could be deployed on the Web to boot. 
One unfortunate side effect of this rapid explosion in use is that there is a *lot* of bad JavaScript code 
out there, and trying to find good, sound advice online for “how to do X in JavaScript” can be like wading 
through a cesspit. Carefully vet the sources of such advice! The Mozilla Developer Network’s JavaScript 
documentation is an excellent comprehensive reference for the language itself. JavaScript The Right Way 
is primarily a curated set of links to descriptions of JavaScript best practices. And as always, don’t 
copy-paste code into your app if you don’t know where it’s been!

**Fallacy: AJAX will surely improve my app’s responsiveness because more action happens right in the browser.**

In a carefully-engineered app, AJAX may well have the *potential* to improve responsive- ness of certain interactions. 
However, many factors in using AJAX also work against this goal. Your JavaScript code must be fetched from the server, 
as must any libraries or frame- works on which it relies, such as jQuery, before any AJAX action can take place; on 
platforms such as mobile phones, this may incur an up-front latency that negates any later savings. Wide variation 
in JavaScript performance across different browser types and devices, Internet con- nection speeds spanning a range 
from 1 Mbps (smart phones) to 1000 Mbps (high-speed wired networks), and other factors beyond your control, all conspire 
to make overall AJAX performance effects difficult to predict; in some cases, AJAX may slow things down. Like all powerful 
tools, AJAX should be used with a solid understanding of precisely how and why it will improve responsiveness, rather 
than added on in the vague hope that it will somehow help because the app feels slow. The techniques in Chapter 12 will 
help you identify and resolve some common performance problems.

**Pitfall: Creating a site that fails without JavaScript rather than being enhanced by it.**

For reasons of accessibility by people with disabilities, security, and cross-browser compatibility, a well-designed site 
should work *better* if JavaScript is available, but *acceptably* otherwise. For example, GitHub’s pages for browsing code 
repos work well without JavaScript but work more smoothly and quickly with JavaScript. Try the site both ways for a great 
example of progressive enhancement. Tests also run faster without JavaScript: having a site for which JavaScript is optional 
means you can do the majority of your integration testing in the faster “headless browser” mode of Cucumber and Capybara.

**Pitfall: Silent JavaScript failures in production code.**

When an unexpected exception occurs in your Rails code, you know it right away, as we’ve already seen: your app displays an 
ugly error page, or if you’ve been care- ful, a service like Hoptoad immediately contacts you to report the error, as we 
describe in Chapter 12). But JavaScript problems manifest as silent failures—the user clicks a control or loads a page, 
and nothing happens. These problems are especially pernicious because if they occur while an AJAX request is in progress, 
the :code:`success` callback will never get called. So be warned: jQuery provides shortcuts for common uses of :code:`$.ajax()` such as 
:code:`$.get(url,data,callback)`, :code:`$.post(url,data,callback)`, :code:`$.load(url_and_selector)`, and :code:`$.getJSON(url,data,callback)`, but all 
of these fail silently if anything goes wrong, whereas :code:`$.ajax()` allows you to specify additional callbacks to be called 
in case of errors.

**Pitfall: Silent JavaScript failures in tests.**

The “silent failure” pitfall also arises when using Jasmine: if there are syntax errors in any of your JavaScript files 
or specs, when you reload the browser page that runs your Jasmine specs, you may see a blank page with no hint as to where 
the errors are. We suggest using Doug Crockford’s JSLint tool, which not only finds syntax errors but also points out 
bad habits and the use of JavaScript mechanisms that Crockford and others consider misfeatures.

Similarly, you may accidentally load HTML fixtures that result in illegal HTML. For example, you might accidentally create 
a fixture containing an element whose ID duplicates an existing element, or a fixture containing improperly-nested elements 
or HTML syntax errors. Since fixtures are loaded into an actual page when tests are run, the results of an ill-formed page 
may be unpredictable or result in silent failures.

**Pitfall: Providing only expensive server operations and relying on JavaScript to do the rest.**

If JavaScript is so powerful, why not write substantially all of the app logic in it, using the server as just a thin API 
to a database? For one thing, as we’ll see in Chapter 12, successful scaling requires *reducing* the load on the database, 
and unless the APIs exposed to your JavaScript client code are carefully thought out, there’s a risk of making needlessly 
complex database queries so that client-side JavaScript code can pick out the data it needs for each view. Second, whereas 
you have nearly complete control of performance (and therefore of the user experience) on the server side, you have nearly 
none on the client side. Because of wide variation in browser types, Internet connection speeds, and other factors beyond 
your control, JavaScript performance on each user’s browser is largely out of your hands, making it difficult to provide 
consistent performance for the user experience.

**Pitfall: Allowing HTML or JavaScript fixtures to get out of sync with the app code or each other.**


A risk of using HTML fixtures to test your AJAX functionality is that the fixtures are based on the HTML generated by your 
app, and if you change the app’s view templates without also changing the fixtures, you may be running tests against HTML 
that doesn’t match the true output of your app.

One solution is automation: this workflow from Pivotal Labs uses RSpec (Chapter 8) to automatically create fixtures from 
your app’s views for use in Jasmine tests. This solution also avoids another subtle problem: tests that operate on a small 
fixture but fail on the full-page DOM. For example, two event handlers that try to respond to the same event will probably 
do the wrong thing in production, but if they are only tested one at a time using separate fixtures, the unit tests will 
not catch this problem. Running specs using full-page “fixtures” rather than fixtures for different snippets of a page 
would solve this, and Pivotal’s automated workflow does this in an elegant way.

**Pitfall: Incorrect use of this in JavaScript functions.**

The value of :code:`this` in the body of a JavaScript function is the source of much grief and confusion for programmers new to 
the language. In particular, after seeing a couple of examples, new programmers don’t realize that the value of :code:`this` 
for a particular function is not dependent on how that function is written, but on how it is called, so different calls 
to the same function can result in different bindings for :code:`this`. A complete discussion of why :code:`this` works as it does is 
beyond the scope of this introduction, but the To Learn More section offers some pointers for those interested in delving 
deeper, which will take you into the realm of how JavaScript is influenced by its ancestors Scheme and Self.

Until you understand the issue more deeply, you can make your own code safe by following the common cases we outlined, 
which Figure 6.11 summarizes.

**Pitfall: JavaScript—the bad parts.**

    The ++ operator was invented by [Ken] Thompson for pointer arithmetic. We now know that pointer arithmetic is bad, and 
    we don’t do it anymore; it’s been implicated in buffer- overrun attacks and other evil stuff. The last popular language 
    to include the ++ operator is C++, a language so bad it was named after this operator.

    —Douglas Crockford, Programming and Your Brain, keynote at USENIX WebApps’12 conference

The entrepreneurial boom in which JavaScript was born was a time of ridiculous sched- ule pressures: LiveScript was 
designed, implemented, and released in a product in 10 days. As a result, the language has some widely-regarded misfeatures 
and pitfalls that some have compared to “gotchas” in the C language, so we urge you to use Doug Crockford’s JSLint tool to 
warn you of both potential pitfalls and opportunities to beautify your JavaScript code.

Some specific pitfalls to avoid include the following:

1. The interpreter helpfully tries to insert semicolons it believes you forgot, but sometimes its guesses are wrong and result in drastic and unexpected changes in code behavior, such as the following example:


.. code-block:: javascript

    // good: returns new object
    return {
        ok: true;
    };
    // bad: returns undefined, because JavaScript
    //  inserts "missing semicolon" after return
    return
    {
        ok: true;
    };

One good workaround is to adopt a consistent coding style designed to make “punctuation errors” quickly visible, such as 
the coding style recommended for Node.js package developers.

2. Despite a syntax that suggests block scope—for example, the body of a for-loop inside a function gets its own set of curly braces inside which additional var declarations can appear—all variables declared with var in a function are visible *everywhere* throughout that function, including to any nested functions. Hence, in a common construction such as :code:`for (var m in movieList)`, the scope of :code:`m` is the entire function in which the for-loop appears, not just the body of the for-loop itself. The same is true for variables declared with var inside the loop body. This behavior, called *function scope*, was invented in Algol 60. Keeping functions short (remember SOFA from Section 9.5?) helps avoid the pitfall of block vs. function scope.
3. An :code:`Array` is really just a object whose keys are nonnegative integers. In some JavaScript implementations, retrieving an item from a linear array is marginally faster than retrieving an item from a hash, but not enough to matter in most cases. The pitfall is that if you try to index an array with a number that is negative or not an integer, a string-valued key will be created. That is, :code:`a[2.1]` becomes :code:`a["2.1"]`.
4. The comparison operators :code:`==` and :code:`!=` perform type conversions automatically, so :code:`’5’==5.0` is true. The operators :code:`===` and :code:`!==` perform comparisons without doing any conversions. This is potentially confusing because Ruby also has a :code:`===` (“three-qual”) operator that does something quite different.
5. Equality for arrays and hashes is based on identity and not value, so :code:`[1,2,3]==[1,2,3]` is false. Unlike Ruby, in which the :code:`Array` class can define its own :code:`==` operator, in JavaScript you must work around these built-in behaviors, because :code:`==` is part of the language.
6. Strings are immutable, so methods like :code:`toUpperCase()` always return a new object. Hence write :code:`s=s.toUpperCase()` if you want to replace the value of an existing variable.
7. If you call a function with more arguments than its definition specifies, the extra arguments are ignored; if you call it with fewer, the unassigned arguments are :code:`undefined`. In either case, the array :code:`arguments[]` (within the function’s scope) gives access to all arguments that were actually passed.
8. String literals behave differently from strings created with :code:`new String` if you try to create new properties on them, as the code excerpt below shows. The reason is that JavaScript creates a temporary “wrapper object” around fake to respond to :code:`fake.newprop=1`, performs the assignment, then immediately destroys the wrapper object, leaving the “real” :code:`fake` without any :code:`newprop` property. You can set extra properties on strings if you create them explicitly with new. But better yet, don’t set prop- erties on built-in types: define your own prototype object and use composition rather than inheritance (Chapter 11) to make a string one of its properties, then set the other properties as you see fit. (This restriction applies equally to numbers and Booleans for the same reasons, but it doesn’t apply to arrays because, as we mentioned earlier, they are just a special case of hashes.)

.. code-block:: ruby

    real = new String("foo"); 
    fake = "foo";
    real.newprop = 1;
    real.newprop        //=>1
    fake.newprop = 1;   // BAD: silently fails since 'fake' isn't true object 
    fake.newprop        // => undefined

   
