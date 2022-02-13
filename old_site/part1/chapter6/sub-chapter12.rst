Concluding Remarks: JavaScript Past, Present and Future
====================================
JavaScript’s privileged position as the client-side language of the Web has focused a lot of energy on it. 
Just-in-time compilation (JIT) techniques and other advanced language engi- neering features are being brought 
to bear on the language, closing the performance gap with other interpreted and even some compiled languages. 
Over half a dozen **JavaScript engine** implementations and one compiler (Google’s Closure) are available as of 
this writing, most of them open source, and vendors such as Microsoft, Apple, Google, and others compete on the 
performance of their browsers’ JavaScript interpreters. As early as 2011, JavaScript was fast enough to use to 
rewrite large parts of the Palm webOS operating system. We can expect this trend to continue, because JavaScript 
is one of the first languages to receive attention when new hardware becomes available that could be useful for 
user-facing apps.

We saw over and over again in studying Ruby and Rails that productivity often goes hand in hand with conciseness. 
JavaScript’s syntax is sometimes awkward, in part be- cause JavaScript was always functional at heart (recall that 
its creator originally wanted to use Scheme as the browser scripting language) and in part because its large community 
of developers accustomed to class-oriented languages sometimes had difficulty embracing JavaScript’s alternative 
model of prototype-based inheritance.

ECMAScript version 6 (ES6) attempts to address this by providing new keywords such as class that look more familiar 
to such developers, but it’s important to remember that no new mechanisms or abilities were added to the language 
in this case. The new keywords are syntactic sugar and the underlying objects are still not classes in, say, the 
Java sense of the term. Prototype-based inheritance and lookup are still used to resolve references at runtime. Indeed, 
it is possible to create a **Source-to-source compiler**, sometimes called a *transpiler*, that consumes ES6 and emits pure 
JavaScript, as some early browsers’ implementations of ES6 did.

JavaScript’s single-threaded execution model, which some feel hampers productivity be- cause it requires event-driven 
programming, seems unlikely to change anytime soon. Some bemoan the adoption of JavaScript-based server-side frameworks 
such as Node, a JavaScript library that provides event-driven versions of the same POSIX (Unix-like) operating system 
facilities used by task-parallel code. Rails core committer Yehuda Katz summarized the opin- ions of many experienced 
programmers: when things happen in a deterministic order, such as server-side code handling a controller action in a 
SaaS app, a sequential and blocking model is easier to program; when things happen in an unpredictable order, such as 
reacting to ex- ternal stimuli like user-initiated user interface events, the asynchronous model makes more sense. Your 
authors firmly believe that the future of software is “cloud+client” apps, and our view is that it’s more important to 
choose the right language or framework for each job than to obsess about whether a single language or framework will 
become dominant for both the client and cloud parts of the app.

We covered only a small part of the language-independent DOM representation using its JavaScript API. The DOM representation 
itself has a rich set of data structures and traversal methods, and APIs are available for all major languages, such as 
the :code:`dom4j` library for Java and the Nokogiri gem for Ruby.